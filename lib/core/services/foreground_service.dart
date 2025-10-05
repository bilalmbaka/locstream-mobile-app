import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:locstream/core/constants/strings.dart';

class AppForegroundService {
  static void initCommunicationPort() {
    try {
      FlutterForegroundTask.initCommunicationPort();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> requestBootPermission() async {
    try {
      if (Platform.isAndroid) {
        // Android 12+, there are restrictions on starting a foreground service.
        //
        // To restart the service on device reboot or unexpected problem, you need to allow below permission.
        // if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        //   // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
        //   await FlutterForegroundTask.requestIgnoreBatteryOptimization();
        // }

        // // Use this utility only if you provide services that require long-term survival,
        // // such as exact alarm service, healthcare service, or Bluetooth communication.
        // //
        // // This utility requires the "android.permission.SCHEDULE_EXACT_ALARM" permission.
        // // Using this permission may make app distribution difficult due to Google policy.
        // if (!await FlutterForegroundTask.canScheduleExactAlarms) {
        //   // When you call this function, will be gone to the settings page.
        //   // So you need to explain to the user why set it.
        //   await FlutterForegroundTask.openAlarmsAndRemindersSettings();
        // }
      }
    } catch (e) {
      rethrow;
    }
  }

  static void initService() {
    try {
      FlutterForegroundTask.init(
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'foreground_service',
          channelName: 'Foreground Service Notification',
          channelDescription:
              'This notification appears when a foreground service is running.',
          onlyAlertOnce: true,
        ),
        iosNotificationOptions: const IOSNotificationOptions(
          showNotification: false,
          playSound: false,
        ),
        foregroundTaskOptions: ForegroundTaskOptions(
          eventAction: ForegroundTaskEventAction.nothing(),
          autoRunOnBoot: true,
          autoRunOnMyPackageReplaced: true,
          allowWakeLock: true,
          allowWifiLock: true,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  static void addCallback(Function(Object) callback) {
    try {
      FlutterForegroundTask.addTaskDataCallback(callback);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> start(Function callback) async {
    try {
      if (await isRunningService) {
        return;
      }

      final ServiceRequestResult result =
          await FlutterForegroundTask.startService(
            serviceId: 200,
            notificationTitle: '${AppStrings.appName} is running',
            notificationText: 'Streaming location to watchers',
            callback: callback,
          );

      if (result is ServiceRequestFailure) {
        throw result.error;
      }
    } catch (e) {
      print("Error staring foreground service $e");

      rethrow;
    }
  }

  static Future<void> stop() async {
    try {
      if (await isRunningService == false) return;

      final ServiceRequestResult result =
          await FlutterForegroundTask.stopService();

      if (result is ServiceRequestFailure) {
        throw result.error;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> get isRunningService =>
      FlutterForegroundTask.isRunningService;
}

@pragma('vm:entry-point')
void startCallback(TaskHandler taskHandler) {
  FlutterForegroundTask.setTaskHandler(taskHandler);
}
