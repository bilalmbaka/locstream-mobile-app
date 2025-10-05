import 'dart:convert';

import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/data/model/user_model.dart';

import '../../domain/entities/auth_dto.dart';
import '../data_sources/local_data_sources/auth_local_data_source.dart';
import '../data_sources/remote_data_sources/auth_remote_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();
  final AuthLocalDataSource _localDataSource = AuthLocalDataSource();

  Future<void> signup(SignupDto signupDto) async {
    return _remoteDataSource.signup(signupDto);
  }

  Future<User> verifyAccount(String otp, String email) async {
    final response = await _remoteDataSource.verifyAccount(otp, email);
    await _localDataSource.saveAuthToken(response.accessToken!);
    await _localDataSource.saveRefreshToken(response.refreshToken!);

    return response;
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _localDataSource.saveAuthToken(accessToken);
    await _localDataSource.saveRefreshToken(refreshToken);
  }

  Future<void> requestOtp(String email) async {
    return await _remoteDataSource.requestOtp(email);
  }

  Future<User> login(LoginDto loginDto) async {
    final response = await _remoteDataSource.login(loginDto);
    await _localDataSource.saveAuthToken(response.accessToken!);
    await _localDataSource.saveRefreshToken(response.refreshToken!);

    return response;
  }

  Future<void> resetPassword(ResetPasswordDto resetPasswordDto) async {
    return await _remoteDataSource.resetPassword(resetPasswordDto);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    return await _remoteDataSource.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  Future<void> deleteAuthTokens() async {
    return await _localDataSource.deleteAuthTokens();
  }

  Future<List<String>> suggestUserNames({required String email}) async {
    return await _remoteDataSource.suggestUserNames(email: email);
  }

  Future<void> logout({required String accessToken}) async {
    await _remoteDataSource.logout(accessToken: accessToken);
  }

  Future<String?> getAccessToken() async {
    final token = await _localDataSource.getAuthToken();

    if (token == null) return null;

    return token;
  }
}
