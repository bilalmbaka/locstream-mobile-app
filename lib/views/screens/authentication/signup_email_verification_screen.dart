import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/strings.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/styling/text_style.dart';
import '../../../core/utils/helpers/helpers.dart';
import '../../../view_models.dart';
import '../../../view_models/auth/signup_otp_viewmodel.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/otp_field.dart';

class SignupEmailVerificationScreen extends ConsumerStatefulWidget {
  static const path = "/$routeName";
  static const routeName = "signup-email-verification";

  const SignupEmailVerificationScreen({super.key});

  @override
  ConsumerState<SignupEmailVerificationScreen> createState() =>
      _SignupEmailVerificationScreenState();
}

class _SignupEmailVerificationScreenState
    extends ConsumerState<SignupEmailVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(signupOtpViewModel, _handleStateChange);

    return Scaffold(
      body: SingleChildScrollView(
          padding: AppHelpers.defaultPadding(top: 60),
          child: SizedBox(width: double.infinity, child: _body())),
    );
  }

  Widget _body() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              text: AppStrings.emailVerification,
              textStyle: AppTextStyle(context: context, fontSize: 24).fw900(),
            ),
            AppConstants.mediumYSpace,
            AppTextField(
              text: AppStrings.enterEmailOtp,
              textStyle: AppTextStyle(context: context, fontSize: 16).fw500(),
            ),
            AppConstants.extraLargeYSpace,
            Consumer(
              builder: (context, ref, child) {
                final signupOtpState = ref.watch(signupOtpViewModel);

                return OtpField(
                  onOtpFilled: (String otp) {
                    ref.read(signupOtpViewModel.notifier).verifyOtp(otp);
                  },
                  isLoading: signupOtpState.isLoading,
                  incorrectOtp: signupOtpState.isError,
                  onTapResendOtp: () {
                    ref.read(signupOtpViewModel.notifier).requestOtp(
                        email: ref
                            .read(signupOtpViewModel.notifier)
                            .signupDto!
                            .email);
                  },
                  otpLength: 6,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateChange(SignupOtpState? state, SignupOtpState next) {
    if (next.isSuccess) {
      if (next.data == null) {
        throw Exception(AppStrings.somethingWentWrong);
      }

      ref.read(profileViewModel.notifier).profile = next.data!.user;

      // NavigationService.jumpToScreen(
      //     context: context, routeName: Dashboard.routeName);
    }

    if (next.isError) {
      AppHelpers.showToast(
          context, next.errorMessage ?? AppStrings.somethingWentWrong);
    }
  }
}
