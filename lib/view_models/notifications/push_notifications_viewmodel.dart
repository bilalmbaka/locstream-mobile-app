import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/error_handlers/exceptions.dart';
import '../../core/services/push_notification/push_notification_service.dart';
import '../../domain/use_case/profile_usecase.dart';

class PushNotificationViewModel extends Notifier<void> {
  PushNotificationViewModel(
      {required this.pushNotificationService, required this.profileUseCase});

  final PushNotificationService pushNotificationService;
  final ProfileUseCase profileUseCase;

  @override
  void build() {}

  Future<void> init() async {
    try {
      await pushNotificationService.initialize();
      await _fetchAndUpdateToken();
    } catch (e, s) {
      final errorMessage = AppExceptionHandler.handleException(e,
          stackTrace: s, sendToLogger: true);
    }
  }

  Future<void> _fetchAndUpdateToken() async {
    try {
      final token = await pushNotificationService.fetchMessagingToken();
      await profileUseCase.updatePushNotificationToken(token: token);
    } catch (e, s) {
      if (e is ApiException) {
        Timer(Duration(seconds: 10), () async {
          await _fetchAndUpdateToken();
        });
      }

      final errorMessage = AppExceptionHandler.handleException(e,
          stackTrace: s, sendToLogger: (e is ApiException) == false);
    }
  }

  Future<void> destroyToken() async {
    try {
      await pushNotificationService.destroyMessagingToken();
    } catch (e, s) {
      final errorMessage = AppExceptionHandler.handleException(e,
          stackTrace: s, sendToLogger: true);
    }
  }
}
