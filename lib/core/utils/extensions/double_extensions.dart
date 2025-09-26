import 'package:flutter/material.dart';

extension DoubleExtensions on double {
  SizedBox get h => SizedBox(
        height: this,
      );

  SizedBox get w => SizedBox(
        width: this,
      );

  SizedBox get wh => SizedBox(
        width: this,
        height: this,
      );
}
