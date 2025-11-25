// lib/Models/login_model.dart

class LoginModel {
  // Data properties
  String username = '';
  String password = '';
  bool rememberMe = false;

  // Simple business logic (e.g., local validation checks)
  bool validateUsername(String value) {
    return value.isNotEmpty;
  }

  bool validatePassword(String value) {
    return value.isNotEmpty && value.length >= 6;

  }
}

