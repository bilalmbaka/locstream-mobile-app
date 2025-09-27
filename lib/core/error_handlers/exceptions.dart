class LocationException implements Exception {
  const LocationException(this.exception, {this.message});

  final Object exception;
  final String? message;

  @override
  String toString() {
    return message ?? exception.toString();
  }
}

class ApiException implements Exception {
  const ApiException({
    required this.message,
    required this.exception,
    this.statusCode,
  });

  final String message;
  final Object exception;
  final int? statusCode;

  @override
  String toString() {
    return message;
  }
}

class NoNetworkException extends ApiException {
  const NoNetworkException({
    this.message = 'Network unreachable',
    required this.exception,
    this.statusCode,
  }) : super(message: message, exception: exception);

  final String message;
  final Object exception;
  final int? statusCode;

  @override
  String toString() {
    return message;
  }
}

class IrrecoverableTokenException implements Exception {}

class SharedPrefException implements Exception {
  const SharedPrefException({required this.message, required this.exception});

  final String message;
  final Object exception;

  @override
  String toString() {
    return message;
  }
}

class PushNotificationException implements Exception {
  final String message;
  final Object exception;

  PushNotificationException({required this.message, required this.exception});

  @override
  String toString() {
    return message;
  }
}

class LocalNotificationException implements Exception {
  final String message;
  final Object exception;

  LocalNotificationException({required this.message, required this.exception});

  @override
  String toString() {
    return message;
  }
}

class NotificationPermissionException extends PushNotificationException {
  NotificationPermissionException({
    required super.message,
    required super.exception,
  });
}

class NotificationException implements Exception {
  final String message;
  final Object exception;

  NotificationException({required this.message, required this.exception});

  @override
  String toString() {
    return message;
  }
}
