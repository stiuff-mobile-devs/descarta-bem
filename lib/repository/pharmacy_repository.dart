import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:descarte_bem/models/pharmacy_model.dart';
import 'package:flutter/cupertino.dart';

class PharmacyRepository {
  static String collection = "farmacias";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Pharmacy>> getAll() async {
    List<Pharmacy> pharmacies = [];
    try {
      final docs = await _firestore.collection(collection).get();
      pharmacies = docs.docs.map((e) => Pharmacy.fromMap(e.id, e.data())).toList();
      return pharmacies;
    } catch (e) {
      debugPrint("Error on get all pharmacies: $e");
      return [];
    }
  }
}