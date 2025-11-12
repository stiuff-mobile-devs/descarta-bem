import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pharmacy {
  String id;
  String name;
  LatLng position;

  Pharmacy({
    required this.id,
    required this.name,
    required this.position
  });

  factory Pharmacy.fromMap(String id, Map<String, dynamic> data) {
    GeoPoint geoPoint = data['localizacao'];

    return Pharmacy(
      id: id,
      name: data["nome"],
      position: LatLng(geoPoint.latitude, geoPoint.longitude)
    );
  }
}