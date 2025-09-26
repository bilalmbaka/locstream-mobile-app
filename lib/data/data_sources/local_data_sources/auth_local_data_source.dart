import '../../../core/constants/constants.dart';
import '../../../core/services/shared_pref/share_prefs_impl.dart';

class AuthLocalDataSource {
  final SharedPrefsService prefs = SharedPrefsService();

  Future<void> saveAuthToken(String token) async {
    await prefs.setValue(key: AppConstants.authTokenKey, value: token);
  }

  Future<String?> getAuthToken() async {
    return await prefs.fetchValue<String>(key: AppConstants.authTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await prefs.setValue(key: AppConstants.refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await prefs.fetchValue<String>(key: AppConstants.refreshTokenKey);
  }

  Future<void> deleteAuthTokens() async {
    try {
      await prefs.delete(key: AppConstants.authTokenKey);
      await prefs.delete(key: AppConstants.refreshTokenKey);
    } catch (e) {
      rethrow;
    }
  }
}
