import 'package:flutter/material.dart';

class AppTextStyle {
  AppTextStyle({
    required this.context,
    this.color,
    this.fontSize,
    this.underLine = false,
    this.strikeThrough = false,
  }) {
    if (underLine == true) {
      textDecoration = TextDecoration.underline;
    }
    if (strikeThrough == true) {
      textDecoration = TextDecoration.lineThrough;
    }
  }

  final BuildContext context;
  final Color? color;
  final double? fontSize;
  final bool underLine;
  final bool strikeThrough;

  TextDecoration? textDecoration;

  TextStyle? fw300() {
    return Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w300,
          color: color,
          fontSize: fontSize ?? 11,
        );
  }

  TextStyle? fw400() {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w400, color: color, fontSize: fontSize ?? 13);
  }

  TextStyle? fw500() {
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500, color: color, fontSize: fontSize ?? 13);
  }

  TextStyle? fw600() {
    return Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w500, color: color, fontSize: fontSize ?? 15);
  }

  TextStyle? fw700() {
    return Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700, color: color, fontSize: fontSize ?? 17);
  }

  TextStyle? fw800() {
    return Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w800, color: color, fontSize: fontSize ?? 19);
  }

  TextStyle? fw900() {
    return Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w900, color: color, fontSize: fontSize ?? 19);
  }
}
