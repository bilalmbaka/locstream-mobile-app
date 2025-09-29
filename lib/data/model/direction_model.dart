import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:latlong2/latlong.dart';

class DirectionsModel {
  final List<RouteModel> routes;
  final List<WaypointModel> waypoints;
  final String code;
  final String? uuid;

  DirectionsModel({
    required this.routes,
    required this.waypoints,
    required this.code,
    this.uuid,
  });

  factory DirectionsModel.fromJson(Map<String, dynamic> json) {
    return DirectionsModel(
      routes: (json['routes'] as List)
          .map((e) => RouteModel.fromJson(e))
          .toList(),
      waypoints: (json['waypoints'] as List)
          .map((e) => WaypointModel.fromJson(e))
          .toList(),
      code: json['code'],
      uuid: json['uuid'],
    );
  }
}

class RouteModel {
  final String weightName;
  final double weight;
  final double duration;
  final double distance;
  final List<LegModel> legs;
  final String geometry;
  final List<LatLng> polyline;

  RouteModel({
    required this.weightName,
    required this.weight,
    required this.duration,
    required this.distance,
    required this.legs,
    required this.geometry,
    this.polyline = const [],
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      weightName: json['weight_name'],
      weight: (json['weight'] as num).toDouble(),
      duration: (json['duration'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      legs: (json['legs'] as List).map((e) => LegModel.fromJson(e)).toList(),
      geometry: json['geometry'],
      polyline: decodePolyline(
        json['geometry'] as String,
      ).map((p) => LatLng(p[0].toDouble(), p[1].toDouble())).toList(),
    );
  }
}

class LegModel {
  final List<dynamic> viaWaypoints;
  final List<AdminModel> admins;
  final double weight;
  final double duration;
  final List<dynamic> steps;
  final double distance;
  final String summary;

  LegModel({
    required this.viaWaypoints,
    required this.admins,
    required this.weight,
    required this.duration,
    required this.steps,
    required this.distance,
    required this.summary,
  });

  factory LegModel.fromJson(Map<String, dynamic> json) {
    return LegModel(
      viaWaypoints: json['via_waypoints'] ?? [],
      admins: (json['admins'] as List? ?? [])
          .map((e) => AdminModel.fromJson(e))
          .toList(),
      weight: (json['weight'] as num).toDouble(),
      duration: (json['duration'] as num).toDouble(),
      steps: json['steps'] ?? [],
      distance: (json['distance'] as num).toDouble(),
      summary: json['summary'],
    );
  }
}

class AdminModel {
  final String iso31661Alpha3;
  final String iso31661;

  AdminModel({required this.iso31661Alpha3, required this.iso31661});

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      iso31661Alpha3: json['iso_3166_1_alpha3'],
      iso31661: json['iso_3166_1'],
    );
  }
}

class WaypointModel {
  final double distance;
  final String name;
  final List<double> location;

  WaypointModel({
    required this.distance,
    required this.name,
    required this.location,
  });

  factory WaypointModel.fromJson(Map<String, dynamic> json) {
    return WaypointModel(
      distance: (json['distance'] as num).toDouble(),
      name: json['name'],
      location: (json['location'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}

class StepModel {
  final List<IntersectionModel> intersections;
  final String drivingSide;
  final String geometry;
  final String mode;
  final ManeuverModel maneuver;
  final String? ref;
  final double weight;
  final double duration;
  final String name;
  final double distance;
  // Instructions and banners can be added as needed

  StepModel({
    required this.intersections,
    required this.drivingSide,
    required this.geometry,
    required this.mode,
    required this.maneuver,
    this.ref,
    required this.weight,
    required this.duration,
    required this.name,
    required this.distance,
  });

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      intersections: (json['intersections'] as List)
          .map((e) => IntersectionModel.fromJson(e))
          .toList(),
      drivingSide: json['driving_side'],
      geometry: json['geometry'],
      mode: json['mode'],
      maneuver: ManeuverModel.fromJson(json['maneuver']),
      ref: json['ref'],
      weight: (json['weight'] as num).toDouble(),
      duration: (json['duration'] as num).toDouble(),
      name: json['name'],
      distance: (json['distance'] as num).toDouble(),
    );
  }
}

class IntersectionModel {
  final int? out;
  final int? inIndex;
  final List<bool> entry;
  final List<int> bearings;
  final List<double> location;

  IntersectionModel({
    this.out,
    this.inIndex,
    required this.entry,
    required this.bearings,
    required this.location,
  });

  factory IntersectionModel.fromJson(Map<String, dynamic> json) {
    return IntersectionModel(
      out: json['out'],
      inIndex: json['in'],
      entry: (json['entry'] as List).map((e) => e as bool).toList(),
      bearings: (json['bearings'] as List).map((e) => e as int).toList(),
      location: (json['location'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}

class ManeuverModel {
  final int bearingAfter;
  final int bearingBefore;
  final List<double> location;
  final String modifier;
  final String type;
  final String instruction;

  ManeuverModel({
    required this.bearingAfter,
    required this.bearingBefore,
    required this.location,
    required this.modifier,
    required this.type,
    required this.instruction,
  });

  factory ManeuverModel.fromJson(Map<String, dynamic> json) {
    return ManeuverModel(
      bearingAfter: json['bearing_after'],
      bearingBefore: json['bearing_before'],
      location: (json['location'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      modifier: json['modifier'],
      type: json['type'],
      instruction: json['instruction'],
    );
  }
}