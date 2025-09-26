import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/strings.dart';
import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';
import '../../domain/entities/auth_dto.dart';
import '../../domain/use_case/auth_usecase.dart';

typedef ResetPasswordState = BaseState<void>;

class ResetPasswordViewmodel extends Notifier<BaseState> {
  ResetPasswordViewmodel({required this.authUseCase});

  final AuthUseCase authUseCase;

  @override
  BaseState build() {
    return BaseState.initial();
  }

  String? email;

  Future<void> resetPassword(ResetPasswordDto resetPasswordDto) async {
    try {
      if (email == null) {
        throw FormatException();
      }

      state = BaseState.loading();
      await authUseCase.resetPassword(resetPasswordDto);
      state = BaseState.success(null);
    } catch (e) {
      if (e is FormatException) {
        state = BaseState.error(AppStrings.somethingWentWrong);
      }

      final errorMessage = AppExceptionHandler.handleException(e);

      state = BaseState.error(errorMessage);
    }
  }

  Future<void> requestOtp(String email) async {
    try {
      await authUseCase.requestOtp(email);
    } catch (e) {
      //Ignore error
    }
  }
}
