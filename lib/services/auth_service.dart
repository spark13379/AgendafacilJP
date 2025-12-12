import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:agendafaciljp/models/user.dart' as app_user;
import 'package:agendafaciljp/services/user_service.dart';
import 'package:agendafaciljp/services/doctor_service.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final UserService _userService = UserService();
  final DoctorService _doctorService = DoctorService();

  // Modificado para buscar dados de forma mais genérica
  Future<app_user.User?> getUserData(String uid) async {
    try {
      app_user.User? user = await _userService.getUserById(uid);
      user ??= await _doctorService.getDoctorById(uid);
      return user;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  Future<app_user.User?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return await getUserData(firebaseUser.uid);
  }

  // Modificado para retornar UserCredential
  Future<firebase_auth.UserCredential?> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return credential;
    } catch (e) {
      debugPrint('Error during login: $e');
      return null;
    }
  }

  // Modificado para retornar UserCredential
  Future<firebase_auth.UserCredential?> register(app_user.User user, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: password);
      final firebaseUser = credential.user;
      if (firebaseUser == null) return null;

      // Associa o ID do Firebase ao nosso modelo de usuário e salva no Firestore
      final newUser = user.copyWith(id: firebaseUser.uid);
      await _userService.addUser(newUser);

      return credential;
    } catch (e) {
      debugPrint('Error during registration: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    final user = _firebaseAuth.currentUser;
    return user != null;
  }
}
