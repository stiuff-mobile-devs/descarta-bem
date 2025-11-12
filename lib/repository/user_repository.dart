import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../models/user_model.dart';

class UserRepository {
  static String collection = "users";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  create(User user) async {
    try {
      await _firestore.doc("$collection/${user.id}").set(user.toMap());
    } catch (e) {
      debugPrint("Error on create user: $e");
      throw Exception("Erro ao criar usuário.");
    }
  }
}