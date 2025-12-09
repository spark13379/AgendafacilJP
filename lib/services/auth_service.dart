import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agendafaciljp/models/user.dart' as app_user;
import 'package:agendafaciljp/services/user_service.dart';
import 'package:agendafaciljp/services/doctor_service.dart'; // Importa o serviço de médicos

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  final DoctorService _doctorService = DoctorService(); // Instancia o serviço de médicos

  Future<app_user.User?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      // Tenta buscar primeiro na coleção de usuários (clientes/admins)
      app_user.User? user = await _userService.getUserById(firebaseUser.uid);

      // Se não encontrar, tenta buscar na coleção de médicos
      if (user == null) {
        user = await _doctorService.getDoctorById(firebaseUser.uid);
      }

      return user;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      debugPrint('Error during login: $e');
      return false;
    }
  }

  Future<bool> register(app_user.User user, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: password);
      final firebaseUser = credential.user;
      if (firebaseUser == null) return false;

      final newUser = user.copyWith(id: firebaseUser.uid);
      await _userService.addUser(newUser);

      return true;
    } catch (e) {
      debugPrint('Error during registration: $e');
      return false;
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
