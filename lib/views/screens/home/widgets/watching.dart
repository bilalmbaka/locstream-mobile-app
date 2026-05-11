import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/services/navigation_service.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/screens/home/widgets/user_tile.dart';
import 'package:locstream/views/screens/profile/screens/other_user_profile_screen.dart';
import 'package:locstream/views/widgets/shimmers/container_shimmer.dart';
import 'package:locstream/views/widgets/status_wrapper.dart';

///List of people who i know where they are.
class Watching extends ConsumerStatefulWidget {
  const Watching({super.key});

  @override
  ConsumerState<Watching> createState() => _WatchingState();
}

class _WatchingState extends ConsumerState<Watching> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final showLoading =
          ref.read(watchingViewModel).isSuccess == false ||
          (ref.read(watchingViewModel).data ?? []).isEmpty;

      await ref
          .read(watchingViewModel.notifier)
          .fetch(showLoading: showLoading);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final watching = ref.watch(watchingViewModel);

        return StatusWrapper(
          status: watching.status,
          loadingChild: ContainerShimmer(height: 20, width: double.infinity),
          retryFunction: () async {
            await ref.read(watchingViewModel.notifier).fetch();
          },
          child: Column(
            spacing: 10,
            children: [
              if ((watching.data ?? []).isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'You are not watching anyone.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              else
                ...List.generate((watching.data ?? []).length, (index) {
                  final user = watching.data![index];

                  return GestureDetector(
                    onTap: () {
                      ref.read(otherUserProfileViewModel.notifier).profile =
                          user.data!;

                      NavigationService.pop(context: context);

                      NavigationService.pushToScreen(
                        context: context,
                        routeName: OtherUserProfileScreen.routeName,
                      );
                    },

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 10,
                      children: [
                        UserTile(
                          profilePicture: user.data!.profilePicture,
                          userName: user.data!.userName ?? '',
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
