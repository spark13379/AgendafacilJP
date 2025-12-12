import 'package:flutter/foundation.dart';
import 'package:agendafaciljp/models/user.dart';
import 'package:agendafaciljp/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    _currentUser = await _authService.getCurrentUser();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final userCredential = await _authService.login(email, password);

    if (userCredential != null) {
      _currentUser = await _authService.getUserData(userCredential.user!.uid);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(User user, String password) async {
    _isLoading = true;
    notifyListeners();

    final userCredential = await _authService.register(user, password);

    if (userCredential != null) {
      // O usuário já foi salvo no Firestore pelo register, agora só atualizamos o estado local
      _currentUser = await _authService.getUserData(userCredential.user!.uid);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}
