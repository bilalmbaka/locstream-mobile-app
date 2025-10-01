import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/data/data_sources/remote_data_sources/watching_location_socket.dart';
import 'package:locstream/data/model/user_model.dart';
import 'package:locstream/domain/use_case/share_location_use_case.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';

typedef WatchingState = BaseState<List<BaseState<User>>>;

///People whose location user it monitoring
class WatchingViewModel extends Notifier<WatchingState> {
  WatchingViewModel({required this.shareLocationUseCase});

  final ShareLocationUseCase shareLocationUseCase;

  @override
  WatchingState build() {
    shareLocationUseCase.watchingUsersStreamController().stream.listen(
      (WatchingSocketEvent data) {
        print('In view model socket data stream ==========> ${data.event}');
        print('In view model socket data stream user is ========> ${data.user?.toJson()}');


        if (data.event == AppConstants.reconnectedEvent) {
          state = WatchingState.success(state.data ?? <BaseState<User>>[]);
        }

        if (data.user != null) {
          final users = state.data ?? <BaseState<User>>[];

          final index = users.indexWhere(
            (element) => element.data?.id == data.user?.id,
          );

          if (index == -1) {
            state = WatchingState.success([
              ...users,
              BaseState.success(data.user!),
            ]);
          } else {
            state = WatchingState.success([
              ...users.sublist(0, index),
              BaseState.success(data.user!),
              ...users.sublist(index + 1),
            ]);
          }
        }
      },
      onError: (error) {
        if (error is WatchingSocketEvent) {
          if (error.event == AppConstants.connectionErrorEvent) {
            state = WatchingState.error('Connection error', data: state.data);
          }
          if (error.event == AppConstants.disconnectErrorEvent) {
            state = WatchingState.error('Network error', data: state.data);
          }
        }
      },
    );

    return WatchingState.initial();
  }

  void reset() {
    shareLocationUseCase.disconnectWatchingSocket();
    state = BaseState.initial();
  }

  void connect() {
    shareLocationUseCase.connectWatchingSocket();
  }

  Future<void> fetch({bool showLoading = true}) async {
    try {
      if (showLoading) {
        state = BaseState.loading(data: state.data);
      }

      final users = await shareLocationUseCase.fetchLocationSharers();

      state = WatchingState.success(
        users.map((e) => BaseState.success(e)).toList(),
      );
    } catch (e, s) {
      final errorMessage = AppExceptionHandler.handleException(
        e,
        stackTrace: s,
      );

      state = WatchingState.error(errorMessage, e: e, data: state.data);

      Timer(Duration(seconds: 2), () {
        fetch(showLoading: false);
      });
    }
  }
}
