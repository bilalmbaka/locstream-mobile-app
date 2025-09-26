import 'package:flutter/material.dart';

import '../../../core/styling/colors.dart';
import '../../../core/styling/text_style.dart';
import '../../../core/utils/extensions/string_extension.dart';
import '../app_text_field.dart';

class RemovableItemButton extends StatelessWidget {
  const RemovableItemButton(
      {super.key, required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.stroke),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Icon(
              Icons.close,
              size: 10,
            ),
            AppTextField(
              text: name.firstLetterToUpperCase(),
              textStyle: AppTextStyle(
                context: context,
              ).fw400(),
            )
          ],
        ),
      ),
    );
  }
}
