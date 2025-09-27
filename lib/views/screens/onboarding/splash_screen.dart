import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:locstream/core/services/location_service.dart';
import 'package:locstream/core/services/push_notification/notification_service.dart';
import 'package:locstream/views/screens/home.dart';
import 'package:locstream/views/screens/required_permission_screen.dart';

import '../../../core/constants/images.dart';
import '../../../core/services/navigation_service.dart';
import '../../../data/data_sources/local_data_sources/auth_local_data_source.dart';
import '../../widgets/media/image_view.dart';
import '../authentication/login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const path = '/';
  static const routeName = '/splashScreen';

  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final requiredPermissionsGranted =
            await LocationService().isPermissionGranted() &&
            await NotificationService().requestPermission();

        final accessToken = await AuthLocalDataSource().getAuthToken();
        final refreshToken = await AuthLocalDataSource().getRefreshToken();

        if (accessToken != null && refreshToken != null) {
          await _loadCachedData();
          await Future.delayed(Duration(seconds: 2), () async {
            if (mounted) {
              if (requiredPermissionsGranted) {
                await NavigationService.jumpToScreen(
                  context: context,
                  routeName: Home.routeName,
                );
              } else {
                await NavigationService.jumpToScreen(
                  context: context,
                  routeName: RequiredPermissionScreen.routeName,
                  data: Home.routeName,
                );
              }
            }
          });
        } else {
          await Future.delayed(Duration(seconds: 2), () async {
            if (mounted) {
              if (requiredPermissionsGranted) {
                await NavigationService.jumpToScreen(
                  context: context,
                  routeName: LoginScreen.routeName,
                );
              } else {
                await NavigationService.jumpToScreen(
                  context: context,
                  routeName: RequiredPermissionScreen.routeName,
                  data: LoginScreen.routeName,
                );
              }
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: ImageView(
          //     image: Images.blurredColor,
          //     width: double.infinity,
          //     height: double.infinity,
          //   ),
          // ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(),
            ),
          ),
          // Center(child: ImageView(image: Images.logo)),
        ],
      ),
    );
  }

  Future<void> _loadCachedData() async {}
}
