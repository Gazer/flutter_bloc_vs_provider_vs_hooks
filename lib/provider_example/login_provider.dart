import 'package:flutter/material.dart';
import 'package:loginwithwordpressapp/user_repository.dart';

class LoginProvider extends ChangeNotifier {
  final UserRepository userRepository;

  LoginProvider(this.userRepository) {
    _checkCurrentUser();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String lastError;

  void login(String email, String password) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      await userRepository.authenticate(email, password);
      _hasError = false;
      _isLoading = false;
      _isLoggedIn = true;
    } catch (e) {
      print(e);
      lastError = e.toString();
      _hasError = true;
      _isLoading = false;
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  void logout() async {
    await userRepository.clear();
    _hasError = false;
    _isLoading = false;
    _isLoggedIn = false;
    notifyListeners();
  }

  void _checkCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    await userRepository.checkCurrentUser();
    if (userRepository.currentUser != null) {
      _isLoggedIn = true;
    }
    _isLoading = false;
    notifyListeners();
  }
}
