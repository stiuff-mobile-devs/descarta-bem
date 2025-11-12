import '../models/user_model.dart';
import '../services/sign_in_service.dart';
import 'package:flutter/foundation.dart';

class UserController extends ChangeNotifier {
  final SignInService _signInService;

  User? currentUser;
  bool isSignedIn = false;
  bool loading = true;

  UserController(this._signInService) {
    _initialize();
  }

  _initialize() async {
    if (_signInService.isLoggedIn()) {
      _loadUserData();
      isSignedIn = true;
    }

    loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  login() async {
    loading = true;
    notifyListeners();
    if (await _signInService.signInWithGoogle()) {
      _loadUserData();
      isSignedIn = true;
    }
    loading = false;
    notifyListeners();
  }

  logout() async {
    await _signInService.signOut();
    currentUser = null;
    isSignedIn = false;
    notifyListeners();
  }

  _loadUserData() {
    final authUser = _signInService.getFirebaseAuthUser();
    final uid = authUser?.uid;
    final email = authUser?.email;
    final googleName = authUser?.displayName;
    if (uid == null) return;

    User user = User(id: uid, email: email!, name: googleName!);
    currentUser = user;
  }
}