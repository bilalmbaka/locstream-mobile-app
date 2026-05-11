import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/error_handlers/exceptions.dart';
import 'package:locstream/views/screens/authentication/signup_email_verification_screen.dart';
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
import '../../../view_models/auth/signup_viewmodel.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/buttons/plain_button.dart';
import '../../widgets/input_forms/app_input_form.dart';
import 'login_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static const path = '/$routeName';
  static const routeName = 'signup';

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

  Timer? _debouncer;

  @override
  void dispose() {
    _emailAddressTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _debouncer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signupViewModel, _handleStateChange);

    return Scaffold(
      body: LoadingDialog(
        state: ref.watch(signupViewModel),
        dismissOverlay: () => ref.invalidate(signupViewModel),
        child: SingleChildScrollView(
          padding: AppHelpers.defaultPadding(top: 60),
          child: SizedBox(
            width: double.infinity,
            child: Center(child: _body()),
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
            text: AppStrings.getStared,
            textStyle: AppTextStyle(context: context, fontSize: 24).fw900(),
          ),
          AppConstants.mediumYSpace,
          AppTextField(
            text: AppStrings.forOptimalExperience,
            textStyle: AppTextStyle(context: context, fontSize: 16).fw500(),
          ),
          AppConstants.extraLargeYSpace,
          Form(key: _formKey, child: _inputFields()),
          40.h,
          PlainButton(text: AppStrings.continueText, onTap: _handleSignup),
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
                  context: context,
                  routeName: LoginScreen.routeName,
                ),
                child: AppTextField(
                  text: AppStrings.signIn,
                  textStyle: AppTextStyle(
                    context: context,
                    fontSize: 16,
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
          title: AppStrings.emailAddress,
          controller: _emailAddressTextController,
          hint: AppStrings.email,
          validator: AppTextValidators.isEmail,
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
                  hint: 'Minimum of 5 characters',
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
                            .read(checkUserNameAvailabilityViewModel.notifier)
                            .check(userName: str.trim().toLowerCase());
                      });
                    } else {
                      _debouncer?.cancel();
                      _debouncer = null;
                      ref
                          .read(checkUserNameAvailabilityViewModel.notifier)
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
                        return Icon(Icons.close, color: AppColors.redMain);
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
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.redMain),
                    ),
                  ),

                if (userNameAvailable.isSuccess)
                  Text(
                    'Username is available',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.complimentary,
                    ),
                  ),
              ],
            );
          },
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

    if (ref.read(checkUserNameAvailabilityViewModel).isSuccess == false) {
      AppHelpers.showToast(context, 'Username not verified');

      return;
    }

    AppHelpers.resetState(ref);

    ref
        .read(signupViewModel.notifier)
        .signup(
          SignupDto(
            email: _emailAddressTextController.text,
            password: _passwordTextController.text,
            userName: _userNameTextController.text.trim().toLowerCase(),
          ),
        );
  }

  void _handleStateChange(SignupState? state, SignupState next) {
    if (next.isSuccess) {
      NavigationService.pushToScreen(
        context: context,
        routeName: SignupEmailVerificationScreen.routeName,
        data: _emailAddressTextController.text,
      );
    }
  }
}
