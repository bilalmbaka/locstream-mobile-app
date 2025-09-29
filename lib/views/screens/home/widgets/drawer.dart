import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/services/navigation_service.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/screens/add_new_watcher.dart';
import 'package:locstream/views/screens/authentication/login_screen.dart';
import 'package:locstream/views/screens/home/widgets/drawer_tile.dart';
import 'package:locstream/views/screens/home/widgets/watchers.dart';
import 'package:locstream/views/screens/home/widgets/watching.dart';
import 'package:locstream/views/screens/profile/edit_profile_screen.dart';
import 'package:locstream/views/screens/settings/settings_home.dart';
import 'package:locstream/views/widgets/action_tile.dart';
import 'package:locstream/views/widgets/app_text_field.dart';
import 'package:locstream/views/widgets/profile_picture.dart';

final showWatchers = ValueNotifier(false);
final showWatching = ValueNotifier(false);

class HomeEndDrawer extends ConsumerWidget {
  const HomeEndDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationDrawer(
      header: DrawerHeader(
        child: Stack(
          children: [
            Column(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final userProfile = ref.read(profileViewModel).data;

                    return ProfilePicture(
                      initials: userProfile!.userName![0],
                      profilePicture: userProfile.profilePicture?.url,
                      initialsFontSize: 50,
                    );
                  },
                ),
                AppConstants.mediumYSpace,
                GestureDetector(
                  onTap: () {
                    NavigationService.pop(context: context);

                    NavigationService.pushToScreen(
                      context: context,
                      routeName: EditProfileScreen.routeName,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        AppTextField(
                          text: AppStrings.edit,
                          textStyle: AppTextStyle(
                            context: context,
                            fontSize: 13,
                          ).fw500(),
                        ),
                        Icon(Icons.edit_outlined, size: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              top: -8,
              right: 0,
              child: IconButton(
                onPressed: () {
                  NavigationService.pop(context: context);

                  NavigationService.pushToScreen(
                    context: context,
                    routeName: SettingsHome.routeName,
                  );
                },
                icon: Icon(Icons.settings,size: 20,),
              ),
            ),
          ],
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: GestureDetector(
          onTap: () {
            NavigationService.jumpToScreen(
              context: context,
              routeName: LoginScreen.routeName,
            );
          },
          child: AppTextField(
            text: AppStrings.logout,
            textStyle: AppTextStyle(
              context: context,
              color: AppColors.redMain,
            ).fw500(),
          ),
        ),
      ),

      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ActionTile(
            title: AppStrings.addWatcher,
            onTap: () {
              NavigationService.pop(context: context);

              NavigationService.pushToScreen(
                context: context,
                routeName: AddNewWatcher.routeName,
              );
            },
          ),
        ),

        ValueListenableBuilder(
          valueListenable: showWatchers,
          builder: (context, value, child) => Column(
            children: [
              DrawerTile(
                context: context,
                title: AppStrings.watchers,
                showInfoIcon: true,
                onTap: () {
                  showWatchers.value = !showWatchers.value;
                },
                info: AppStrings.peopleWhoCanSeeWhereYouAre,
                isActive: value,
              ),
              if (value) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: const Watchers(),
                ),
              ],
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: showWatching,
          builder: (context, value, child) => Column(
            children: [
              DrawerTile(
                context: context,
                title: AppStrings.watching,
                showInfoIcon: true,
                onTap: () {
                  showWatching.value = !showWatching.value;
                },
                info: AppStrings.watchingInfo,
                isActive: value,
              ),

              if (value) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: const Watching(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
