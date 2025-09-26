import 'package:flutter/material.dart';

import '../../../core/styling/colors.dart';
import '../../../core/styling/text_style.dart';
import '../app_text_field.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    this.isLoading = false,
    this.onTap,
    this.child,
    this.text,
    this.backgroundColor,
    this.disabledColor,
    this.width,
    this.height,
    this.borderColor,
    this.borderRadius,
    this.textStyle,
    this.textColor,
  });

  final bool isLoading;
  final VoidCallback? onTap;
  final Widget? child;
  final String? text;
  final Color? backgroundColor;
  final Color? disabledColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final TextStyle? textStyle;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    assert(
        child != null || text != null, "Either child or text must be non-null");

    return OutlinedButton(
        onPressed: onTap,
        style: ButtonStyle(
          shape: borderRadius != null
              ? WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)))
              : null,
          backgroundColor:
              WidgetStateProperty.resolveWith((Set<WidgetState> state) {
            if (state.contains(WidgetState.disabled)) {
              return disabledColor;
            }

            return backgroundColor;
          }),
          side: WidgetStateProperty.all(
              BorderSide(color: borderColor ?? AppColors.primaryColor)),
          fixedSize: width != null && height != null
              ? WidgetStateProperty.all(Size(width!, height!))
              : null,
        ),
        child: Center(
          child: child ??
              AppTextField(
                text: text!,
                textStyle: textStyle ??
                    AppTextStyle(
                      context: context,
                      color: textColor,
                      fontSize: 13,
                    ).fw900(),
              ),
        ));
  }
}
