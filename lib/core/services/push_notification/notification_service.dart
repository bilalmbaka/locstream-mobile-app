import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../error_handlers/exceptions.dart';

class NotificationService {
  static final _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  static const _androidChannelId = 'high_importance_channel';
  static const _androidChannelName = 'High Importance Notifications';
  static const _androidChannelDescription =
      'This channel is used for important notifications.';

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> setupChannels() async {
    try {
      final permissionGranted = await requestPermission();

      if (!permissionGranted) {
        NotificationPermissionException(
          message: "Permission not granted",
          exception: Exception(),
        );
      }

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        _androidChannelId,
        _androidChannelName,
        description: _androidChannelDescription,
        importance: Importance.max,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> initialize({
    required Function(String? payload) onNotificationReceived,
    String androidDefaultIcon = "@mipmap/ic_launcher",
  }) async {
    try {
      await _localNotifications.initialize(
        InitializationSettings(
          android: AndroidInitializationSettings(androidDefaultIcon),
          iOS: const DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse:
            (NotificationResponse? notificationResponse) async {
          if (notificationResponse?.payload != null) {
            onNotificationReceived(notificationResponse?.payload);
          }
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> requestPermission() async {
    try {
      final permission = await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      return permission == true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    required int id,
    String? payload,
    String? icon,
  }) async {
    await _localNotifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannelId,
          _androidChannelName,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  Future<void> cancel(int id, {String? tag}) {
    return _localNotifications.cancel(id, tag: tag);
  }

  Future<void> cancelAll() {
    return _localNotifications.cancelAll();
  }

}
