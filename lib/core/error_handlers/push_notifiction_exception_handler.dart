import '../../core/constants/strings.dart';

import '../error_handlers/exceptions.dart';

class PushNotificationExceptionHandler {
  static NotificationException handleException(Object e) {
    if (e is PushNotificationException) {
      return NotificationException(
        message: e.message,
        exception: e,
      );
    } else if (e is LocalNotificationException) {
      return NotificationException(
        message: e.message,
        exception: e,
      );
    } else if (e is NotificationPermissionException) {
      return NotificationException(
        message: e.message,
        exception: e,
      );
    }

    return NotificationException(
      message: AppStrings.somethingWentWrong,
      exception: e,
    );
  }
}
