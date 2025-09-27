import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/data/model/user_model.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';
import '../../data/model/signup_response_model.dart';
import '../../domain/entities/auth_dto.dart';
import '../../domain/use_case/auth_usecase.dart';

typedef LoginState = BaseState<User>;

class LoginViewModel extends Notifier<LoginState> {
  final AuthUseCase loginUseCase;


  LoginViewModel({required this.loginUseCase});

  @override
  LoginState build() {
    return BaseState.initial();
  }

  Future<void> login(LoginDto loginDto) async {
    try {
      state = BaseState.loading();

      final response = await loginUseCase.login(loginDto);
      state = BaseState.success(response);
    } catch (e) {
      final errorMessage = AppExceptionHandler.handleException(e);

      state = BaseState.error(errorMessage);
    }
  }

  Future<void> deleteAuthTokens() async {
    try {
      await loginUseCase.deleteAuthTokens();
    } catch (e) {
      //Do Nothing;
    }
  }
}
