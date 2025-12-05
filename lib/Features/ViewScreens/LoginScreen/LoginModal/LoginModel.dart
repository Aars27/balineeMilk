// lib/Models/login_model.dart

class LoginModel {
  final String username;
  final String password;
  final bool rememberMe;


  LoginModel({
    required this.username,
    required this.password,
    required this.rememberMe,
  });


  // Simple business logic (e.g., local validation checks)
  bool validateUsername(String value) {
    return value.isNotEmpty;
  }

  bool validatePassword(String value) {
    return value.isNotEmpty && value.length >= 6;

  }
}





