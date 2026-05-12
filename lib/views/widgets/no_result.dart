import 'package:flutter/material.dart';

import '../../core/styling/text_style.dart';
import 'app_text_field.dart';

class NoResult extends StatelessWidget {
  const NoResult({
    super.key,
    required this.message,
    this.image,
    this.imageHeight,
    this.imageWidth,
  });

  final String message;
  final String? image;
  final double? imageWidth;
  final double? imageHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ImageView(
        //   image: image ?? Images.sandClock,
        //   width: imageWidth ?? 50,
        //   height: imageHeight ?? 50,
        // ),
        // 20.h,
        AppTextField(
          text: message,
          textAlign: TextAlign.center,
          textStyle: AppTextStyle(context: context, fontSize: 13).fw600(),
        ),
      ],
    );
  }
}
