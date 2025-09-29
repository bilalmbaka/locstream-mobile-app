import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/core/services/api_service.dart';
import 'package:locstream/data/model/user_model.dart';

class ShareLocationRemoteDataSource {
  final ApiService apiService = ApiService(
    baseUrl: '${AppConstants.baseUrl}/share-location',
  );

  Future<List<User>> fetchLocationReceivers() async {
    try {
      final response = await apiService.get('/location-receivers');

      return List<User>.from(
        response['data'].map((e) {
          return User.fromJson(e);
        }),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> fetchLocationSharers() async {
    try {
      final response = await apiService.get('/location-shares');

      return List<User>.from(
        response['data'].map((e) {
          return User.fromJson(e);
        }),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> shareLocation({required String userId}) async {
    try {
      await apiService.patch('/share-location', data: {'userId': userId});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> stopSharingLocation({required String userId}) async {
    try {
      await apiService.patch('/stop-sharing-location', data: {'userId': userId});
    } catch (e) {
      rethrow;
    }
  }
}
