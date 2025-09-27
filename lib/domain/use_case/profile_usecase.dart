import '../../data/model/user_model.dart';
import '../../data/repository/profile_repository.dart';
import '../entities/profile_dto.dart';

class ProfileUseCase {
  ProfileUseCase({required this.profileRepo});

  final ProfileRepository profileRepo;

  Future<User> getProfile() async {
    final profile = await profileRepo.getProfile();

    return profile;
  }

  Future<User?> getProfileFromLocal() async {
    return await profileRepo.fetchProfileOffline();
  }

  Future<void> clearOfflineData() async {
    return await profileRepo.clearOfflineProfile();
  }

  Future<User> updateProfile(ProfileDto profileDto) async {
    final profile = await profileRepo.updateProfile(profileDto);

    return profile;
  }

  Future<void> updatePushNotificationToken({required String token}) async {
    await profileRepo.updatePushNotificationToken(token);
  }

  Future<List<User>> findUsers({String? searchString, int startAt = 1}) async {
    return await profileRepo.findUsers(
      searchString: searchString,
      startAt: startAt,
    );
  }

  Future<bool> checkUserNameAvailability({required String userName}) async {
    return await profileRepo.checkUserNameAvailability(userName);
  }
}
