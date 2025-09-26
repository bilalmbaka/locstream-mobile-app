import 'package:go_router/go_router.dart';

import '../../views/screens/onboarding/splash_screen.dart';
import '../constants/constants.dart';
import 'auth_routes.dart';
import 'onboarding_routes.dart';

final publicRoutes = <GoRoute>[
  ...onboardingRoutes,
  ...authRoutes,
];
final privateRoutes = <GoRoute>[
  // GoRoute(
  //     path: Dashboard.path,
  //     name: Dashboard.routeName,
  //     builder: (context, routeState) {
  //       return const Dashboard();
  //     },
  //     routes: [
  //
  //     ]),
];

final routes = GoRouter(
    debugLogDiagnostics: true,
    restorationScopeId: 'router',
    navigatorKey: AppConstants.rootNavigatorKey,
    initialLocation: SplashScreen.path,
    routes: <GoRoute>[...publicRoutes, ...privateRoutes]);
