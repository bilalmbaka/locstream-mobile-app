import 'package:locstream/data/data_sources/local_data_sources/profile_local_data_source.dart';
import 'package:locstream/data/data_sources/remote_data_sources/profile_remote_data_source.dart';
import 'package:locstream/data/model/user_model.dart';
import 'package:locstream/domain/entities/profile_dto.dart';


class ProfileRepository {
  final _remoteDataSource = ProfileRemoteDataSource();
  final _localDataSource = ProfileLocalDataSource();

  Future<User> getProfile() async {
    final profile = await _remoteDataSource.getProfile();
    await _localDataSource.saveProfile(profile);

    return profile;
  }

  Future<void> saveProfile(User user) async {
    await _localDataSource.saveProfile(user);
  }

  Future<User?> fetchProfileOffline() async {
    return await _localDataSource.getProfile();
  }

  Future<User> updateProfile(ProfileDto dto) async {
    final profile = await _remoteDataSource.updateProfile(dto);
    await _localDataSource.saveProfile(profile);

    return profile;
  }

  Future<void> clearOfflineProfile() async {
    await _localDataSource.clearOfflineProfile();
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