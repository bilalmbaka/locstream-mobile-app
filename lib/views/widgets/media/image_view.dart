import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/styling/colors.dart';
import '../../../core/utils/extensions/string_extension.dart';
import 'fullscreen_imageview.dart';

class ImageView extends StatelessWidget {
  const ImageView({
    super.key,
    required this.image,
    this.boxFit = BoxFit.cover,
    this.bytes,
    this.width,
    this.color,
    this.height,
    this.borderRadius,
    this.canShowFullScreen = false,
    this.scale,
  });

  final String image;
  final Uint8List? bytes;
  final double? width;
  final double? height;
  final BoxFit boxFit;
  final Color? color;
  final double? borderRadius;
  final bool canShowFullScreen;
  final double? scale;

  Widget _child() {
    if (bytes != null) {
      return Image.memory(
        bytes!,
        fit: boxFit,
        width: width,
        height: height,
        color: color,
      );
    }

    if (image.isRemote) {
      return Image.network(
        image,
        fit: boxFit,
        width: width,
        height: height,
        color: color,
        loadingBuilder: (context, widget, progress) {
          if (progress == null) return widget;

          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(color: AppColors.primaryColor),
              child: CupertinoActivityIndicator(color: AppColors.white),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(color: AppColors.primaryColor),
            ),
          );
        },
      );
    }

    if (image.isAnAsset) {
      if (image.isSvg) {
        return SvgPicture.asset(
          image,
          fit: boxFit,
          width: width,
          height: height,
          colorFilter: color == null
              ? null
              : ColorFilter.mode(color!, BlendMode.srcIn),
        );
      } else {
        return Image.asset(
          image,
          scale: scale,
          fit: boxFit,
          width: width,
          height: height,
          color: color,
        );
      }
    }

    //Assume it is a file
    return Image.file(File(image), fit: boxFit, width: width, height: height);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: GestureDetector(
        onTap: canShowFullScreen
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullscreenImageview(image: image),
                  ),
                );
              }
            : null,
        child: _child(),
      ),
    );
  }
}
