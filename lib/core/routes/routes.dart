import 'package:go_router/go_router.dart';
import 'package:locstream/views/screens/add_new_watcher.dart';
import 'package:locstream/views/screens/authentication/set_username.dart';
import 'package:locstream/views/screens/onboarding/splash_screen.dart';
import 'package:locstream/views/screens/profile/screens/change_password_screen.dart';
import 'package:locstream/views/screens/profile/screens/edit_profile_screen.dart';
import 'package:locstream/views/screens/profile/screens/other_user_profile_screen.dart';
import 'package:locstream/views/screens/settings/contact_support_screen.dart';
import 'package:locstream/views/screens/settings/delete_accont_screen.dart';
import 'package:locstream/views/screens/settings/settings_home.dart';

import '../../views/screens/home/screens/home.dart';
import '../../views/screens/required_permission_screen.dart';
import '../constants/constants.dart';
import 'auth_routes.dart';
import 'onboarding_routes.dart';

final publicRoutes = <GoRoute>[
  ...onboardingRoutes,
  GoRoute(
    path: RequiredPermissionScreen.path,
    name: RequiredPermissionScreen.routeName,
    builder: (context, routeState) {
      return RequiredPermissionScreen(nextScreen: routeState.extra as String?);
    },
  ),
  ...authRoutes,
];
final privateRoutes = <GoRoute>[
  GoRoute(
    path: SetUserNameScreen.path,
    name: SetUserNameScreen.routeName,
    builder: (context, routeState) {
      return SetUserNameScreen();
    },
  ),
  GoRoute(
    path: Home.path,
    name: Home.routeName,
    builder: (context, routeState) {
      return const Home();
    },
    routes: [
      GoRoute(
        path: AddNewWatcher.path,
        name: AddNewWatcher.routeName,
        builder: (context, routeState) {
          return AddNewWatcher();
        },
      ),
      GoRoute(
        path: EditProfileScreen.path,
        name: EditProfileScreen.routeName,
        builder: (context, routeState) {
          return EditProfileScreen();
        },
      ),
      GoRoute(
        path: SettingsHome.path,
        name: SettingsHome.routeName,
        builder: (context, routeState) {
          return SettingsHome();
        },
      ),
      GoRoute(
        path: OtherUserProfileScreen.path,
        name: OtherUserProfileScreen.routeName,
        builder: (context, routeState) {
          return OtherUserProfileScreen();
        },
      ),
      GoRoute(
        path: ChangePasswordScreen.path,
        name: ChangePasswordScreen.routeName,
        builder: (context, routeState) {
          return ChangePasswordScreen();
        },
      ),
      GoRoute(
        path: DeleteAccountScreen.path,
        name: DeleteAccountScreen.routeName,
        builder: (context, routeState) {
          return DeleteAccountScreen();
        },
      ),
      GoRoute(
        path: ContactSupportScreen.path,
        name: ContactSupportScreen.routeName,
        builder: (context, routeState) {
          return ContactSupportScreen();
        },
      ),
    ],
  ),
];

final routes = GoRouter(
  debugLogDiagnostics: true,
  restorationScopeId: 'router',
  navigatorKey: AppConstants.rootNavigatorKey,
  initialLocation: SplashScreen.path,
  routes: <GoRoute>[...publicRoutes, ...privateRoutes],
);
