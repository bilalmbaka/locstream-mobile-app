import '../../domain/entities/profile_dto.dart';
import '../data_sources/remote_data_sources/profile_remote_data_source.dart';
import '../model/user_model.dart';

class ProfileRepository {
  final _remoteDataSource = ProfileRemoteDataSource();

  Future<User> getProfile() async {
    final profile = await _remoteDataSource.getProfile();

    return profile;
  }

  Future<User> updateProfile(ProfileDto dto) async {
    final profile = await _remoteDataSource.updateProfile(dto);

    return profile;
  }

  Future<List<User>> findUsers({String? searchString, int startAt = 1}) async {
    return await _remoteDataSource.findUsers(
      searchString: searchString,
      startAt: startAt,
    );
  }

  Future<void> updatePushNotificationToken(String token) async {
    return await _remoteDataSource.updatePushNotificationToken(token: token);
  }
}
