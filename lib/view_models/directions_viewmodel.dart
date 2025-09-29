import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/utils/base_state.dart';
import 'package:locstream/data/model/direction_model.dart';
import 'package:locstream/domain/use_case/maps_usecase.dart';

// State type for directions
typedef DirectionsState = BaseState<DirectionsModel>;

class DirectionsViewmodel extends Notifier<DirectionsState> {
  DirectionsViewmodel({required this.mapsUseCase});

  final MapsUseCase mapsUseCase;

  @override
  DirectionsState build() {
    return DirectionsState.initial();
  }

  Future<void> directions({
    required double originLng,
    required double originLat,
    required double destLng,
    required double destLat,
  }) async {
    try {
      state = DirectionsState.loading(data: state.data);

      final direction = await mapsUseCase.fetchDirections(
        originLng: originLng,
        originLat: originLat,
        destLng: destLng,
        destLat: destLat,
      );

      state = DirectionsState.success(direction);
    } catch (e) {
      state = DirectionsState.error(e.toString(), data: state.data);
    }
  }

}