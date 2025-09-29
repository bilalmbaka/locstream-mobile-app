import 'package:flutter/material.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/core/utils/extensions/string_extension.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/views/widgets/action_tile.dart';
import 'package:locstream/views/widgets/app_bars/general_app_bar.dart';
import 'package:locstream/views/widgets/app_text_field.dart';

class SettingsHome extends StatelessWidget {
  static const routeName = 'settings';
  static const path = routeName;

  const SettingsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: AppStrings.settings.firstLetterToUpperCase()),
      body: AppHelpers.wrapChildWithLayoutBuilder(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 30,
          children: [
            Column(
              spacing: 20,
              children: [
                ActionTile(title: AppStrings.changePassword, onTap: () {}),
                ActionTile(title: AppStrings.contactSupport, onTap: () {}),
                ActionTile(title: AppStrings.deleteAccount, onTap: () {}),
              ],
            ),

            AppTextField(
              text: "Version 1.2.3",
              textStyle: AppTextStyle(context: context, fontSize: 12).fw900(),
            ),
          ],
        ),
      ),
    );
  }
}
