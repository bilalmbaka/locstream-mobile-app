import '../constants/strings.dart';
import '../utils/helpers/helpers.dart';
import 'exceptions.dart';

class AppExceptionHandler {
  static String handleException(Object e,
      {StackTrace? stackTrace, bool sendToLogger = false}) {
    AppHelpers.printToLog("Exception handled: ---- ${e.toString()}");

    if (e is ApiException) {
      return e.message;
    }

    if (e is SharedPrefException) {
      return e.message;
    }

    return AppStrings.somethingWentWrong;
  }
}
