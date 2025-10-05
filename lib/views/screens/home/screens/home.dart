import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/constants/constants.dart';

import 'package:locstream/core/services/foreground_service.dart';
import 'package:locstream/core/services/shared_pref/share_prefs_impl.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/screens/home/widgets/drawer.dart';
import 'package:locstream/views/screens/home/widgets/map.dart';

import '../../../../core/services/location_task_handler.dart';

class Home extends ConsumerStatefulWidget {
  static const routeName = 'home';
  static const path = '/$routeName';

  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(watchingViewModel.notifier).initialize();
      ref.read(watchingViewModel.notifier).connect();
      ref.read(profileViewModel.notifier).getProfile();

      sendLocationInBackground.value =
          await SharedPrefsService().getBool(
            AppConstants.backgroundLocationUpdateKey,
          ) ??
          true;

      AppForegroundService.initCommunicationPort();
      AppForegroundService.initService();
      await AppForegroundService.requestBootPermission();
      AppForegroundService.addCallback((data) {
        final Map<String, dynamic> locationJson = data as Map<String, dynamic>;
        if (mounted) {
          ref
              .read(locationViewModel.notifier)
              .setLocation(
                latitude: locationJson['lat'] as double,
                longitude: locationJson['lng'] as double,
              );
        }
      });

      if (sendLocationInBackground.value) {
        await AppForegroundService.start(startLocationHandlerCallback);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: HomeEndDrawer(),
      body: Stack(
        children: [
          MapScreen(),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Scaffold.of(context).openEndDrawer(),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.ladingPageGradientGreen,
                  shape: BoxShape.circle,
                ),
                child: EndDrawerButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
