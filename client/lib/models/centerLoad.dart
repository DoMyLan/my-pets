import 'package:found_adoption_application/models/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CenterLoad {
  final String id;
  final String name;
  final String distance;

  const CenterLoad(
      {required this.id, required this.name, required this.distance});

  factory CenterLoad.fromJson(
      Map<String, dynamic> json, dynamic currentAddress) {
    String location = calculateDistance(
            Location(
                latitude: json["location"]["latitude"],
                longitude: json["location"]["longitude"]),
            currentAddress)
        .toString();
    return CenterLoad(
        id: json['_id'] as String,
        name: json['name'] as String,
        distance: location);
  }

  //tính toán khoảng cách
  static String calculateDistance(
    currentAddress,
    otherAddress,
  ) {
    LatLng currentP = LatLng(
      double.parse(currentAddress.latitude),
      double.parse(currentAddress.longitude),
    );

    LatLng pDestination = LatLng(
      double.parse(otherAddress.latitude),
      double.parse(otherAddress.longitude),
    );

    double distance = Geolocator.distanceBetween(
      currentP.latitude,
      currentP.longitude,
      pDestination.latitude,
      pDestination.longitude,
    );

    return (distance / 1000).toStringAsFixed(2);
  }
}
