import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:locstream/core/enums.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/data/model/user_model.dart';
import 'package:locstream/domain/use_case/share_location_use_case.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';

typedef WatchersState = BaseState<List<BaseState<User>>>;

class WatchersViewModel extends Notifier<WatchersState> {
  WatchersViewModel({required this.shareLocationUseCase});

  final ShareLocationUseCase shareLocationUseCase;

  @override
  WatchersState build() {
    return WatchersState.initial();
  }

  Future<void> add({required User user}) async {
    final List<BaseState<User>> users = [...(state.data ?? [])];
    users.insert(0, BaseState.success(user));
    state = WatchersState.success(users);
  }

  Future<void> fetch() async {
    try {
      state = BaseState.loading();

      final users = await shareLocationUseCase.fetchLocationReceivers();

      state = WatchersState.success(
        users.map((e) => BaseState.success(e)).toList(),
      );
    } catch (e, s) {
      final errorMessage = AppExceptionHandler.handleException(
        e,
        stackTrace: s,
      );

      state = WatchersState.error(errorMessage, e: e);
    }
  }

  Future<void> removeWatcher({required BuildContext context,required String userId}) async {
    final index = state.data!.indexWhere(
      (element) => element.data!.id == userId,
    );

    if (index == -1) return;

    try {
      final data = [...state.data!];

      //Show loading state for the tapped user
      final user = (data[index]).copyWith(status: Status.loading);
      data[index] = user;
      state = WatchersState.success(data);

      await shareLocationUseCase.stopSharingLocation(userId: userId);

      //Remove the user
      data.removeAt(index);
      state = WatchersState.success(data);
    } catch (e, s) {
      final errorMessage = AppExceptionHandler.handleException(
        e,
        stackTrace: s,
      );

      AppHelpers.showToast(context, errorMessage);

      final data = [...state.data!];

      //Show error state for the tapped user
      final user = (data[index]).copyWith(status: Status.error);
      data[index] = user;
      state = WatchersState.success(data);
    }
  }
}
