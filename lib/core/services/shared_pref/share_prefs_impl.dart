import 'package:shared_preferences/shared_preferences.dart';

import '../../error_handlers/storage_exception_handler.dart';

class SharedPrefsService {
  Future<void> setStringList({
    required String key,
    required List<String> value,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setStringList(key, value);
  }

  Future<void> setString({required String key, required String value}) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString(key, value);
  }

  Future<void> setBool({required String key, required bool value}) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setBool(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getStringList(key);
  }

  Future<String?> getString(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final value = sharedPreferences.getString(key);

    return value;
  }

  Future<bool?> getBool(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final value = sharedPreferences.getBool(key);

    return value;
  }

  Future<void> delete({required String key}) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();

      await sharedPreferences.remove(key);
    } catch (e) {
      throw StorageExceptionHandler.handleException(e);
    }
  }
}
