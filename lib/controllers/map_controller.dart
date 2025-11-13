import 'package:descarte_bem/models/pharmacy_model.dart';
import 'package:descarte_bem/repository/pharmacy_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapController extends ChangeNotifier {
  PharmacyRepository repository = PharmacyRepository();

  LatLng? position;
  List<Pharmacy> pharmacies = [];
  bool loading = true;

  MapController() {
    _initialize();
  }

  _initialize() async {
    await _getCurrentLocation();
    await _getPharmaciesList();
    loading = false;
    notifyListeners();
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
         return;
       }
     }
     if (permission == LocationPermission.deniedForever) {
       return;
     }

     Position pos = await Geolocator.getCurrentPosition();
     position = LatLng(pos.latitude, pos.longitude);
   }

   _getPharmaciesList() async {
     pharmacies = await repository.getAll();
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