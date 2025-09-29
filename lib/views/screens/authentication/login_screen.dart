import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/views/screens/home/screens/home.dart';
import 'package:locstream/views/widgets/loading_dialog.dart';

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
import '../../../view_models/auth/login_viewmodel.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/buttons/plain_button.dart';
import '../../widgets/input_forms/app_input_form.dart';
import 'reset_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const path = '/$routeName';
  static const routeName = 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailAddressTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(logoutViewModel.notifier).logout();
    });
  }

  @override
  void dispose() {

    _emailAddressTextController.dispose();
    _passwordTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginViewModel, _loginListener);

    return Scaffold(
      body: LoadingDialog(
        state: ref.watch(loginViewModel),
        dismissOverlay: () => ref.invalidate(loginViewModel),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: AppHelpers.defaultPadding(top: 70),
            child: SizedBox(
              width: double.infinity,
              child: Center(child: _body()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            text: AppStrings.welcomeBack,
            textStyle: AppTextStyle(context: context, fontSize: 24).fw900(),
          ),
          AppConstants.extraLargeYSpace,
          _inputFields(),
          AppConstants.smallYSpace,
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                NavigationService.pushToScreen(
                  context: context,
                  routeName: ResetPasswordScreen.routeName,
                );
              },
              child: AppTextField(
                text: AppStrings.forgotPassword,
                textStyle: AppTextStyle(
                  context: context,
                  fontSize: 12,
                  color: AppColors.complimentary,
                ).fw600(),
              ),
            ),
          ),
          40.h,
          Consumer(
            builder: (context, ref, child) {
              // final loginState = ref.watch(loginViewModel);

              return PlainButton(
                text: AppStrings.continueText,
                // isLoading: loginState.isLoading,
                onTap: _login,
              );
            },
          ),
          AppConstants.mediumYSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextField(
                text: AppStrings.dontHaveAnAccount,
                textStyle: AppTextStyle(context: context).fw500(),
              ),
              AppConstants.smallXSpace,
              GestureDetector(
                onTap: () {
                  if (AppHelpers.isWeb(context)) {
                    NavigationService.jumpToScreen(
                      context: context,
                      routeName: SignupScreen.routeName,
                    );
                  } else {
                    NavigationService.pushToScreen(
                      context: context,
                      routeName: SignupScreen.routeName,
                    );
                  }
                },
                child: AppTextField(
                  text: AppStrings.getStared,
                  textStyle: AppTextStyle(
                    context: context,
                    fontSize: 13,
                    color: AppColors.complimentary,
                  ).fw900(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInputForm(
          title: AppStrings.emailAddressOrUserName,
          controller: _emailAddressTextController,
          hint: AppStrings.emailOrUserNameHint,
          validator: AppTextValidators.isEmpty,
        ),
        AppConstants.mediumYSpace,
        AppInputForm(
          title: AppStrings.enterPassword,
          controller: _passwordTextController,
          validator: AppTextValidators.isEmpty,
          hideText: true,
          hint: AppStrings.asterics,
        ),
      ],
    );
  }

  void _login() {
    AppHelpers.dismissKeyboard(context);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    AppHelpers.resetState(ref);
    ref
        .read(loginViewModel.notifier)
        .login(
          LoginDto(
            email: _emailAddressTextController.text,
            password: _passwordTextController.text,
          ),
        );
  }

  void _loginListener(LoginState? previous, LoginState next) {
    if (next.isSuccess) {
      ref.read(profileViewModel.notifier).profile = next.data!;

      NavigationService.jumpToScreen(
        context: context,
        routeName: Home.routeName,
      );
    }
  }
}
