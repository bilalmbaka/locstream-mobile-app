import 'package:geolocator/geolocator.dart';

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
    }catch(e) {
      rethrow;
    }
  }
}
