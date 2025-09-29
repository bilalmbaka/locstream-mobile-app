import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locstream/views/widgets/app_text_field.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


import '../../../view_models.dart';
import '../../../views/screens/authentication/login_screen.dart';
import '../../../views/widgets/buttons/plain_button.dart';
import '../../../views/widgets/dialogs/info_dialog.dart';
import '../../constants/constants.dart';
import '../../constants/strings.dart';
import '../../services/navigation_service.dart';
import '../../styling/colors.dart';
import 'dialog_helpers.dart';

class AppHelpers {
  static EdgeInsets defaultPadding({
    double left = 20,
    double top = 10,
    double right = 20,
    double bottom = 50,
  }) {
    return EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 500;
  }

  static bool isWeb(BuildContext context) => kIsWeb;

  static Widget wrapChildWithLayoutBuilder({
    required Widget child,
    EdgeInsets? padding,
    RefreshCallback? refresh,
    ScrollPhysics? physics,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: refresh ?? () => Future.value(),
          child: SingleChildScrollView(
            physics: physics ?? AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: padding ?? AppHelpers.defaultPadding(),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  static void showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Theme.of(context).iconTheme.color,
      textColor: Colors.black,
    );
  }

  static printToLog(String message) {
    if (kDebugMode) {
      print("======================= \n\n$message =======================\n\n");
    }
  }

  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static Future<List<File>> pickMedia({
    required List<String> fileTypes,
    bool allowMultiples = false,
  }) async {
    final media = await FilePicker.platform.pickFiles(
      allowedExtensions: fileTypes,
      type: FileType.custom,
      allowMultiple: allowMultiples,
    );

    if (media == null) return [];

    return List<File>.from(media.xFiles.map((e) => File(e.path)));
  }

  static void forceLogout({required String errorMessage}) {
    final context = AppConstants.rootNavigatorKey.currentContext!;

    AppHelpers.showToast(context, errorMessage);

    NavigationService.jumpToScreen(
      context: context,
      routeName: LoginScreen.routeName,
    );
  }

  static Future<void> resetState(WidgetRef ref) async {
    await ref.read(loginViewModel.notifier).deleteAuthTokens();
    await ref.read(profileViewModel.notifier).reset();
  }

  static void overLayDisabledBanner({required String message}) {
    final context = AppConstants.rootNavigatorKey.currentContext!;

    DialogHelpers.showAppDialog(
      context: context,
      dismissible: false,
      child: InfoDialog(
        title: AppStrings.information,
        dismissible: false,
        information: message,
        actionButton: PlainButton(
          onTap: () {
            //Open website to contact support
          },
          text: AppStrings.contactSupport,
        ),
      ),
    );
  }

  static Widget defaultShimmer({
    required BuildContext context,
    required Widget child,
  }) {
    return Shimmer.fromColors(
      baseColor: AppColors.stroke,
      highlightColor: Colors.white,
      child: child,
    );
  }

  static bool atPaginationScrollExtent(ScrollController controller) {
    return controller.position.pixels == (controller.position.maxScrollExtent);
  }

  static Future<void> copyToClipboard({
    required BuildContext context,
    required String text,
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    AppHelpers.showToast(context, "Copied to clipboard");
  }

  static showSnackBar({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppTextField(text: message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  static void moveCameraToLocation(
    MapController mapController,
    double latitude,
    double longitude, {
    double? zoom,
  }) {
    final zoomValue = zoom ?? mapController.camera.zoom;
    final position = LatLng(latitude, longitude);

    mapController.move(position, zoomValue);
  }
}
