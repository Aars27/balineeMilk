import 'package:flutter/material.dart';

class SplashProvider with ChangeNotifier {
  double _progress = 0.0;
  String? _error;
  dynamic _apiResponse;

  double get progress => _progress;
  String? get error => _error;
  dynamic get apiResponse => _apiResponse;

  void updateProgress(double value) {
    _progress = value;
    notifyListeners();
  }

  void setApiResponse(dynamic data) {
    _apiResponse = data;
    notifyListeners();
  }

  void setError(String message) {
    _error = message;
    notifyListeners();
  }
}
