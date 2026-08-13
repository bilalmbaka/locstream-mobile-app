import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:locstream/core/utils/base_state.dart';
import 'package:locstream/data/model/user_model.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/screens/home/screens/home.dart';
import 'package:locstream/views/screens/home/widgets/map.dart';
import 'package:locstream/views/screens/home/widgets/user_tile.dart';

class WatchersTile extends ConsumerWidget {
  const WatchersTile({super.key, required this.active});

  final bool active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watching = ref.watch(watchingViewModel);
    final users = watching.data ?? <BaseState<User>>[];

    if (users.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 2,
      ),
      width: 150,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        spacing: 20,
        children: [
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) {
                final user = users[index];

                if (user.data == null) {
                  return SizedBox.shrink();
                }

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        mapController.value.move(
                          LatLng(
                            user.data!.currentLocation!.lat,
                            user.data!.currentLocation!.lng,
                          ),
                          12,
                        );
                      },
                      child: UserTile(
                        profilePicture: user.data?.profilePicture,
                        userName: user.data?.userName ?? '',
                        nameAtBottom: true,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 30);
              },
              itemCount: users.length,
            ),
          ),

          GestureDetector(
            onTap: () {
              isTrayOpen.value = !isTrayOpen.value;
            },
            child: Icon(
              active ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios,
            ),
          ),
        ],
      ),
    );
  }
}
