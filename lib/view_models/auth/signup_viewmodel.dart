import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';
import '../../domain/entities/auth_dto.dart';
import '../../domain/use_case/auth_usecase.dart';

typedef SignupState = BaseState<void>;

class SignupViewmodel extends Notifier<SignupState> {
  final AuthUseCase authUseCase;

  SignupViewmodel({required this.authUseCase});

  @override
  SignupState build() {
    return BaseState.initial();
  }

  Future<void> signup(SignupDto signupDto) async {
    try {
      state = BaseState.loading();
      await authUseCase.signup(signupDto);
      state = BaseState.success(null);
    } catch (e) {
      final errorMessage = AppExceptionHandler.handleException(e);

      state = BaseState.error(errorMessage);
    }
  }
}
