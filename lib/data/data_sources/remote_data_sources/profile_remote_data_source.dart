import '../../../core/constants/constants.dart';
import '../../../core/services/api_service.dart';
import '../../../domain/entities/profile_dto.dart';
import '../../model/user_model.dart';

class ProfileRemoteDataSource {
  final ApiService apiService = ApiService(
    baseUrl: '${AppConstants.baseUrl}/user',
  );

  Future<User> getProfile() async {
    try {
      final response = await apiService.get('/profile');

      return User.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateProfile(ProfileDto dto) async {
    try {
      final formData = await dto.toFormData();

      final response = await apiService.patch(
        '/update-profile',
        data: formData,
      );

      return User.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> findUsers({String? searchString, int startAt = 1}) async {
    try {
      final response = await apiService.get(
        '/find',
        queryParams: searchString != null && searchString.trim().isNotEmpty
            ? {
                'userName': searchString,
                'startAt': startAt,
                'endAt': startAt + AppConstants.paginationJump,
              }
            : null,
      );

      return List<User>.from(
        response['data'].map((e) {
          return User.fromJson(e);
        }),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePushNotificationToken({required String token}) async {
    try {
      await apiService.patch(
        '/profile',
        data: {'pushNotificationToken': token},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkIfUserNameAvailable({required String userName}) async {
    try {
      await apiService.get(
        '/username-free',
        queryParams: {'userName': userName.trim().toLowerCase()},
      );

      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      await apiService.delete('/delete-profile');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> contactSupport({
    required String title,
    required String body,
  }) async {
    try {
      await ApiService(
        baseUrl: '${AppConstants.baseUrl}/customer-support',
        unAuthorized: true,
      ).post('', data: {'title': title, 'body': body});
    } catch (e) {
      rethrow;
    }
  }
}
