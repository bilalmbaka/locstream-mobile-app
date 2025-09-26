import 'package:flutter/material.dart';

import '../../core/styling/colors.dart';

class ShadowedBox extends StatelessWidget {
  const ShadowedBox({
    super.key,
    required this.child,
    this.width,
    this.padding,
    this.backgroundColor,
  });

  final Widget child;
  final double? width;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: width,
      decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(1, 5),
                color: AppColors.blurColor)
          ]),
      child: child,
    );
  }
}
