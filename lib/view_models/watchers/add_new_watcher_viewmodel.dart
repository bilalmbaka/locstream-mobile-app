import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/enums.dart';
import 'package:locstream/data/model/user_model.dart';
import 'package:locstream/domain/use_case/auth_usecase.dart';
import 'package:locstream/domain/use_case/share_location_use_case.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';

typedef AddNewWatcherState = BaseState<User>;

class AddNewWatchersViewModel extends Notifier<AddNewWatcherState> {
  AddNewWatchersViewModel({required this.shareLocationUseCase});

  final ShareLocationUseCase shareLocationUseCase;

  @override
  AddNewWatcherState build() {
    return AddNewWatcherState.initial();
  }

  Future<void> add({required User user}) async {
    try {
      state = AddNewWatcherState.loading();

      await shareLocationUseCase.shareLocation(userId: user.id);

      state = AddNewWatcherState(status: Status.success, data: user);
    } catch (e, s) {
      final errorMessage = AppExceptionHandler.handleException(
        e,
        stackTrace: s,
      );

      state = AddNewWatcherState.error(errorMessage, e: e);
    }
  }
}
