import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../LoginModal/LoginModel.dart';
import '../../../../Core/Constant/ApiServices.dart';   // your Dio ApiService

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
// login function

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    _isLoading = true;
    notifyListeners();

    try {
      final api = ApiService();

      final response = await api.login(
        _model.username.trim(),
        _model.password.trim(),
      );

      final bool success = response["flag"] ?? false;

      if (success) {
        final token = response["data"]["api_token"];
        final firstName = response["data"]["first_name"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("api_token", token);
        await prefs.setString("user_name", firstName);

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
        Fluttertoast.showToast(
          msg: "Invalid username or password",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }

    } catch (e) {
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
