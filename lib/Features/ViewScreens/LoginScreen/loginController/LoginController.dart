import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../Components/Providers/UserInfoProviders.dart';
import '../../../../Components/Savetoken/SaveToken.dart';
import '../LoginModal/LoginModel.dart';


class LoginController extends ChangeNotifier {
  // ✅ Form Key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ✅ Dio instance
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://balinee.pmmsapp.com/api",
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  // ✅ State Variables
  String _username = '';
  String _password = '';
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  // ✅ Getters
  String get username => _username;
  String get password => _password;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get rememberMe => _rememberMe;
  bool get isLoading => _isLoading;

  // ✅ Model for backward compatibility (if you have LoginModel)
  LoginModel get model => LoginModel(
    username: _username,
    password: _password,
    rememberMe: _rememberMe,
  );

  // ✅ Setters
  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  // ✅ Login Method
  Future<void> login(BuildContext context) async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.post('/login', data: {
        'mobile_no': _username,
        'password': _password,
      });

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Check if login was successful
        if (responseData['flag'] == true) {
          final data = responseData['data'];

          print("🔍 Login Response: $data");

          // ✅ Combine first_name and last_name
          String fullName = "${data['first_name']} ${data['last_name']}";

          // ✅ SAVE USER DATA
          await TokenHelper().saveAuthData(
            token: data['api_token'],
            userName: data['mobile_no'],
            userId: data['id'].toString(),
            fullName: fullName,
          );

          // ✅ Debug: Verify data was saved
          await TokenHelper().debugPrintAuthData();

          // ✅ Initialize Provider to load user info
          if (context.mounted) {
            final provider = Provider.of<UserInfoProvider>(context, listen: false);
            await provider.initialize();

            print("✅ Provider Full Name: ${provider.fullName}");
          }

          _isLoading = false;
          notifyListeners();

          // Show success message
          Fluttertoast.showToast(
            msg: responseData['message'] ?? 'Login successful',
            backgroundColor: Colors.green,
          );

          // Navigate to dashboard
          if (context.mounted) {
            context.go('/bottombar');
          }
        } else {
          _isLoading = false;
          notifyListeners();

          Fluttertoast.showToast(
            msg: responseData['message'] ?? 'Login failed',
            backgroundColor: Colors.red,
          );
        }
      } else {
        _isLoading = false;
        notifyListeners();

        Fluttertoast.showToast(
          msg: 'Login failed. Please try again.',
          backgroundColor: Colors.red,
        );
      }
    } on DioException catch (e) {
      _isLoading = false;
      notifyListeners();

      String errorMessage = 'Login failed';

      if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      print("❌ Login Error: $errorMessage");

      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      print("❌ Unexpected Error: $e");

      Fluttertoast.showToast(
        msg: 'An unexpected error occurred',
        backgroundColor: Colors.red,
      );
    }
  }

  // ✅ Clear form
  void clearForm() {
    _username = '';
    _password = '';
    _isPasswordVisible = false;
    if (!_rememberMe) {
      _rememberMe = false;
    }
    notifyListeners();
  }
}

