import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/screens/home/widgets/drawer.dart';
import 'package:locstream/views/screens/home/widgets/map.dart';

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
      ref.read(watchingViewModel.notifier).connect();
      ref.read(profileViewModel.notifier).getProfile();
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
