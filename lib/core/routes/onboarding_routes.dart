import 'package:go_router/go_router.dart';

import '../../views/screens/onboarding/landing_page.dart';
import '../../views/screens/onboarding/splash_screen.dart';


final onboardingRoutes = <GoRoute>[
  GoRoute(
      path: SplashScreen.path,
      name: SplashScreen.routeName,
      builder: (context, routeState) {
        return SplashScreen();
      }),
  GoRoute(
      path: LandingPage.path,
      name: LandingPage.routeName,
      builder: (context, routeState) {
        return LandingPage();
      }),
];
