import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:locstream/views/screens/authentication/set_username.dart';
import 'package:locstream/views/widgets/app_bars/general_app_bar.dart';

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
  static const path = '/$routeName';
  static const routeName = 'signup-email-verification';

  const SignupEmailVerificationScreen(this.emailAddress, {super.key});

  final String emailAddress;

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
      appBar: AppAppBar(),
      body: SingleChildScrollView(
        padding: AppHelpers.defaultPadding(),
        child: SizedBox(width: double.infinity, child: _body()),
      ),
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
              text: '${AppStrings.enterEmailOtp} ${widget.emailAddress}',
              textStyle: AppTextStyle(context: context, fontSize: 16).fw500(),
            ),
            AppConstants.extraLargeYSpace,
            Consumer(
              builder: (context, ref, child) {
                final signupOtpState = ref.watch(signupOtpViewModel);

                return OtpField(
                  onOtpFilled: (String otp) {
                    ref
                        .read(signupOtpViewModel.notifier)
                        .verifyOtp(otp, widget.emailAddress);
                  },
                  isLoading: signupOtpState.isLoading,
                  incorrectOtp: signupOtpState.isError,
                  onTapResendOtp: () {
                    ref
                        .read(signupOtpViewModel.notifier)
                        .requestOtp(email: widget.emailAddress);
                  },
                  otpLength: 4,
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

      ref.read(profileViewModel.notifier).profile = next.data!;

      NavigationService.jumpToScreen(
        context: context,
        routeName: SetUserNameScreen.routeName,
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
