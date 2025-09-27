import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/strings.dart';
import 'core/routes/routes.dart';
import 'core/styling/theme.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme.darkTheme,
        routerConfig: routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
