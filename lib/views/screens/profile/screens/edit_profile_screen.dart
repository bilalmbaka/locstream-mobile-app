import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/error_handlers/exceptions.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/core/utils/forms/text_validators.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/domain/entities/profile_dto.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/widgets/app_bars/general_app_bar.dart';
import 'package:locstream/views/widgets/app_text_field.dart';
import 'package:locstream/views/widgets/buttons/plain_button.dart';
import 'package:locstream/views/widgets/input_forms/app_input_form.dart';
import 'package:locstream/views/widgets/profile_picture.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  static const routeName = 'edit-profile';
  static const path = routeName;

  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _userNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();

  File? profilePicture;
  Timer? _debouncer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(profileViewModel).data!;
      _emailTextController.text = profile.email;
    });
  }

  @override
  void dispose() {
    _userNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileViewModel).data!;

    ref.listen(editProfileViewModel, (previous, next) {
      if (next.isSuccess) {
        ref.read(profileViewModel.notifier).profile = next.data!;
        AppHelpers.showToast(context, AppStrings.profileUpdateSuccessful);
      }

      if (next.isError) {
        if (mounted) {
          AppHelpers.showToast(
            context,
            next.errorMessage ?? AppStrings.somethingWentWrong,
          );
        }
      }
    });

    return Scaffold(
      appBar: AppAppBar(),
      body: AppHelpers.wrapChildWithLayoutBuilder(
        padding: AppHelpers.defaultPadding(bottom: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          final image = await AppHelpers.pickMedia(
                            fileType: FileType.image,
                          );

                          if (image.isNotEmpty) {
                            setState(() {
                              profilePicture = image.first;
                            });
                          }
                        } catch (e) {
                          if (e is TooLargeException) {
                            AppHelpers.showToast(
                              // ignore: use_build_context_synchronously
                              context,
                              'Max file size is 5MB',
                            );
                          }
                        }
                      },
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfilePicture(
                            initials: profile.userName![0],
                            profilePicture:
                                profilePicture?.path ??
                                profile.profilePicture?.url,
                            initialsFontSize: 70,
                            width: 150,
                            height: 150,
                          ),
                          AppTextField(
                            text: 'Change',
                            textStyle: AppTextStyle(
                              context: context,
                              fontSize: 12,
                            ).fw800(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  AppConstants.largeYSpace,
                  AppInputForm(
                    controller: _emailTextController,
                    enabled: false,
                    title: AppStrings.emailAddress,
                  ),
                  AppConstants.mediumYSpace,
                  Consumer(
                    builder: (context, ref, child) {
                      final userNameAvailable = ref.watch(
                        checkUserNameAvailabilityViewModel,
                      );

                      return Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppInputForm(
                            title: AppStrings.userName,
                            controller: _userNameTextController,
                            hint: profile.userName!,
                            validator: AppTextValidators.isUserName,
                            maxLength: 30,
                            showDefaultMaxLengthWidget: false,
                            onChanged: (String? str) {
                              if (str != null &&
                                  str.trim().isNotEmpty &&
                                  str.trim().length >= 5) {
                                _debouncer?.cancel();
                                _debouncer = null;
                                _debouncer = Timer(Duration(seconds: 1), () {
                                  ref
                                      .read(
                                        checkUserNameAvailabilityViewModel
                                            .notifier,
                                      )
                                      .check(
                                        userName: str.trim().toLowerCase(),
                                      );
                                });
                              } else {
                                _debouncer?.cancel();
                                _debouncer = null;
                                ref
                                    .read(
                                      checkUserNameAvailabilityViewModel
                                          .notifier,
                                    )
                                    .reset();
                              }
                            },
                            suffixIcon: Consumer(
                              builder: (context, ref, child) {
                                if (userNameAvailable.isLoading) {
                                  return CupertinoActivityIndicator();
                                }

                                if (userNameAvailable.isSuccess) {
                                  return Icon(
                                    Icons.check,
                                    color: AppColors.complimentary,
                                  );
                                }

                                if (userNameAvailable.exception
                                    is UserNameUnAvailableException) {
                                  return Icon(
                                    Icons.close,
                                    color: AppColors.redMain,
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                          ),

                          if (userNameAvailable.isError)
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                userNameAvailable.errorMessage ??
                                    AppStrings.somethingWentWrong,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.redMain),
                              ),
                            ),

                          if (userNameAvailable.isSuccess)
                            Text(
                              'Username is available',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.complimentary),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            Consumer(
              builder: (context, ref, child) {
                return PlainButton(
                  onTap: _onTap,
                  isLoading: ref.watch(editProfileViewModel).isLoading,
                  text: AppStrings.edit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onTap() {
    final profile = ref.read(profileViewModel).data!;

    if (_userNameTextController.text.trim().isNotEmpty) {
      if (ref.read(checkUserNameAvailabilityViewModel).isSuccess == false) {
        AppHelpers.showToast(context, 'Username not verified');

        return;
      }
    }

    ref
        .read(editProfileViewModel.notifier)
        .editProfile(
          ProfileDto(
            profilePicture: profilePicture?.path,
            userName:
                _userNameTextController.text.trim().toLowerCase() ==
                    profile.userName!.toLowerCase()
                ? null
                : _userNameTextController.text.trim().toLowerCase(),
          ),
        );
  }
}
