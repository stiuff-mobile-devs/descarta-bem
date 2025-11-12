import 'package:descarte_bem/models/pharmacy_model.dart';
import 'package:descarte_bem/repository/pharmacy_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapController extends ChangeNotifier {
  PharmacyRepository repository = PharmacyRepository();

  LatLng? position;
  List<Pharmacy> pharmacies = [];

  MapController() {
  }

  init() async {
    await _getCurrentLocation();
    await _getPharmaciesList();
  }

   _getCurrentLocation() async {
     bool serviceEnabled;
     LocationPermission permission;
     serviceEnabled = await Geolocator.isLocationServiceEnabled();
     if (!serviceEnabled) {
       return Future.error('Location services are disabled.');
     }

     permission = await Geolocator.checkPermission();
     if (permission == LocationPermission.denied) {
       permission = await Geolocator.requestPermission();
       if (permission == LocationPermission.denied) {
         return Future.error('Location permissions are denied');
       }
     }
     if (permission == LocationPermission.deniedForever) {
       return Future.error(
           'Location permissions are permanently denied, we cannot request permissions.');
     }

     Position pos = await Geolocator.getCurrentPosition();
     double latitude = pos.latitude;
     double longitude = pos.longitude;
     position = LatLng(latitude, longitude);
     notifyListeners();
   }

   _getPharmaciesList() async {
     pharmacies = await repository.getAll();
     notifyListeners();
   }

  double getDistance(Pharmacy pharmacy) {
    return Geolocator.distanceBetween(
        position!.latitude,
        position!.longitude,
        pharmacy.position.latitude,
        pharmacy.position.longitude
    );
  }
}