import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/data/model/user_model.dart';

import '../../core/constants/strings.dart';
import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';
import '../../data/model/signup_response_model.dart';
import '../../domain/entities/auth_dto.dart';
import '../../domain/use_case/auth_usecase.dart';

typedef SignupOtpState = BaseState<User>;

class SignupOtpViewModel extends Notifier<SignupOtpState> {
  final AuthUseCase authUseCase;

  SignupOtpViewModel({required this.authUseCase});

  @override
  SignupOtpState build() {
    return BaseState.initial();
  }

  Future<void> verifyOtp(String otp,String email) async {
    try {
      state = BaseState.loading();

      final response = await authUseCase.verifyAccount(otp,email);

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
