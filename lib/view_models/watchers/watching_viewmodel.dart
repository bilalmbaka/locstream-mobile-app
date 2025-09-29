import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/data/model/user_model.dart';
import 'package:locstream/domain/use_case/auth_usecase.dart';
import 'package:locstream/domain/use_case/share_location_use_case.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';

typedef WatchingState = BaseState<List<BaseState<User>>>;

class WatchingViewModel extends Notifier<WatchingState> {
  WatchingViewModel({required this.shareLocationUseCase});

  final ShareLocationUseCase shareLocationUseCase;

  @override
  WatchingState build() {
    return WatchingState.initial();
  }

  Future<void> fetch() async {
    try {
      state = BaseState.loading();

      final users = await shareLocationUseCase.fetchLocationSharers();

      state = WatchingState.success(
        users.map((e) => BaseState.success(e)).toList(),
      );
    } catch (e, s) {
      final errorMessage = AppExceptionHandler.handleException(
        e,
        stackTrace: s,
      );

      state = WatchingState.error(errorMessage, e: e);
    }
  }
}
