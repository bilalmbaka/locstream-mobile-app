import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/enums.dart';
import 'package:locstream/core/error_handlers/exceptions.dart';
import 'package:locstream/domain/use_case/profile_usecase.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';

typedef UserNameAvailabilityState = BaseState<void>;

class CheckUserNameAvailability extends Notifier<UserNameAvailabilityState> {
  CheckUserNameAvailability({required this.profileUseCase});

  final ProfileUseCase profileUseCase;

  @override
  UserNameAvailabilityState build() {
    return UserNameAvailabilityState.initial();
  }

  Future<void> check({required String userName}) async {
    try {
      state = BaseState.loading();

      await profileUseCase.checkUserNameAvailability(userName: userName);

      state = UserNameAvailabilityState(status: Status.success);
    } catch (e, s) {
      final errorMessage = AppExceptionHandler.handleException(
        e,
        stackTrace: s,
      );

      if (e is ApiException) {
        if (e.statusCode == 409) {
          state = UserNameAvailabilityState.error('Username is taken', e: e);

          return;
        }
      }

      state = UserNameAvailabilityState.error(errorMessage, e: e);
    }
  }
}
