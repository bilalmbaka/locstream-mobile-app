import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:locstream/data/model/user_model.dart';

import '../../../core/constants/constants.dart';
import '../../../core/services/api_service.dart';
import '../../../domain/entities/auth_dto.dart';

class AuthRemoteDataSource {
  final ApiService apiService = ApiService(
    baseUrl: '${AppConstants.baseUrl}/auth',
    unAuthorized: true,
  );

  Future<Map<String, dynamic>> _fetchDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      return {
        'deviceMake': androidInfo.brand,
        'os': 'Android',
        'osVersion': androidInfo.version.sdkInt.toString(),
      };
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return {
        'deviceMake': iosInfo.modelName,
        'os': 'IOS',
        'osVersion': iosInfo.systemVersion,
      };
    }
  }

  Future<void> signup(SignupDto signupDto) async {
    try {
      await apiService.post('/signup', data: signupDto.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<User> verifyAccount(String otp, String email) async {
    try {
      final response = await apiService.post(
        '/verify-account',
        data: {'otp': otp, 'email': email, ...(await _fetchDeviceInfo())},
      );

      return User.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> requestOtp(String email) async {
    try {
      await apiService.post('/request-otp', data: {'email': email});
    } catch (e) {
      rethrow;
    }
  }

  Future<User> login(LoginDto loginDto) async {
    try {
      final response = await apiService.post(
        '/login',
        data: {...loginDto.toJson(), ...(await _fetchDeviceInfo())},
      );

      return User.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(ResetPasswordDto resetPasswordDto) async {
    try {
      await apiService.patch('/reset-password', data: resetPasswordDto.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await ApiService(
        baseUrl: '${AppConstants.baseUrl}/auth',
        unAuthorized: false,
      ).patch(
        '/change-password',
        data: {'oldPassword': oldPassword, 'newPassword': newPassword},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> suggestUserNames({required String email}) async {
    try {
      final response = await apiService.get(
        '/suggest-usernames',
        queryParams: {'email': email},
      );

      return List<String>.from(
        response['data'].map((e) {
          return e as String;
        }),
      );
    } catch (e) {
      rethrow;
    }
  }
}
