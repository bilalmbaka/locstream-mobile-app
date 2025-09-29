// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:locstream/core/enums.dart';
// import 'package:locstream/data/model/user_model.dart';
// import 'package:locstream/domain/use_case/auth_usecase.dart';
// import 'package:locstream/domain/use_case/share_location_use_case.dart';
//
// import '../../core/error_handlers/exception_handler.dart';
// import '../../core/utils/base_state.dart';
//
// typedef RemoveWatcherState = BaseState<void>;
//
// class RemoveWatcherViewModel extends Notifier<RemoveWatcherState> {
//   RemoveWatcherViewModel({required this.shareLocationUseCase});
//
//   final ShareLocationUseCase shareLocationUseCase;
//
//   @override
//   RemoveWatcherState build() {
//     return RemoveWatcherState.initial();
//   }
//
//   Future<void> add({required String userId}) async {
//     try {
//       state = RemoveWatcherState.loading();
//
//       await shareLocationUseCase.stopSharingLocation(userId: userId);
//
//       state = RemoveWatcherState(status: Status.success);
//     } catch (e, s) {
//       final errorMessage = AppExceptionHandler.handleException(
//         e,
//         stackTrace: s,
//       );
//
//       state = RemoveWatcherState.error(errorMessage, e: e);
//     }
//   }
// }
