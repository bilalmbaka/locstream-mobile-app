import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';
import '../../core/constants/strings.dart';
import '../../core/styling/colors.dart';
import '../../core/styling/text_style.dart';
import 'app_text_field.dart';

class SeeAll extends StatelessWidget {
  const SeeAll({super.key, required this.title, required this.onTap});

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextField(
          text: title,
          textStyle: AppTextStyle(context: context, fontSize: 14).fw900(),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Row(
            children: [
              AppTextField(
                text: AppStrings.seeAll,
                textStyle: AppTextStyle(
                        context: context, fontSize: 12, color: AppColors.text3)
                    .fw400(),
              ),
              AppConstants.smallXSpace,
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.text3,
                size: 13,
              )
            ],
          ),
        )
      ],
    );
  }
}
