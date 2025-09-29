import 'package:geolocator/geolocator.dart';
import 'package:locstream/data/model/location_models.dart';

class LocationService {
  static final _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  Future<bool> isPermissionGranted() async {
    final permission = await Geolocator.checkPermission();

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<bool> requestPermission() async {
    try {
      await Geolocator.requestPermission();
      return await isPermissionGranted();
    } catch (e) {
      rethrow;
    }
  }

  Future<LocationModel> currentLocation() async {
    try {
      final location = await Geolocator.getCurrentPosition();

      return LocationModel(lat: location.latitude, lng: location.longitude);
    } catch (e) {
      rethrow;
    }
  }

  Stream<Position> locationStream() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(

      )
    );
  }
}
