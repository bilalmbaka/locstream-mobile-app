import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/views/widgets/loading_indicator.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/styling/colors.dart';
import '../../../../view_models.dart';

class MapZoomButton extends ConsumerWidget {
  const MapZoomButton({super.key, required this.mapController});

  final MapController mapController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer(
            builder: (context, state, child) {
              final isLoading = ref.watch(locationViewModel).isLoading;

              return GestureDetector(
                onTap: () async {
                  if (isLoading) return;

                  await ref
                      .read(locationViewModel.notifier)
                      .getCurrentLocation()
                      .then((location) {
                        final currentLocation = ref
                            .read(locationViewModel)
                            .data!;

                        AppHelpers.moveCameraToLocation(
                          mapController,
                          currentLocation.lat,
                          currentLocation.lng,
                        );
                      });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8),
                  child: isLoading
                      ? AppLoadingIndicator(
                          width: 15,
                          height: 15,
                          strokeWidth: 1,
                          color: AppColors.primaryColor,
                        )
                      : Icon(
                          Icons.my_location,
                          size: 15,
                          color: AppColors.primaryColor,
                        ),
                ),
              );
            },
          ),
          AppConstants.smallYSpace,

          Container(
            decoration: BoxDecoration(color: AppColors.white),
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.only(right: 15, bottom: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => zoomInOut(zoomIn: true),
                  child: const Icon(Icons.add, color: AppColors.primaryColor),
                ),
                Divider(),
                GestureDetector(
                  onTap: () => zoomInOut(zoomIn: false),
                  child: const Icon(
                    Icons.remove,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void zoomInOut({required bool zoomIn}) {
    final zoom = zoomIn
        ? mapController.camera.zoom + 1
        : mapController.camera.zoom - 1;

    final position = mapController.camera.focusedZoomCenter(Offset.zero, zoom);

    AppHelpers.moveCameraToLocation(
      mapController,
      position.latitude,
      position.longitude,
      zoom: zoom,
    );
  }
}
