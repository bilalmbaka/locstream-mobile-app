import 'package:flutter/material.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/views/screens/home/widgets/drawer.dart';
import 'package:locstream/views/screens/home/widgets/map.dart';

class Home extends StatefulWidget {
  static const routeName = 'home';
  static const path = '/$routeName';

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
