import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/services/navigation_service.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/core/utils/helpers/dialog_helpers.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/screens/home/widgets/user_tile.dart';
import 'package:locstream/views/widgets/app_text_field.dart';
import 'package:locstream/views/widgets/buttons/outlined_button.dart';
import 'package:locstream/views/widgets/buttons/plain_button.dart';
import 'package:locstream/views/widgets/dialogs/info_dialog.dart';
import 'package:locstream/views/widgets/loading_indicator.dart';
import 'package:locstream/views/widgets/shimmers/container_shimmer.dart';
import 'package:locstream/views/widgets/status_wrapper.dart';

import '../../../../core/styling/colors.dart';

///List of people who know where i am.
class Watchers extends ConsumerStatefulWidget {
  const Watchers({super.key});

  @override
  ConsumerState<Watchers> createState() => _WatchersState();
}

class _WatchersState extends ConsumerState<Watchers> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final showLoading =
          ref.read(watchersViewModel).isSuccess == false ||
          (ref.read(watchersViewModel).data ?? []).isEmpty;

      await ref
          .read(watchersViewModel.notifier)
          .fetch(showLoading: showLoading);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final watchers = ref.watch(watchersViewModel);

        return StatusWrapper(
          status: watchers.status,
          padding: EdgeInsets.zero,
          loadingChild: ContainerShimmer(height: 20, width: double.infinity),
          retryFunction: () async {
            await ref.read(watchersViewModel.notifier).fetch();
          },
          message: watchers.errorMessage,
          child: Column(
            spacing: 10,
            children: [
              ...List.generate((watchers.data ?? []).length, (index) {
                final watcher = watchers.data![index];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UserTile(
                      profilePicture: watcher.data!.profilePicture,
                      userName: watcher.data!.userName ?? '',
                    ),

                    if (watcher.isLoading)
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: AppLoadingIndicator(
                          width: 15,
                          height: 15,
                          strokeWidth: .7,
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: GestureDetector(
                          onTap: () async {
                            final remove = await DialogHelpers.showAppDialog<bool?>(
                              context: context,

                              child: InfoDialog(
                                coverImage: Icon(Icons.info, size: 90),
                                title: AppStrings.removeWatcher,
                                information:
                                    '${watcher.data!.userName} ${AppStrings.willStopSeeingYourLocation}',
                                actionButton: Row(
                                  spacing: 20,
                                  children: [
                                    Flexible(
                                      child: AppOutlinedButton(
                                        onTap: () {
                                          NavigationService.pop(
                                            context: context,
                                            data: false,
                                          );
                                        },
                                        text: AppStrings.back,
                                      ),
                                    ),
                                    Flexible(
                                      child: PlainButton(
                                        onTap: () {
                                          NavigationService.pop(
                                            context: context,
                                            data: true,
                                          );
                                        },
                                        text: AppStrings.remove,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                            if (remove == true) {
                              await ref
                                  .read(watchersViewModel.notifier)
                                  .removeWatcher(
                                    context: context,
                                    userId: watcher.data!.id,
                                  );
                            }
                          },
                          child: AppTextField(
                            text: AppStrings.remove,
                            textStyle: AppTextStyle(
                              context: context,
                              fontSize: 11,
                              color: AppColors.redMain,
                            ).fw400(),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
