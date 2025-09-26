import 'package:flutter/services.dart';

class AppInputFormatters {
  static TextInputFormatter digitOnly() {
    return FilteringTextInputFormatter.digitsOnly;
  }
}
