import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/styling/text_style.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(profileViewModel).data!;
      _userNameTextController.text = profile.userName!;
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
                        final image = await AppHelpers.pickMedia(
                          fileTypes: AppConstants.images,
                        );

                        if (image.isNotEmpty) profilePicture = image.first;
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
                          ),
                          AppTextField(
                            text: "Change",
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
                  AppInputForm(
                    controller: _userNameTextController,
                    title: AppStrings.userName,
                  ),
                ],
              ),
            ),

            Consumer(
              builder: (context, ref, child) {
                return PlainButton(
                  onTap: () {
                    ref
                        .read(editProfileViewModel.notifier)
                        .editProfile(
                          ProfileDto(
                            profilePicture: profilePicture?.path,
                            userName: _userNameTextController.text,
                          ),
                        );
                  },
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
}
