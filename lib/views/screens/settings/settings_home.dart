import 'package:flutter/material.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/error_handlers/exception_handler.dart';
import 'package:locstream/core/services/navigation_service.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/core/utils/extensions/string_extension.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/views/screens/profile/screens/change_password_screen.dart';
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
                ActionTile(
                  title: AppStrings.changePassword,
                  onTap: () {
                    NavigationService.pushToScreen(
                      context: context,
                      routeName: ChangePasswordScreen.routeName,
                    );
                  },
                ),
                ActionTile(title: AppStrings.contactSupport, onTap: () {}),
                ActionTile(title: AppStrings.deleteAccount, onTap: () {}),
              ],
            ),

            FutureBuilder(
              future: fetchAppInfo(),
              builder: (context, state) {
                if (state.hasData) {
                  final data = state.data;

                  if (data == null) return Offstage();

                  return AppTextField(
                    text: data.appVersion,
                    textStyle: AppTextStyle(
                      context: context,
                      fontSize: 12,
                    ).fw900(),
                  );
                }

                return Offstage();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<AppInfo?> fetchAppInfo() async {
    try {
      final info = await AppHelpers.fetchDeviceAndPackageInfo();

      return info;
    } catch (e, s) {
      AppExceptionHandler.handleException(e, stackTrace: s, sendToLogger: true);

      return null;
    }
  }
}
