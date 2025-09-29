import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/screens/home/widgets/user_tile.dart';
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

      if (showLoading) {
        await ref.read(watchingViewModel.notifier).fetch();
      }
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
              ...List.generate(
                (watching.data ?? []).length,
                (index) {
                  final user = watching.data![index];

                  return UserTile(
                    profilePicture: user.data!.profilePicture,
                    userName: user.data!.userName ?? '',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
