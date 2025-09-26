import 'package:flutter/material.dart';

import 'app_input_form.dart';

class MultiLineInputForm extends StatelessWidget {
  const MultiLineInputForm({
    super.key,
    required this.controller,
    this.height = 100,
    this.validator,
    this.title,
    this.onChanged,
    this.titleStyle,
  });

  final double height;
  final FormFieldValidator? validator;
  final TextEditingController controller;
  final String? title;
  final Function(String? str)? onChanged;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return AppInputForm(
      title: title,
      controller: controller,
      validator: validator,
      expands: true,
      height: height,
      width: double.infinity,
      keyboardType: TextInputType.multiline,
      onChanged: onChanged,
      titleStyle: titleStyle,
    );
  }
}
