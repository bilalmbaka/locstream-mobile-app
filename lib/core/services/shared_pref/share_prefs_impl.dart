import 'package:shared_preferences/shared_preferences.dart';

import '../../error_handlers/storage_exception_handler.dart';

class SharedPrefsService {
  Future<void> setValue({required String key, required dynamic value}) async {
    try {
      if (value is List<String>) {
        await _setStringList(key, value);
      }

      if (value is String) {
        await _setString(key, value);
      }

      if (value is bool) {
        await _setBool(key, value);
      }
    } catch (e) {
      throw StorageExceptionHandler.handleException(e);
    }
  }

  Future<T?> fetchValue<T>({required String key}) async {
    try {
      if (T == List<String>) {
        return await _getStringList(key) as T?;
      }

      if (T == String) {
        return await _getString(key) as T?;
      }

      if (T == bool) {
        return await _getBool(key) as T?;
      }

      return null;
    } catch (e) {
      throw StorageExceptionHandler.handleException(e);
    }
  }

  Future<void> _setStringList(String key, List<String> value) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setStringList(key, value);
  }

  Future<void> _setString(String key, String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString(key, value);
  }

  Future<void> _setBool(String key, bool value) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setBool(key, value);
  }

  Future<List<String>?> _getStringList(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getStringList(key);
  }

  Future<String?> _getString(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final value = sharedPreferences.getString(key);

    return value;
  }

  Future<bool?> _getBool(String key) async {
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
