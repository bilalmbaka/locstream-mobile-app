import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import '../../../core/constants/constants.dart';
import '../../../core/services/api_service.dart';
import '../../../domain/entities/auth_dto.dart';
import '../../model/signup_response_model.dart';

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
      await apiService.post('/register', data: signupDto.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponseModel> verifyOtp(String otp, SignupDto signupDto) async {
    try {
      final response = await apiService.post(
        '/verify-otp-and-register',
        data: {'otp': otp, 'email': signupDto.email},
      );

      final authModel = AuthResponseModel.fromJson(response['data']);

      return authModel;
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

  Future<AuthResponseModel> login(LoginDto loginDto) async {
    try {
      final response = await apiService.post('/login', data: {
        ...loginDto.toJson(),
        ...(await _fetchDeviceInfo())
      });

      final authModel = AuthResponseModel.fromJson(response['data']);

      return authModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(ResetPasswordDto resetPasswordDto) async {
    try {
      await apiService.post('/reset-password', data: resetPasswordDto.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponseModel> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response =
          await ApiService(
            baseUrl: '${AppConstants.baseUrl}/auth',
            unAuthorized: false,
          ).patch(
            '/change-password',
            data: {'oldPassword': oldPassword, 'newPassword': newPassword},
          );

      return AuthResponseModel.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }
}
