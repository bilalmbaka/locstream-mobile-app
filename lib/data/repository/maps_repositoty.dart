import 'package:locstream/data/data_sources/remote_data_sources/maps_remote_data_source.dart';
import 'package:locstream/data/model/direction_model.dart';

class MapsRepository {
  final _mapsRemoteDataSource = MapsRemoteDataSource();

  Future<DirectionsModel> fetchDirections({
    required double originLng,
    required double originLat,
    required double destLng,
    required double destLat,
  }) async {
    return await _mapsRemoteDataSource.fetchDirections(
      originLng: originLng,
      originLat: originLat,
      destLng: destLng,
      destLat: destLat,
    );
  }
}