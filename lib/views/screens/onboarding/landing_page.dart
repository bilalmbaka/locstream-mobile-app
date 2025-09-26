/*
Created by: Mbaka bilal <mbakabilal.t@gmail.com>
Created on: 15,June,2025
Updated by: Mbaka bilal <mbakabilal.t@gmail.com>
Updated on: 20,June,2025
*/

import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/strings.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/styling/colors.dart';
import '../../../core/styling/text_style.dart';
import '../../../core/utils/extensions/integer_extensions.dart';
import '../../../core/utils/extensions/string_extension.dart';
import '../../../core/utils/helpers/helpers.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/buttons/outlined_button.dart' show AppOutlinedButton;
import '../../widgets/media/image_view.dart';
import '../authentication/login_screen.dart';

class LandingPage extends StatelessWidget {
  static const path = "/$routeName";
  static const routeName = "landingPage";

  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                  0.3,
                  0.8
                ],
                    colors: [
                  // AppColors.ladingPageGradientBlue,
                  AppColors.ladingPageGradientGreen,
                  AppColors.primaryColor,
                ])),
            child: ImageView(
              image: Images.landingPagePattern,
              width: double.infinity,
              height: double.infinity,
              boxFit: BoxFit.fill,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _child(context),
            ],
          )
        ],
      ),
    );
  }

  Widget _child(BuildContext context) {
    return Container(
      padding: AppHelpers.defaultPadding(),
      constraints: BoxConstraints(maxWidth: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageView(image: Images.logoWhite),
              AppConstants.smallXSpace,
              AppTextField(
                text: AppStrings.appName.firstLetterToUpperCase(),
                textStyle: AppTextStyle(
                  context: context,
                  color: AppColors.white,
                  fontSize: 35,
                ).fw800(),
              )
            ],
          ),
          50.h,
          AppTextField(
            text: AppStrings.secureTransactionsWithEase,
            overflow: false,
            textStyle: AppTextStyle(
                    context: context, fontSize: 55, color: AppColors.white)
                .fw600(),
          ),
          AppConstants.mediumYSpace,
          AppOutlinedButton(
            onTap: () {
              NavigationService.pushToScreen(
                  context: context, routeName: LoginScreen.routeName);

            },
            borderColor: AppColors.white,
            text: AppStrings.showMe,
            textStyle: AppTextStyle(
                    context: context, color: AppColors.white, fontSize: 16)
                .fw800(),
          )
        ],
      ),
    );
  }
}
