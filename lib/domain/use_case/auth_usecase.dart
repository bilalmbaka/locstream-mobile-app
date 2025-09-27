import 'package:locstream/data/repository/profile_repository.dart';

import '../../data/model/signup_response_model.dart';
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

  Future<AuthResponseModel> verifyOtp(String otp, SignupDto signupDto) async {
    final response = await authRepo.verifyOtp(otp, signupDto);

    return response;
  }

  Future<void> requestOtp(String email) async {
    await authRepo.requestOtp(email);
  }

  Future<AuthResponseModel> login(LoginDto loginDto) async {
    final response = await authRepo.login(loginDto);

    profileRepo.saveProfile(response.user);

    return response;
  }

  Future<void> resetPassword(ResetPasswordDto resetPasswordDto) async {
    await authRepo.resetPassword(resetPasswordDto);
  }

  Future<User> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await authRepo.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    await authRepo.saveTokens(response.accessToken, response.refreshToken);

    return response.user;
  }

  Future<void> deleteAuthTokens() async {
    await authRepo.deleteAuthTokens();
  }
}
