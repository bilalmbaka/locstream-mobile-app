import 'package:flutter/material.dart';

import '../../../core/styling/colors.dart';
import '../../../core/utils/helpers/helpers.dart';

class ContainerShimmer extends StatelessWidget {
  const ContainerShimmer({
    super.key,
    this.width,
    this.height,
    this.itemCount,
    this.padding,
  });

  final double? width;
  final double? height;
  final int? itemCount;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(itemCount ?? 10, (index) {
          return AppHelpers.defaultShimmer(
            context: context,
            child: Container(
              margin: EdgeInsets.only(bottom: padding ?? 10),
              height: height ?? 50,
              width: width,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }),
      ],
    );
  }
}
