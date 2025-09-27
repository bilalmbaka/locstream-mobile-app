class LocationModel {
  final double lat;
  final double lng;

  LocationModel.fromJson(Map<String, dynamic> json)
    : lat = json['lat'],
      lng = json['lng'];

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}
