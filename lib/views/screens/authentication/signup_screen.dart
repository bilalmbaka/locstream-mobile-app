import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/views/screens/authentication/signup_email_verification_screen.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/strings.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/styling/colors.dart';
import '../../../core/styling/text_style.dart';
import '../../../core/utils/extensions/integer_extensions.dart';
import '../../../core/utils/forms/text_validators.dart';
import '../../../core/utils/helpers/helpers.dart';
import '../../../domain/entities/auth_dto.dart';
import '../../../view_models.dart';
import '../../../view_models/auth/signup_viewmodel.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/buttons/plain_button.dart';
import '../../widgets/input_forms/app_input_form.dart';
import 'login_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static const path = "/$routeName";
  static const routeName = "signup";

  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailAddressTextController = TextEditingController();
  final _userNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailAddressTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _userNameTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signupViewModel, _handleStateChange);

    return Scaffold(
      body: SingleChildScrollView(
          padding: AppHelpers.defaultPadding(top: 60),
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
            text: AppStrings.getStared,
            textStyle: AppTextStyle(context: context, fontSize: 24).fw900(),
          ),
          AppConstants.mediumYSpace,
          AppTextField(
            text: AppStrings.forOptimalExperience,
            textStyle: AppTextStyle(context: context, fontSize: 16).fw500(),
          ),
          AppConstants.extraLargeYSpace,
          Form(
            key: _formKey,
            child: _inputFields(),
          ),
          40.h,
          Consumer(
            builder: (context, ref, child) {
              final signupState = ref.watch(signupViewModel);

              return PlainButton(
                text: AppStrings.continueText,
                onTap: _handleSignup,
                isLoading: signupState.isLoading,
              );
            },
          ),
          AppConstants.mediumYSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextField(
                text: AppStrings.haveAnAccount,
                textStyle: AppTextStyle(context: context).fw500(),
              ),
              AppConstants.smallXSpace,
              GestureDetector(
                onTap: () => NavigationService.jumpToScreen(
                    context: context, routeName: LoginScreen.routeName),
                child: AppTextField(
                  text: AppStrings.signIn,
                  textStyle: AppTextStyle(
                          context: context,
                          fontSize: 16,
                          color: AppColors.complimentary)
                      .fw900(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _inputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInputForm(
          title: AppStrings.emailAddress,
          controller: _emailAddressTextController,
          hint: AppStrings.email,
          validator: AppTextValidators.isEmail,
        ),
        AppConstants.mediumYSpace,
        AppInputForm(
          title: AppStrings.userName,
          controller: _emailAddressTextController,
          hint: AppStrings.email,
          validator: AppTextValidators.isEmail,
        ),
        AppConstants.mediumYSpace,

        AppInputForm(
          title: AppStrings.password,
          controller: _passwordTextController,
          hint: AppStrings.asterics,
          hideText: true,
          validator: AppTextValidators.isEmpty,
        ),
        AppConstants.mediumYSpace,
        AppInputForm(
          title: AppStrings.confirmPassword,
          controller: _confirmPasswordTextController,
          hint: AppStrings.asterics,
          hideText: true,
          validator: (value) {
            if (value != _passwordTextController.text) {
              return AppStrings.passwordsDoNotMatch;
            }
            return null;
          },
        ),
      ],
    );
  }

  void _handleSignup() {
    AppHelpers.dismissKeyboard(context);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    AppHelpers.resetState(ref);

    ref.read(signupViewModel.notifier).signup(
          SignupDto(
            email: _emailAddressTextController.text.trim(),
            password: _passwordTextController.text,
            userName: _userNameTextController.text.trim()
          ),
        );
  }

  void _handleStateChange(SignupState? state, SignupState next) {
    if (next.isSuccess) {
      NavigationService.pushToScreen(
          context: context,
          routeName: SignupEmailVerificationScreen.routeName);
    }

    if (next.isError) {
      AppHelpers.showToast(
          context, next.errorMessage ?? AppStrings.somethingWentWrong);
    }
  }
}
