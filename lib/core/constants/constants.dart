import 'package:flutter/material.dart';

import '../utils/extensions/double_extensions.dart';

class AppConstants {
  //Fontfamilies
  static const nunitoFontFamily = 'Nunito';
  static const montserratFontFamily = 'Montserrat';

  static const appName = 'Locstream';
  static const appNameInitials = 'LS';

  static const packageName = 'com.thepocketmerlin.app';

  //Spacers
  static final smallYSpace = 8.0.h;
  static final smallXSpace = 8.0.w;
  static final mediumYSpace = 16.0.h;
  static final mediumXSpace = 16.0.w;
  static final largeYSpace = 24.0.h;
  static final largeXSpace = 24.0.w;
  static final extraLargeYSpace = 32.0.h;
  static final extraLargeXSpace = 32.0.w;

  //keys
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  //urls
  static const baseUrl = String.fromEnvironment('baseUrl');
  static const mapBoxDirectionBaseUrl =
      'https://api.mapbox.com/directions/v5/mapbox';
  static const mapBoxPublicKey = String.fromEnvironment('mapboxPublicKey');
  static const mapBoxStyleUrl = String.fromEnvironment('mapboxStyleUrl');
  static const socketUrl = String.fromEnvironment('socketUrl');
  static const flavor = String.fromEnvironment('appFlavor');

  //local storage keys
  static const userKey = 'userProfile';
  static const authTokenKey = 'authToken';
  static const refreshTokenKey = 'refreshToken';

  //file types
  static const images = ['.png', '.jpg'];
  static const videos = ['.mp4', '.mkv'];

  static const int paginationJump = 20;

  //Socket events
  static const locationSharesSocketEvent = 'locationSharers';
  static const locationChangeSocketEvent = 'locationChange';
  static const connectionErrorEvent = 'connectionError';
  static const disconnectErrorEvent = 'disconnectErrorEvent';
  static const reconnectedEvent = 'reconnectedEvent';
}
