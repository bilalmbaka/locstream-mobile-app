import '../constants/strings.dart';
import '../error_handlers/exceptions.dart';

class StorageExceptionHandler {
  static SharedPrefException handleException(Object e) {
    return SharedPrefException(
      message: AppStrings.somethingWentWrong,
      exception: e,
    );
  }
}
