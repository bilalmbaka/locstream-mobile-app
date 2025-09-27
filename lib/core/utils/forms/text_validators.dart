import '../../constants/strings.dart';

class AppTextValidators {
  static String? isEmpty(dynamic str) {
    if (str == null || str.trim().isEmpty) return AppStrings.fieldCannotBeEmpty;

    return null;
  }

  static String? isEmail(dynamic str) {
    final empty = isEmpty(str);

    if (empty != null) return empty;

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(str)) return AppStrings.invalidEmail;

    return null;
  }

  static String? isName(dynamic str) {
    final empty = isEmpty(str);

    if (empty != null) return empty;

    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');

    if (!nameRegex.hasMatch(str)) return AppStrings.invalidName;

    return null;
  }

  static String? isUserName(dynamic str) {
    final empty = isEmpty(str);

    if (empty != null) return empty;

    final nameRegex = RegExp(r'^[a-zA-Z0-9\s]+$');

    if (!nameRegex.hasMatch(str)) return AppStrings.invalidUserName;

    if (str.length < 5) return AppStrings.userNameTooShort;

    return null;
  }

  static String? isPhoneNumber(dynamic str) {
    final empty = isEmpty(str);

    if (empty != null) return empty;

    final phoneRegex = RegExp(r'^[0-9]+$');

    if (!phoneRegex.hasMatch(str)) return AppStrings.invalidPhoneNumber;

    return null;
  }
}
