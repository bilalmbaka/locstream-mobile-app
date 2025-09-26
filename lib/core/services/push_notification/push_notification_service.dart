import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../error_handlers/exceptions.dart';
import '../../error_handlers/push_notifiction_exception_handler.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
int lastIndex = 0;

class PushNotificationService {
  static final _instance = PushNotificationService._internal();

  factory PushNotificationService() {
    return _instance;
  }

  PushNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Stream of messages when app is opened in foreground.
  late StreamSubscription _onMessageSub;

  /// Stream of messages when app is in background and opened from notification.
  late StreamSubscription _onMessageOpenedAppSub;

  /// Stream for detecting FCM token refresh
  Stream<String> get tokenRefreshStream => _firebaseMessaging.onTokenRefresh;

  Future<bool> _requestPermission() async {
    try {
      final permission = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      return permission.authorizationStatus == AuthorizationStatus.authorized;
    } catch (e) {
      throw PushNotificationExceptionHandler.handleException(e);
    }
  }

  Future<String> fetchMessagingToken() async {
    try {
      final permissionGranted = await _requestPermission();

      if (permissionGranted == false) {
        throw PushNotificationExceptionHandler.handleException(
            NotificationPermissionException(
          message: "Permission not granted",
          exception: Exception(),
        ));
      }

      final token = await _firebaseMessaging.getToken();

      if (token == null) {
        throw PushNotificationExceptionHandler.handleException(
            PushNotificationException(
                message: "Messaging token is null", exception: Exception()));
      }

      return token;
    } catch (e) {
      throw PushNotificationExceptionHandler.handleException(e);
    }
  }

  Future<void> destroyMessagingToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _onMessageSub.cancel();
      _onMessageOpenedAppSub.cancel();
    } catch (e) {
      throw PushNotificationExceptionHandler.handleException(e);
    }
  }

  Future<void> initialize() async {
    final notificationService = NotificationService();

    final permissionGranted = await _requestPermission();
    await notificationService.setupChannels();
    await notificationService.initialize(
        onNotificationReceived: (String? data) {
      //TODO on Tap
      if (data != null) {
        final map = jsonDecode(data);
        _onTap(map);
      }
    });

    if (permissionGranted == false) return;

    final initialMessage = await _firebaseMessaging.getInitialMessage();

    //Coming from app launch
    if (initialMessage?.data != null && initialMessage!.data.isNotEmpty) {
      _onTap(initialMessage.data);
    }

    //App in foreground
    _onMessageSub =
        FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      if (message != null && message.notification != null) {
        notificationService.showNotification(
          id: lastIndex,
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
        );

        lastIndex = lastIndex + 1;
      }
    });

    //App backgrounded or terminated
    FirebaseMessaging.onBackgroundMessage((RemoteMessage? message) async {
      if (message != null && message.data.isNotEmpty) {
        _onTap(message.data);
      }
    });
  }
}

@pragma('vm:entry-point')
Future<void> _onTap(Map<String, dynamic> data) async {
  print("Data is ${data}");
}
