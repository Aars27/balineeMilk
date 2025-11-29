import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../LoginModal/LoginModel.dart';
import '../../../../Core/Constant/ApiServices.dart';

class LoginController with ChangeNotifier {
  final LoginModel _model = LoginModel();
  final formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  LoginController(BuildContext context);

  LoginModel get model => _model;
  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;

  void setUsername(String value) => _model.username = value;
  void setPassword(String value) => _model.password = value;

  void toggleRememberMe(bool? value) {
    if (value != null) {
      _model.rememberMe = value;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // Login function - FIXED
  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    _isLoading = true;
    notifyListeners();

    try {
      print("🔵 LOGIN: Starting login...");
      final api = ApiService();

      final response = await api.login(
        _model.username.trim(),
        _model.password.trim(),
      );

      print("🔵 LOGIN: Response received: $response");

      final bool success = response["flag"] ?? false;

      if (success) {
        final token = response["data"]["api_token"];
        final firstName = response["data"]["first_name"];

        print("✅ LOGIN: Token received: ${token.substring(0, 20)}...");
        print("✅ LOGIN: User: $firstName");

        final prefs = await SharedPreferences.getInstance();

        // ✅ FIXED: Save with consistent key name
        await prefs.setString("user_token", token);  // Changed from "api_token"
        await prefs.setString("user_name", firstName);

        // Verify token was saved
        String? savedToken = prefs.getString("user_token");
        print("✅ LOGIN: Token saved verification: ${savedToken != null ? 'SUCCESS' : 'FAILED'}");

        Fluttertoast.showToast(
          msg: "Login successful",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        _isLoading = false;
        notifyListeners();

        if (context.mounted) {
          context.go('/bottombar');
        }

      } else {
        print("❌ LOGIN: Invalid credentials");
        Fluttertoast.showToast(
          msg: "Invalid username or password",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }

    } catch (e, stackTrace) {
      print("❌ LOGIN ERROR: $e");
      print("❌ STACK TRACE: $stackTrace");

      Fluttertoast.showToast(
        msg: "Login failed. Please try again.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    _isLoading = false;
    notifyListeners();
  }
}