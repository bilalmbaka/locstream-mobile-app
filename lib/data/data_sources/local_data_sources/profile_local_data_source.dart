import 'dart:convert';

import '../../../core/constants/constants.dart';

import '../../../core/services/shared_pref/share_prefs_impl.dart';
import '../../model/user_model.dart';

class ProfileLocalDataSource {
  final SharedPrefsService prefs = SharedPrefsService();

  Future<void> saveProfile(User user) async {
    await prefs.setString(
      key: AppConstants.userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<User?> getProfile() async {
    final user = await prefs.getString(AppConstants.userKey);
    return user != null ? User.fromJson(jsonDecode(user)) : null;
  }

  Future<void> clearOfflineProfile() async {
    await prefs.delete(key: AppConstants.userKey);
  }
}
