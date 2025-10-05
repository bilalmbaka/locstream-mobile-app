import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/core/services/api_service.dart';
import 'package:locstream/core/services/location_service.dart';
import 'package:locstream/data/data_sources/local_data_sources/auth_local_data_source.dart';
import 'package:locstream/data/model/location_models.dart';

// The callback function should always be a top-level or static function.
@pragma('vm:entry-point')
void startLocationHandlerCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

class LocationTaskHandler extends TaskHandler {
  final locationService = LocationService();
  LocationModel _previousLocation = LocationModel(lat: 0, lng: 0);

  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    LocationService().locationStream().listen((location) async {
      final locationModel = LocationModel(
        lat: location.latitude,
        lng: location.longitude,
      );

      final distanceBetweenLocation = Geolocator.distanceBetween(
        _previousLocation.lat,
        _previousLocation.lng,
        locationModel.lat,
        locationModel.lng,
      );

      if (distanceBetweenLocation >= 10) {
        //When user moves 10 meters
        try {
          final accessToken = await AuthLocalDataSource().getAuthToken();

          if (accessToken == null) {
            return;
          }

          final apiService = ApiService(
            baseUrl: '${AppConstants.baseUrl}/user',
            watchUserState: false,
          );

          await apiService.patch(
            '/update-profile',
            data: {'currentLocation': locationModel.toJson()},
          );
        } catch (e) {
          print('Could not post location in foreground service, $e');
          //DO NOTHING
        }
      }

      _previousLocation = locationModel;

      FlutterForegroundTask.sendDataToMain(locationModel.toJson());
    });
  }

  // Called based on the eventAction set in ForegroundTaskOptions.
  @override
  void onRepeatEvent(DateTime timestamp) {
    print('onRepeatEvent');
  }

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    print('onDestroy(isTimeout: $isTimeout)');
  }

  // Called when data is sent using `FlutterForegroundTask.sendDataToTask`.
  @override
  void onReceiveData(Object data) {
    print('onReceiveData: $data');
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed: $id');
  }

  // Called when the notification itself is pressed.
  @override
  void onNotificationPressed() {
    print('onNotificationPressed');
  }

  // Called when the notification itself is dismissed.
  @override
  void onNotificationDismissed() {
    print('onNotificationDismissed');
  }
}
