import 'package:flutter/material.dart';
import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/core/constants/images.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/services/location_service.dart';
import 'package:locstream/core/services/navigation_service.dart';
import 'package:locstream/core/services/push_notification/notification_service.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/core/utils/extensions/integer_extensions.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/views/widgets/app_bars/general_app_bar.dart';
import 'package:locstream/views/widgets/app_text_field.dart';
import 'package:locstream/views/widgets/media/image_view.dart';

class RequiredPermissionScreen extends StatefulWidget {
  static const routeName = 'required-permissions';
  static const path = '/$routeName';

  const RequiredPermissionScreen({super.key, this.nextScreen});

  final String? nextScreen;

  @override
  State<RequiredPermissionScreen> createState() =>
      _RequiredPermissionScreenState();
}

class _RequiredPermissionScreenState extends State<RequiredPermissionScreen> {
  bool _isGrantingLocationPermission = false;
  bool _isGrantingNotificationPermission = false;
  bool _isLocationPermissionGranted = false;
  bool _isNotificationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkPermissions();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.help, color: Colors.white),
          ),
        ],
      ),
      body: AppHelpers.wrapChildWithLayoutBuilder(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: ImageView(
                image: Images.authorization,
                color: AppColors.white,
              ),
            ),
            AppConstants.mediumYSpace,
            AppTextField(
              text: AppStrings.requiredPermissions,
              textStyle: AppTextStyle(context: context).fw700(),
              textAlign: TextAlign.center,
            ),
            100.h,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTextField(text: AppStrings.locationPermission),
                (_isLocationPermissionGranted)
                    ? Icon(Icons.check)
                    : _button(
                        _grantLocationPermission,
                        AppStrings.grant,
                        isLoading: _isGrantingLocationPermission,
                      ),
              ],
            ),
            AppConstants.largeYSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                AppTextField(text: AppStrings.notificationPermission),
                (_isNotificationPermissionGranted)
                    ? Icon(Icons.check)
                    : _button(
                        _grantNotificationPermission,
                        AppStrings.grant,
                        isLoading: _isGrantingNotificationPermission,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkPermissions() async {
    _isLocationPermissionGranted = await LocationService()
        .isPermissionGranted();
    _isNotificationPermissionGranted = await NotificationService()
        .requestPermission();

    if (_isLocationPermissionGranted && _isNotificationPermissionGranted) {
      _nextScreen();
    }
  }

  Future<void> _grantLocationPermission() async {
    setState(() {
      _isGrantingLocationPermission = true;
    });

    _isLocationPermissionGranted = await LocationService().requestPermission();

    setState(() {
      _isGrantingLocationPermission = false;
    });

    await _checkPermissions();
  }

  Future<void> _grantNotificationPermission() async {
    setState(() {
      _isGrantingNotificationPermission = true;
    });

    _isNotificationPermissionGranted = await NotificationService()
        .requestPermission();

    setState(() {
      _isGrantingNotificationPermission = false;
    });

    await _checkPermissions();
  }

  void _nextScreen() async {
    if (widget.nextScreen == null) {
      NavigationService.pop(context: context);
    } else {
      NavigationService.jumpToScreen(
        context: context,
        routeName: widget.nextScreen!,
      );
    }
  }

  Widget _button(VoidCallback onTap, String text, {bool isLoading = false}) {
    return isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator.adaptive(),
          )
        : GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.ladingPageGradientGreen,
                borderRadius: BorderRadius.circular(6),
              ),
              child: AppTextField(
                text: text,
                textStyle: AppTextStyle(
                  context: context,
                  color: AppColors.white,
                ).fw300(),
              ),
            ),
          );
  }
}
