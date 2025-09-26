import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/strings.dart';
import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';
import '../../data/model/signup_response_model.dart';
import '../../domain/entities/auth_dto.dart';
import '../../domain/use_case/auth_usecase.dart';

typedef SignupOtpState = BaseState<AuthResponseModel>;

class SignupOtpViewmodel extends Notifier<SignupOtpState> {
  final AuthUseCase authUseCase;

  SignupOtpViewmodel({required this.authUseCase});

  @override
  SignupOtpState build() {
    return BaseState.initial();
  }

  SignupDto? signupDto;

  Future<void> verifyOtp(String otp) async {
    try {
      state = BaseState.loading();

      if (signupDto == null) {
        throw FormatException();
      }

      final response = await authUseCase.verifyOtp(otp, signupDto!);

      state = BaseState.success(response);
    } catch (e) {
      if (e is FormatException) {
        state = BaseState.error(AppStrings.somethingWentWrong);
        return;
      }

      final errorMessage = AppExceptionHandler.handleException(e);

      state = BaseState.error(errorMessage);
    }
  }

  void requestOtp({required String email}) async {
    try {
      await authUseCase.requestOtp(email);
    }catch(e) {
      //DO NOTHING
    }
  }
}
