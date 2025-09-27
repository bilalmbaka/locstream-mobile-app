import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';
import '../../data/model/user_model.dart';
import '../../domain/use_case/auth_usecase.dart';

typedef ChangePasswordState = BaseState<void>;

class ChangePasswordViewModel extends Notifier<ChangePasswordState> {
  final AuthUseCase authUseCase;

  ChangePasswordViewModel({required this.authUseCase});

  @override
  ChangePasswordState build() {
    return BaseState.initial();
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      state = BaseState.loading();
      final profile = await authUseCase.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      state = BaseState.success(profile);
    } catch (e) {
      final errorMessage = AppExceptionHandler.handleException(e);

      state = BaseState.error(errorMessage);
    }
  }
}
