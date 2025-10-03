import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locstream/core/error_handlers/exception_handler.dart';
import 'package:locstream/core/utils/base_state.dart';
import 'package:locstream/data/model/location_models.dart';
import 'package:locstream/domain/entities/profile_dto.dart';
import 'package:locstream/domain/use_case/profile_usecase.dart';

import '../../../core/services/location_service.dart';

typedef LocationState = BaseState<LocationModel>;

class LocationViewModel extends Notifier<LocationState> {
  LocationViewModel({
    required this.locationService,
    required this.profileUseCase,
  });

  final LocationService locationService;
  final ProfileUseCase profileUseCase;

  // LocationModel _previousLocation = LocationModel(lat: 0, lng: 0);

  @override
  LocationState build() {
    // locationService.locationStream().listen(
    //   (location) {
    //     final locationModel = LocationModel(
    //       lat: location.latitude,
    //       lng: location.longitude,
    //     );
    //
    //     state = LocationState.success(locationModel);
    //
    //     final distanceBetweenLocation = Geolocator.distanceBetween(
    //       _previousLocation.lat,
    //       _previousLocation.lng,
    //       locationModel.lat,
    //       locationModel.lng,
    //     );
    //
    //     print("distance: $distanceBetweenLocation");
    //
    //     //If use has moved at least 10 meters from previous location, update location
    //     if (distanceBetweenLocation >= 10) {
    //       profileUseCase.updateProfile(ProfileDto(location: locationModel));
    //     }
    //
    //     _previousLocation = locationModel;
    //   },
    //   onError: (error) {
    //     // if (error is GeoLocationException) {
    //     //
    //     // }
    //     //TODO check if location permission exception is throw.
    //     // final context = AppConstants.rootNavigatorKey.currentContext!;
    //     // NavigationService.pushToScreen(
    //     //   context: context,
    //     //   routeName: RequiredPermissionScreen.routeName,
    //     //   data: null
    //     // );
    //   },
    // );

    return LocationState.initial();
  }

  void setLocation({required double latitude, required double longitude}) {
    print("setting location in view model to lat $latitude and lng $longitude");

    state = LocationState.success(LocationModel(lat: latitude, lng: longitude));
  }

  Future<void> getCurrentLocation() async {
    try {
      state = LocationState.loading(data: state.data);

      final location = await locationService.currentLocation();

      state = LocationState.success(location);
    } catch (e) {
      final errorMessage = AppExceptionHandler.handleException(
        e,
        sendToLogger: true,
      );

      state = LocationState.error(errorMessage);
    }
  }
}
