import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.width,
    this.height,
    this.strokeWidth = 1,
    this.color
  });

  final double? width;
  final double? height;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CircularProgressIndicator.adaptive(
          backgroundColor: color,
          strokeWidth: strokeWidth),
    );
  }
}
