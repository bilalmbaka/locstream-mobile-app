import 'package:locstream/data/model/direction_model.dart';
import 'package:locstream/data/repository/maps_repositoty.dart';

class MapsUseCase {
  const MapsUseCase({required this.mapsRepository});

  final MapsRepository mapsRepository;

  Future<DirectionsModel> fetchDirections({
    required double originLng,
    required double originLat,
    required double destLng,
    required double destLat,
  }) async {
    try {
      return await mapsRepository.fetchDirections(
        originLng: originLng,
        originLat: originLat,
        destLng: destLng,
        destLat: destLat,
      );
    } catch (e) {
      rethrow;
    }
  }
}
