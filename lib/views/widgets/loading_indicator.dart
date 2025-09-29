import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.width,
    this.height,
    this.strokeWidth = 1,
  });

  final double? width;
  final double? height;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CircularProgressIndicator.adaptive(strokeWidth: strokeWidth),
    );
  }
}
