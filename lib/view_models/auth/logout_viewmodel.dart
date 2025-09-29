import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/view_models.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';
import '../../domain/use_case/auth_usecase.dart';

typedef LogoutState = BaseState<void>;

class LogoutViewModel extends Notifier<LogoutState> {
  final AuthUseCase authUseCase;

  LogoutViewModel({required this.authUseCase});

  @override
  LogoutState build() {
    return BaseState.initial();
  }

  Future<void> logout() async {
    try {
      ref.read(profileViewModel.notifier).reset();
      ref.invalidate(watchingViewModel);
      ref.invalidate(watchersViewModel);
      ref.invalidate(findUsersViewModel);
      ref.invalidate(suggestUserNameViewModel);

      final accessToken = await authUseCase.fetchAccessToken();

      await authUseCase.deleteAuthTokens();

      if (accessToken != null) {
        await authUseCase.logout(accessToken: accessToken);
      }
    } catch (e) {
      final errorMessage = AppExceptionHandler.handleException(
        e,
        sendToLogger: true,
      );

      state = BaseState.error(errorMessage);
    }
  }
}
