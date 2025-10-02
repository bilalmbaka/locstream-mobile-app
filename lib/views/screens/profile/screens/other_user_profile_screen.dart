import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/core/utils/base_state.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/data/model/user_model.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/screens/profile/widgets/other_user_location_map.dart';
import 'package:locstream/views/widgets/app_bars/general_app_bar.dart';
import 'package:locstream/views/widgets/app_text_field.dart';
import 'package:locstream/views/widgets/buttons/plain_button.dart';
import 'package:locstream/views/widgets/profile_picture.dart';

class OtherUserProfileScreen extends ConsumerStatefulWidget {
  static const routeName = 'other-user-profile';
  static const path = routeName;

  const OtherUserProfileScreen({super.key});

  @override
  ConsumerState<OtherUserProfileScreen> createState() =>
      _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState
    extends ConsumerState<OtherUserProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final otherUserProfile = ref.read(otherUserProfileViewModel).data;

      if (otherUserProfile == null) return;
    });
  }

  @override
  Widget build(BuildContext context) {
    final otherUserProfile = ref.watch(otherUserProfileViewModel);
    final profile = otherUserProfile.data;

    ref.listen(watchingViewModel, (previous, next) {
      if (next.isSuccess) {
        final watching = next.data ?? <BaseState<User>>[];
        final user = watching.firstWhere(
          (element) => element.data!.id == profile!.id,
        );
        ref.read(otherUserProfileViewModel.notifier).profile = user.data!;
      }
    });

    return Scaffold(
      appBar: AppAppBar(title: AppStrings.userProfile),
      body: Padding(
        padding: AppHelpers.defaultPadding(bottom: 0),
        child: profile == null
            ? Offstage()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          ProfilePicture(
                            initials: profile.initials,
                            initialsFontSize: 50,
                            profilePicture: profile.profilePicture?.url,
                            width: 100,
                            height: 100,
                          ),
                          AppConstants.smallYSpace,
                          AppTextField(
                            text: profile.userName ?? '_',
                            textStyle: AppTextStyle(
                              context: context,
                              fontSize: 15,
                            ).fw900(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    AppConstants.largeYSpace,

                    _info(
                      title: AppStrings.currentLocation,
                      info:
                          "${profile.currentLocation?.lat ?? ""},${profile.currentLocation?.lng ?? ""}",
                      trailing: profile.currentLocation != null
                          ? GestureDetector(
                              onTap: () async {
                                await AppHelpers.copyToClipboard(
                                  context: context,
                                  text:
                                      "${profile.currentLocation?.lat ?? ""},${profile.currentLocation?.lng ?? ""}",
                                );
                              },
                              child: Icon(Icons.copy_all_outlined, size: 18),
                            )
                          : null,
                    ),
                    AppConstants.mediumYSpace,
                    _info(
                      title: AppStrings.currentAddress,
                      info: profile.currentAddress ?? '',
                      trailing: profile.currentAddress != null
                          ? GestureDetector(
                              onTap: () async {
                                await AppHelpers.copyToClipboard(
                                  context: context,
                                  text: profile.currentAddress ?? '',
                                );
                              },
                              child: Icon(Icons.copy_all_outlined, size: 18),
                            )
                          : null,
                    ),
                    AppConstants.mediumYSpace,
                    _info(
                      title: AppStrings.lastSeen,
                      info: profile.lastSeen == null
                          ? ''
                          : DateFormat(
                              'dd-MMM-y @ hh:mm a',
                            ).format(profile.lastSeen!),
                    ),
                    AppConstants.largeYSpace,

                    if (profile.currentLocation != null)
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.white,
                        ),
                        child: OtherUserLocationMap(
                          location: profile.currentLocation!,
                        ),
                      ),

                    AppConstants.extraLargeYSpace,

                    PlainButton(
                      onTap: () {
                        AppHelpers.showToast(context, AppStrings.comingSoon);
                      },
                      text: AppStrings.journeyToUser,
                    ),

                    AppConstants.largeYSpace,
                  ],
                ),
              ),
      ),
    );
  }

  Widget _info({
    required String title,
    required String info,
    Widget? trailing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: AppTextField(
            text: title,
            textStyle: AppTextStyle(context: context, fontSize: 14).fw500(),
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.inputBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(child: AppTextField(text: info)),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ],
    );
  }
}
