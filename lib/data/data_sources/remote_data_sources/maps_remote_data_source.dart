import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/core/services/api_service.dart';
import 'package:locstream/data/model/direction_model.dart';

class MapsRemoteDataSource {
  final ApiService _mapBoxApi = ApiService(
    baseUrl: '${AppConstants.baseUrl}/auth',
    unAuthorized: true,
  );

  Future<DirectionsModel> fetchDirections({
    required double originLng,
    required double originLat,
    required double destLng,
    required double destLat,
  }) async {
    try {
      final url =
          '${AppConstants.mapBoxDirectionBaseUrl}/driving/$originLng,$originLat;$destLng,$destLat?access_token=${AppConstants.mapBoxPublicKey}';

      final response = await _mapBoxApi.get(url);

      return DirectionsModel.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }
}
