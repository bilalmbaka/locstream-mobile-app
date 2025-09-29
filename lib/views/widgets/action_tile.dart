import 'package:flutter/material.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/views/widgets/app_text_field.dart';

class ActionTile extends StatelessWidget {
  const ActionTile({super.key, required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 10,
          children: [
            AppTextField(
              text: title,
              textStyle: AppTextStyle(context: context, fontSize: 13).fw500(),
            ),

            Icon(Icons.arrow_forward_ios_outlined, size: 10),
          ],
        ),
      ),
    );
  }
}
