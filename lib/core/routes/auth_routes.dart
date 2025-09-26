import 'package:go_router/go_router.dart';

import '../../views/screens/authentication/login_screen.dart';
import '../../views/screens/authentication/new_password_screen.dart';
import '../../views/screens/authentication/reset_password_screen.dart';
import '../../views/screens/authentication/signup_email_verification_screen.dart';
import '../../views/screens/authentication/signup_screen.dart';
import '../services/navigation_service.dart';

final authRoutes = <GoRoute>[
  GoRoute(
    path: LoginScreen.path,
    name: LoginScreen.routeName,
    builder: (context, routeState) => LoginScreen(),
  ),
  GoRoute(
    path: SignupScreen.path,
    name: SignupScreen.routeName,
    builder: (context, routeState) => SignupScreen(),
  ),
  GoRoute(
    path: ResetPasswordScreen.path,
    name: ResetPasswordScreen.routeName,
    pageBuilder: (context, state) {
      return PageTransitionAnimationHelper.animateGoRoutePageTransition(
          state: state,
          type: PageTransitionStyle.rightToLeft,
          child: ResetPasswordScreen());
    },
  ),
  GoRoute(
    path: NewPasswordScreen.path,
    name: NewPasswordScreen.routeName,
    builder: (context, routeState) => NewPasswordScreen(),
  ),
  GoRoute(
    path: SignupEmailVerificationScreen.path,
    name: SignupEmailVerificationScreen.routeName,
    builder: (context, routeState) => SignupEmailVerificationScreen(),
  ),
];
