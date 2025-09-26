import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../../../view_models/auth/reset_password_viewmodel.dart';
import '../../widgets/app_bars/general_app_bar.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/buttons/plain_button.dart';
import '../../widgets/input_forms/app_input_form.dart';
import 'login_screen.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  static const path = "/$routeName";
  static const routeName = "new-password";

  const NewPasswordScreen({super.key});

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final _otpTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Timer? _resendOtpTimer;
  final int _maxDuration = 60;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _beginTimer();
    });
  }

  @override
  void dispose() {
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _otpTextController.dispose();
    _resendOtpTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(resetPasswordViewModel, _resetPasswordListener);

    return Scaffold(
      appBar: AppAppBar(),
      body: SingleChildScrollView(
          padding: AppHelpers.defaultPadding(),
          child: SizedBox(width: double.infinity, child: _body())),
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
            text:
                "${AppStrings.otpWasSentToEmail} \n ${ref.read(resetPasswordViewModel.notifier).email!}",
            textStyle: AppTextStyle(context: context, fontSize: 16).fw500(),
          ),
          AppConstants.extraLargeYSpace,
          _inputFields(),
          25.h,
          _resendOtpSection(),
          40.h,
          Consumer(
            builder: (context, ref, child) {
              final resetPasswordState = ref.watch(resetPasswordViewModel);

              return PlainButton(
                text: AppStrings.continueText,
                isLoading: resetPasswordState.isLoading,
                onTap: () {
                  AppHelpers.dismissKeyboard(context);

                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  ref.read(resetPasswordViewModel.notifier).resetPassword(
                      ResetPasswordDto(
                          email:
                              ref.read(resetPasswordViewModel.notifier).email!,
                          otp: _otpTextController.text.trim(),
                          password: _passwordTextController.text));
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _inputFields() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInputForm(
            title: AppStrings.enterOtp,
            controller: _otpTextController,
            hint: AppStrings.enterOtp,
            validator: AppTextValidators.isEmpty,
            keyboardType: TextInputType.number,
          ),
          AppConstants.mediumYSpace,
          AppInputForm(
            title: AppStrings.password,
            controller: _passwordTextController,
            hint: AppStrings.asterics,
            validator: AppTextValidators.isEmpty,
            hideText: true,
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
      ),
    );
  }

  Widget _resendOtpSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppTextField(
          text: AppStrings.didNotReceiveOtp,
          textStyle: AppTextStyle(context: context, fontSize: 13).fw400(),
        ),
        AppConstants.mediumXSpace,
        GestureDetector(
          onTap: () {
            _beginTimer();
            _onTapResendOtp();
          },
          child: AppTextField(
            text: (_resendOtpTimer?.tick ?? 0) != _maxDuration
                ? "00:${"${_maxDuration - (_resendOtpTimer?.tick ?? 0)}".padLeft(2, "0")}"
                : AppStrings.resend,
            textStyle: AppTextStyle(
                    context: context,
                    color: AppColors.complimentary,
                    fontSize: 14)
                .fw900(),
          ),
        )
      ],
    );
  }

  void _beginTimer() {
    _resendOtpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick == _maxDuration) {
        timer.cancel();
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  void _onTapResendOtp() {
    _beginTimer();
    ref
        .read(resetPasswordViewModel.notifier)
        .requestOtp(ref.read(resetPasswordViewModel.notifier).email!);
  }

  void _resetPasswordListener(
      ResetPasswordState? state, ResetPasswordState next) {
    if (next.isSuccess) {
      NavigationService.jumpToScreen(
        context: context,
        routeName: LoginScreen.routeName,
      );
    }

    if (next.isError) {
      AppHelpers.showToast(
        context,
        next.errorMessage ?? AppStrings.somethingWentWrong,
      );
    }
  }
}
