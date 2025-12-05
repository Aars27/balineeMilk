// lib/Providers/LoginProvider.dart

import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  String _username = '';
  bool _isLoading = false;

  // Getters
  String get username => _username;
  bool get isLoading => _isLoading;

  // Setters/Actions
  void setUsername(String value) {
    _username = value;
    // Don't call notifyListeners here unless you need real-time validation feedback.
  }

  Future<void> attemptLogin() async {
    _isLoading = true;
    notifyListeners(); // Notify listeners to show a loading indicator on the screen.

    // --- Simulated Business Logic ---
    await Future.delayed(const Duration(seconds: 2));

    // context.go('login');


    // Logic to check credentials, make API call, etc.
    // For example: if (_username.isNotEmpty) { ... }

    _isLoading = false;
    notifyListeners(); // Notify listeners to hide the loading indicator.
  }
}