// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../core/constants/constants.dart';
// import '../../core/constants/strings.dart';
// import '../../core/services/navigation_service.dart';
// import '../../core/styling/text_style.dart';
// import '../../core/utils/helpers/helpers.dart';
// import '../../domain/entities/auth_dto.dart';
// import '../../view_model/auth/signup_otp_viewmodel.dart';
// import '../../view_models.dart';
// import '../dashboard/screens/dashboard.dart';
// import '../widgets/app_text_field.dart';
// import '../widgets/otp_field.dart';

// class ResetPasswordEmailVerificationScreen extends ConsumerStatefulWidget {
//   static const path = "/$routeName";
//   static const routeName = "reset-password-email-verification";

//   const ResetPasswordEmailVerificationScreen({super.key});

//   @override
//   ConsumerState<ResetPasswordEmailVerificationScreen> createState() =>
//       _SignupEmailVerificationScreenState();
// }

// class _SignupEmailVerificationScreenState
//     extends ConsumerState<ResetPasswordEmailVerificationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     ref.listen(signupOtpViewModel, _handleStateChange);

//     return Scaffold(
//       body: SingleChildScrollView(
//           padding: AppHelpers.defaultPadding(top: 60),
//           child: SizedBox(width: double.infinity, child: _body())),
//     );
//   }

//   Widget _body() {
//     return Center(
//       child: ConstrainedBox(
//         constraints: BoxConstraints(maxWidth: 500),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppTextField(
//               text: AppStrings.enterOtp,
//               textStyle: AppTextStyle(context: context, fontSize: 24).fw900(),
//             ),
//             AppConstants.mediumYSpace,
//             AppTextField(
//               text:
//                   "${AppStrings.otpWasSentToEmail} \n ${ref.read(resetPasswordViewModel.notifier).email!}",
//               textStyle: AppTextStyle(context: context, fontSize: 16).fw500(),
//               textAlign: TextAlign.center,
//             ),
//             AppConstants.extraLargeYSpace,
//             Consumer(
//               builder: (context, ref, child) {
//                 final signupOtpState = ref.watch(signupOtpViewModel);

//                 return OtpField(
//                   onOtpFilled: (String otp) {
//                     ref.read(resetPasswordViewModel.notifier).resetPassword(
//                         ResetPasswordDto(
//                             email: ref.read(resetPasswordViewModel.notifier).email!,
//                             otp: otp,
//                             password: ""));
//                   },
//                   isLoading: signupOtpState.isLoading,
//                   incorrectOtp: signupOtpState.isError,
//                   onTapResendOtp: () {
//                     ref.read(resetPasswordViewModel.notifier).requestOtp(
//                         ref.read(resetPasswordViewModel.notifier).email!);
//                   },
//                   otpLength: 6,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleStateChange(SignupOtpState? state, SignupOtpState next) {
//     if (next.isSuccess) {
//       if (next.data == null) {
//         throw Exception(AppStrings.somethingWentWrong);
//       }

//       ref.read(profileViewModel.notifier).profile = next.data!.user;

//       NavigationService.jumpToScreen(
//           context: context, routeName: Dashboard.routeName);
//     }

//     if (next.isError) {
//       AppHelpers.showToast(
//           context, next.errorMessage ?? AppStrings.somethingWentWrong);
//     }
//   }
// }
