import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';
import '../../data/model/signup_response_model.dart';
import '../../domain/entities/auth_dto.dart';
import '../../domain/use_case/auth_usecase.dart';

typedef LoginState = BaseState<AuthResponseModel>;

class LoginViewmodel extends Notifier<LoginState> {
  final AuthUseCase loginUsecase;

  LoginViewmodel({required this.loginUsecase});

  @override
  LoginState build() {
    return BaseState.initial();
  }

  Future<void> login(LoginDto loginDto) async {
    try {
      state = BaseState.loading();
      final response = await loginUsecase.login(loginDto);
      state = BaseState.success(response);
    } catch (e) {
      final errorMessage = AppExceptionHandler.handleException(e);

      state = BaseState.error(errorMessage);
    }
  }

  Future<void> deleteAuthTokens() async {
    try {
      await loginUsecase.deleteAuthTokens();
    } catch (e) {
      //Do Nothing;
    }
  }
}
