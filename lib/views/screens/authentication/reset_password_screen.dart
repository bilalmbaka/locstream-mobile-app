import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/strings.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/styling/text_style.dart';
import '../../../core/utils/extensions/integer_extensions.dart';
import '../../../core/utils/forms/text_validators.dart';
import '../../../core/utils/helpers/helpers.dart';
import '../../../view_models.dart';
import '../../widgets/app_bars/general_app_bar.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/buttons/plain_button.dart';
import '../../widgets/input_forms/app_input_form.dart';
import 'new_password_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const path = "/$routeName";
  static const routeName = "reset-password";

  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailAddressTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailAddressTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(),
      body: SingleChildScrollView(
          padding: AppHelpers.defaultPadding(),
          child:
              SizedBox(width: double.infinity, child: Center(child: _body()))),
    );
  }

  Widget _body() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            text: AppStrings.resetPassword,
            textStyle: AppTextStyle(context: context, fontSize: 24).fw900(),
          ),
          AppConstants.mediumYSpace,
          AppTextField(
            text: AppStrings.enterEmailToResetPassword,
            textStyle: AppTextStyle(context: context, fontSize: 16).fw500(),
          ),
          AppConstants.extraLargeYSpace,
          Form(
            key: _formKey,
            child: AppInputForm(
              title: AppStrings.emailAddress,
              controller: _emailAddressTextController,
              hint: AppStrings.email,
              validator: AppTextValidators.isEmail,
            ),
          ),
          40.h,
          Consumer(
            builder: (context, ref, child) => PlainButton(
              text: AppStrings.continueText,
              onTap: () {
                AppHelpers.dismissKeyboard(context);

                if (!_formKey.currentState!.validate()) {
                  return;
                }

                ref.read(resetPasswordViewModel.notifier).email =
                    _emailAddressTextController.text.trim();
                ref
                    .read(resetPasswordViewModel.notifier)
                    .requestOtp(_emailAddressTextController.text.trim());

                NavigationService.pushToScreen(
                  context: context,
                  routeName: NewPasswordScreen.routeName,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
