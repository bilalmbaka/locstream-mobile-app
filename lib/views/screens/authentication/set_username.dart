import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/constants/images.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/widgets/media/image_view.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/strings.dart';
import '../../../core/styling/text_style.dart';
import '../../../core/utils/extensions/integer_extensions.dart';
import '../../../core/utils/forms/text_validators.dart';
import '../../../core/utils/helpers/helpers.dart';
import '../../widgets/app_bars/general_app_bar.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/buttons/plain_button.dart';
import '../../widgets/input_forms/app_input_form.dart';

class SetUserNameScreen extends ConsumerStatefulWidget {
  static const routeName = 'set-username';
  static const path = '/$routeName';

  const SetUserNameScreen({super.key});

  @override
  ConsumerState<SetUserNameScreen> createState() => _SetUserNameScreenState();
}

class _SetUserNameScreenState extends ConsumerState<SetUserNameScreen> {
  final _userNameTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Timer? _timer;

  @override
  void dispose() {
    _userNameTextController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: null,
      floatingActionButton: Consumer(
        builder: (context, ref, child) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Consumer(
            builder: (context, ref, child) {
              return PlainButton(
                text: AppStrings.continueText,
                onTap: ref.watch(checkUserNameAvailabilityViewModel).isSuccess
                    ? () {
                        AppHelpers.dismissKeyboard(context);

                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        if (ref
                                .read(checkUserNameAvailabilityViewModel)
                                .isSuccess ==
                            false) {
                          return;
                        }

                        // NavigationService.pushToScreen(
                        //   context: context,
                        //   routeName: Home.routeName,
                        // );
                      }
                    : null,
              );
            },
          ),
        ),
      ),
      body: AppHelpers.wrapChildWithLayoutBuilder(
        padding: AppHelpers.defaultPadding(bottom: 300),
        child: SizedBox(width: double.infinity, child: _body()),
      ),
    );
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    text: AppStrings.createUserName,
                    textStyle: AppTextStyle(
                      context: context,
                      fontSize: 24,
                    ).fw900(),
                  ),
                  AppConstants.mediumYSpace,
                  AppTextField(
                    text: AppStrings.setUserName,
                    textStyle: AppTextStyle(
                      context: context,
                      fontSize: 16,
                    ).fw500(),
                  ),
                  AppConstants.extraLargeYSpace,
                  Form(
                    key: _formKey,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final userNameAvailability = ref.watch(
                          checkUserNameAvailabilityViewModel,
                        );

                        return AppInputForm(
                          title: AppStrings.userName,
                          controller: _userNameTextController,
                          errorText: userNameAvailability.errorMessage,
                          hint: AppStrings.jhonDoe,
                          onChanged: (str) {
                            ref.read(suggestUserNameViewModel.notifier).reset();
                            if (_timer != null ||
                                str == null ||
                                str.trim() == '') {
                              _timer!.cancel();
                            }

                            _timer = Timer(Duration(seconds: 1), () {
                              if (_formKey.currentState?.validate() == true) {
                                ref
                                    .read(
                                      checkUserNameAvailabilityViewModel
                                          .notifier,
                                    )
                                    .check(userName: str!);
                              }
                            });
                          },
                          validator: AppTextValidators.isUserName,
                          // autoValidateMode: AutovalidateMode.onUserInteraction,
                          suffixIconContraints: BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Consumer(
                              builder: (context, ref, child) {
                                final suggestions = ref.watch(
                                  suggestUserNameViewModel,
                                );

                                if (suggestions.isLoading ||
                                    userNameAvailability.isLoading) {
                                  return Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 13,
                                      maxHeight: 13,
                                    ),
                                    child: CircularProgressIndicator.adaptive(),
                                  );
                                }

                                return GestureDetector(
                                  onTap: () async => await ref
                                      .read(suggestUserNameViewModel.notifier)
                                      .suggest(
                                        email: ref
                                            .read(profileViewModel)
                                            .data!
                                            .email,
                                      ),
                                  child: ImageView(
                                    image: Images.bulb,
                                    width: 3,
                                    height: 3,
                                    color: AppColors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  40.h,
                ],
              ),
            ),

            Consumer(
              builder: (context, ref, child) {
                final suggestions = ref.watch(suggestUserNameViewModel);

                if (suggestions.data == null || suggestions.data!.isEmpty) {
                  return Offstage();
                }

                return Positioned(
                  top: 240,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...suggestions.data!.map((suggestion) {
                          return GestureDetector(
                            onTap: () {
                              _userNameTextController.text = suggestion;
                              ref
                                  .read(
                                checkUserNameAvailabilityViewModel
                                    .notifier,
                              )
                                  .check(userName: suggestion);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppTextField(
                                    text: suggestion,
                                    textStyle: AppTextStyle(
                                      context: context,
                                    ).fw500(),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
