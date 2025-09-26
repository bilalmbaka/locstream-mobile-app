import 'package:flutter/material.dart';

import '../../../core/styling/colors.dart';
import 'image_view.dart';

class FullscreenImageview extends StatelessWidget {
  const FullscreenImageview({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        color: Colors.black,
        child: Center(
            child: ImageView(
          image: image,
          boxFit: BoxFit.contain,
        )),
      ),
    );
  }
}
