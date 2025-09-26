import 'package:flutter/material.dart';

import '../../../core/styling/colors.dart';
import '../../../core/styling/text_style.dart';
import '../../../core/utils/extensions/string_extension.dart';
import '../app_text_field.dart';

class ToggleButton extends StatelessWidget {
  const ToggleButton(
      {super.key,
      required this.onTap,
      this.name,
      this.child,
      this.isSelected = false});

  final String? name;
  final Widget? child;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    assert(name != null || child != null, "Either name or child is required");

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.stroke),
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? AppColors.primaryColor : Colors.transparent),
        child: name != null
            ? AppTextField(
                text: name!.firstLetterToUpperCase(),
                textStyle: isSelected
                    ? AppTextStyle(
                            context: context,
                            fontSize: 14,
                            color: AppColors.white)
                        .fw900()
                    : AppTextStyle(
                        context: context,
                        fontSize: 13,
                      ).fw400(),
              )
            : child!,
      ),
    );
  }
}
