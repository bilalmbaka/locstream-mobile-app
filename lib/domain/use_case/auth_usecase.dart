import 'package:locstream/data/repository/profile_repository.dart';

import '../../data/model/user_model.dart';
import '../../data/repository/authentication_repository.dart';
import '../entities/auth_dto.dart';

class AuthUseCase {
  AuthUseCase({required this.authRepo, required this.profileRepo});

  final AuthRepository authRepo;
  final ProfileRepository profileRepo;

  Future<void> signup(SignupDto signupDto) async {
    await authRepo.signup(signupDto);
  }

  Future<User> verifyAccount(String otp, String email) async {
    final response = await authRepo.verifyAccount(otp, email);

    await profileRepo.saveProfile(response);

    return response;
  }

  Future<void> requestOtp(String email) async {
    await authRepo.requestOtp(email);
  }

  Future<User> login(LoginDto loginDto) async {
    final response = await authRepo.login(loginDto);

    profileRepo.saveProfile(response);

    return response;
  }

  Future<void> resetPassword(ResetPasswordDto resetPasswordDto) async {
    await authRepo.resetPassword(resetPasswordDto);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    return await authRepo.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  Future<void> deleteAuthTokens() async {
    await authRepo.deleteAuthTokens();
  }

  Future<List<String>> suggestUserNames({required String email}) async {
    return await authRepo.suggestUserNames(email: email);
  }
}
