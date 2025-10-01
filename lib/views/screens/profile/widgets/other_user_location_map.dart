import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/data/model/location_models.dart';
import 'package:locstream/views/screens/home/widgets/map.dart';

class OtherUserLocationMap extends StatefulWidget {
  const OtherUserLocationMap({super.key, required this.location});

  final LocationModel location;

  @override
  State<OtherUserLocationMap> createState() => _OtherUserLocationMapState();
}

class _OtherUserLocationMapState extends State<OtherUserLocationMap> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(widget.location.lat, widget.location.lng),
            initialZoom: 16.0,
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
                Marker(
                  point: LatLng(widget.location.lat, widget.location.lng),
                  width: 20,
                  height: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.complimentary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
