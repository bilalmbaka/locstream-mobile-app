import 'package:flutter/material.dart';

import '../../core/styling/colors.dart';
import '../../core/styling/text_style.dart';
import 'app_text_field.dart';
import 'media/image_view.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.initials,
    this.profilePicture,
    this.borderRadius,
    this.width,
    this.height,
    this.initialsFontSize,
    this.defaultWidgetPadding,
    this.textStyle,
  });

  final String initials;
  final String? profilePicture;
  final double? borderRadius;
  final double? width;
  final double? height;
  final double? initialsFontSize;
  final double? defaultWidgetPadding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 1000),
      child: Builder(builder: (context) {
        if (profilePicture == null) {
          return Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(defaultWidgetPadding ?? 12),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppColors.complimentary),
            child: Center(
              child: AppTextField(
                text: initials.toUpperCase(),
                textStyle: textStyle ?? AppTextStyle(
                        context: context,
                        fontSize: initialsFontSize ?? 18,
                        color: AppColors.white)
                    .fw900(),
              ),
            ),
          );
        } else {
          return ImageView(
            width: width,
            height: height,
            image: profilePicture!,
          );
        }
      }),
    );
  }
}
