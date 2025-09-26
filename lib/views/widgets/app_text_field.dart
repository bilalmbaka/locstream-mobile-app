import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {super.key,
      required this.text,
      this.overflow = false,
      this.textStyle,
      this.maxLines,
      this.textAlign});

  final String text;
  final TextStyle? textStyle;
  final int? maxLines;
  final bool overflow;
  final TextAlign? textAlign;
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow ? TextOverflow.ellipsis : null,
    );
  }
}
