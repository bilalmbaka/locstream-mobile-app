import '../../domain/entities/auth_dto.dart';
import '../data_sources/local_data_sources/auth_local_data_source.dart';
import '../data_sources/remote_data_sources/auth_remote_data_source.dart';
import '../model/signup_response_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();
  final AuthLocalDataSource _localDataSource = AuthLocalDataSource();

  Future<void> signup(SignupDto signupDto) async {
    return _remoteDataSource.signup(signupDto);
  }

  Future<AuthResponseModel> verifyOtp(String otp, SignupDto signupDto) async {
    final response = await _remoteDataSource.verifyOtp(otp, signupDto);
    await _localDataSource.saveAuthToken(response.accessToken);
    await _localDataSource.saveRefreshToken(response.refreshToken);

    return response;
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _localDataSource.saveAuthToken(accessToken);
    await _localDataSource.saveRefreshToken(refreshToken);
  }

  Future<void> requestOtp(String email) async {
    return await _remoteDataSource.requestOtp(email);
  }

  Future<AuthResponseModel> login(LoginDto loginDto) async {
    final response = await _remoteDataSource.login(loginDto);
    await _localDataSource.saveAuthToken(response.accessToken);
    await _localDataSource.saveRefreshToken(response.refreshToken);

    return response;
  }

  Future<void> resetPassword(ResetPasswordDto resetPasswordDto) async {
    return await _remoteDataSource.resetPassword(resetPasswordDto);
  }

  Future<AuthResponseModel> changePassword(
      {required String oldPassword, required String newPassword}) async {
    return await _remoteDataSource.changePassword(
        oldPassword: oldPassword, newPassword: newPassword);
  }

  Future<void> deleteAuthTokens() async {
    return await _localDataSource.deleteAuthTokens();
  }
}
