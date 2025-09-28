class LocationModel {
  final double lat;
  final double lng;

  LocationModel.fromJson(Map<String, dynamic> json)
    : lat = json['lat'].runtimeType == int
          ? json['lat'].toDouble()
          : json['lat'],
      lng = json['lng'].runtimeType == int
          ? json['lng'].toDouble()
          : json['lng'];

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}
