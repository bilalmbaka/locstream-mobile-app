import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/core/constants/images.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/services/navigation_service.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/core/styling/text_style.dart';

import 'package:locstream/core/utils/base_state.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/data/model/user_model.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/screens/home/widgets/zoom_button.dart';
import 'package:locstream/views/screens/profile/other_user_profile_screen.dart';
import 'package:locstream/views/widgets/app_text_field.dart';
import 'package:locstream/views/widgets/loading_indicator.dart';
import 'package:locstream/views/widgets/media/image_view.dart';
import 'package:locstream/views/widgets/profile_picture.dart';

ValueNotifier<TileLayer> tile = ValueNotifier(
  TileLayer(
    urlTemplate: AppConstants.mapBoxStyleUrl,
    userAgentPackageName: AppConstants.packageName,
    tileProvider: CachedNetworkTileProvider(
      cacheManager: DefaultCacheManager(),
    ),
  ),
);

ValueNotifier<bool> isNoInternetSnackBarActive = ValueNotifier(false);

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();

  // bool _moveCameraToLocation = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(watchingViewModel.notifier).fetch();
      await ref.read(watchersViewModel.notifier).fetch();

      await ref.read(locationViewModel.notifier).getCurrentLocation().then((
        loc,
      ) {
        final currentLocation = ref.read(locationViewModel).data!;

        AppHelpers.moveCameraToLocation(
          _mapController,
          currentLocation.lat,
          currentLocation.lng,
        );
      });
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(watchingViewModel, (previous, next) {
      if (next.isError) {
        AppHelpers.showSnackBar(
          context: context,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextField(
                text: next.errorMessage ?? "Lost internet connection",
                textStyle: AppTextStyle(
                  context: context,
                  fontSize: 13,
                  color: AppColors.primaryColor,
                ).fw900(),
              ),

              AppLoadingIndicator(
                width: 15,
                height: 15,
                color: AppColors.primaryColor,
              ),
            ],
          ),
        );
      }

      if (next.isSuccess) {
        AppHelpers.removeSnackBar(context);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          _map(),
          Align(
            alignment: Alignment.bottomRight,
            child: MapZoomButton(mapController: _mapController),
          ),
          // Consumer(
          //   builder: (context, ref, child) {
          //     final watching = ref.watch(watchingViewModel);
          //
          //     if (watching.isError) {
          //       return Align(
          //         alignment: Alignment.bottomCenter,
          //         child: Container(
          //           color: AppColors.white,
          //           padding: EdgeInsets.only(
          //             left: 20,
          //             right: 20,
          //             bottom: 15,
          //             top: 5,
          //           ),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               AppTextField(
          //                 text:
          //                     watching.errorMessage ??
          //                     "Lost internet connection",
          //                 textStyle: AppTextStyle(
          //                   context: context,
          //                   fontSize: 13,
          //                   color: AppColors.primaryColor,
          //                 ).fw900(),
          //               ),
          //
          //               AppLoadingIndicator(
          //                 width: 15,
          //                 height: 15,
          //                 color: AppColors.primaryColor,
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     } else {
          //       return Offstage();
          //     }
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _map() {
    return Consumer(
      builder: (context, ref, child) {
        final watchingState = ref.watch(watchingViewModel);
        final watching = watchingState.data ?? <BaseState<User>>[];
        final location = ref.watch(locationViewModel).data;
        final directionsState = ref.watch(directionsViewModel);
        final polylines = List<List<LatLng>>.from(
          directionsState.data == null
              ? const []
              : directionsState.data!.routes.map((e) => e.polyline).toList(),
        );

        return Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(6.6018, 3.3515),
                initialZoom: 13.0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              children: [
                ValueListenableBuilder(
                  valueListenable: tile,
                  builder: (context, value, child) {
                    return value;
                  },
                ),
                MarkerLayer(
                  markers: [
                    if (location != null)
                      Marker(
                        point: LatLng(location.lat, location.lng),
                        width: 20,
                        height: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.ladingPageGradientBlue,
                          ),
                        ),
                      ),

                    ...watching.map((e) {
                      final user = e.data!;

                      if (user.currentLocation == null) Offstage();

                      return Marker(
                        width: 25,
                        height: 25,
                        point: LatLng(
                          user.currentLocation!.lat,
                          user.currentLocation!.lng,
                        ),
                        child: GestureDetector(
                          onTap: () => _onTapMarker(context, user),
                          child: ProfilePicture(
                            initials: user.userName?[0] ?? '',
                            profilePicture: user.profilePicture?.url,
                            initialsFontSize: 14,
                            defaultWidgetPadding: 0,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                PolylineLayer(
                  polylines: polylines.map((e) => Polyline(points: e)).toList(),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, bottom: 4.0),
                    child: SizedBox(
                      width: 70,
                      child: LogoSourceAttribution(
                        ImageView(image: Images.mapbox, boxFit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0, bottom: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: [
                        TextSourceAttribution(
                          AppStrings.mapBox,
                          textStyle: AppTextStyle(
                            context: context,
                            fontSize: 12,
                          ).fw900(),
                          onTap: () => {
                            AppHelpers.launchWebSite(
                              "https://www.mapbox.com/about/maps",
                            ),
                          },
                        ),
                        TextSourceAttribution(
                          "OpenStreetMap",
                          textStyle: AppTextStyle(
                            context: context,
                            fontSize: 12,
                          ).fw900(),
                          onTap: () => {
                            AppHelpers.launchWebSite(
                              "https://www.openstreetmap.org/",
                            ),
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (watchingState.isLoading || directionsState.isLoading)
              Align(
                alignment: Alignment.bottomCenter,
                child: LinearProgressIndicator(
                  color: AppColors.ladingPageGradientBlue,
                ),
              ),
          ],
        );
      },
    );
  }

  void _onTapMarker(BuildContext context, User e) {
    ref.read(otherUserProfileViewModel.notifier).profile = e;

    NavigationService.pushToScreen(
      context: context,
      routeName: OtherUserProfileScreen.routeName,
    );
  }
}

class CachedNetworkTileProvider extends NetworkTileProvider {
  final BaseCacheManager cacheManager;

  CachedNetworkTileProvider({required this.cacheManager}) : super();

  @override
  ImageProvider getImage(TileCoordinates coordinates, dynamic options) {
    final String tileUrl = getTileUrl(coordinates, options);
    return CachedNetworkImageProvider(
      tileUrl,
      cacheManager: cacheManager,
      headers: headers,
    );
  }
}
