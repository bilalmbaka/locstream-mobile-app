import 'package:flutter/material.dart';

extension IntegerExtensions on int {
  SizedBox get h => SizedBox(
    height: toDouble(),
  );

  SizedBox get w => SizedBox(
    width: toDouble(),
  );

  SizedBox get wh => SizedBox(
    width:  toDouble(),
    height: toDouble(),
  );
}