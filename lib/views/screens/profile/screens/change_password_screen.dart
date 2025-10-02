import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/services/navigation_service.dart';
import 'package:locstream/core/utils/forms/text_validators.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/widgets/app_bars/general_app_bar.dart';
import 'package:locstream/views/widgets/buttons/plain_button.dart';
import 'package:locstream/views/widgets/input_forms/app_input_form.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  static const routeName = 'change-password';
  static const path = routeName;

  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _oldPasswordTextController = TextEditingController();
  final _newPasswordTextController = TextEditingController();
  final _confirmNewPasswordTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldPasswordTextController.dispose();
    _newPasswordTextController.dispose();
    _confirmNewPasswordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(changePasswordViewModel, (previous, next) {
      if (next.isError) {
        AppHelpers.showToast(
          context,
          next.errorMessage ?? AppStrings.somethingWentWrong,
        );
      }

      if (next.isSuccess) {
        if (mounted) {
          NavigationService.pop(context: context);
        }
      }
    });

    return Scaffold(
      appBar: AppAppBar(title: AppStrings.changePassword),
      body: AppHelpers.wrapChildWithLayoutBuilder(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 20,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppInputForm(
                    title: AppStrings.currentPassword,
                    controller: _oldPasswordTextController,
                    hint: AppStrings.asterics,
                    hideText: true,
                    validator: AppTextValidators.isEmpty,
                  ),
                  AppConstants.mediumYSpace,
                  AppInputForm(
                    title: AppStrings.newPassword,
                    controller: _newPasswordTextController,
                    hint: AppStrings.asterics,
                    hideText: true,
                    validator: AppTextValidators.isEmpty,
                  ),
                  AppConstants.mediumYSpace,

                  AppInputForm(
                    title: AppStrings.confirmNewPassword,
                    controller: _confirmNewPasswordTextController,
                    hint: AppStrings.asterics,
                    hideText: true,
                    validator: (value) {
                      if (value != _newPasswordTextController.text) {
                        return AppStrings.passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            Consumer(
              builder: (context, ref, child) {
                final changePassword = ref.watch(changePasswordViewModel);

                return PlainButton(
                  onTap: () {
                    AppHelpers.dismissKeyboard(context);

                    if (!_formKey.currentState!.validate()) return;

                    ref
                        .read(changePasswordViewModel.notifier)
                        .changePassword(
                          oldPassword: _oldPasswordTextController.text,
                          newPassword: _newPasswordTextController.text,
                        );
                  },
                  isLoading: changePassword.isLoading,
                  text: AppStrings.continueText,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
