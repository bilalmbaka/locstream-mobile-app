import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/constants/images.dart';

import 'package:locstream/core/services/location_service.dart';
import 'package:locstream/core/services/push_notification/notification_service.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/data/data_sources/local_data_sources/profile_local_data_source.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/screens/authentication/set_username.dart';
import 'package:locstream/views/screens/authentication/signup_email_verification_screen.dart';
import 'package:locstream/views/screens/home/screens/home.dart';
import 'package:locstream/views/screens/required_permission_screen.dart';
import 'package:locstream/views/widgets/media/image_view.dart';

import '../../../core/services/navigation_service.dart';
import '../../../data/data_sources/local_data_sources/auth_local_data_source.dart';
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
        final user = await ProfileLocalDataSource().getProfile();

        if (accessToken != null && refreshToken != null && user != null) {
          await _loadCachedData();
          await Future.delayed(Duration(seconds: 2), () async {
            String nextScreen = Home.routeName;

            if (user.userName == null) {
              nextScreen = SetUserNameScreen.routeName;
            }

            if (user.emailVerified == false) {
              nextScreen = SignupEmailVerificationScreen.routeName;
            }

            if (mounted) {
              if (requiredPermissionsGranted) {
                await NavigationService.jumpToScreen(
                  context: context,
                  routeName: nextScreen,
                );
              } else {
                return await NavigationService.jumpToScreen(
                  context: context,
                  routeName: RequiredPermissionScreen.routeName,
                  data: nextScreen,
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
      body: Center(
        child: ImageView(
          image: Images.appLogo,
          color: AppColors.white,
          width: 80,
          height: 80,
        ),
      ),
    );
  }

  Future<void> _loadCachedData() async {
    await ref.read(profileViewModel.notifier).getProfileFromLocal();
  }
}
