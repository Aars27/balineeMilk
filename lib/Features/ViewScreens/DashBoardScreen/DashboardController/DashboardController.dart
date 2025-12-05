import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../Components/Savetoken/SaveToken.dart';
import '../DashBoardModal/dashboardmodel.dart';



class DashboardController with ChangeNotifier {
  bool isLoading = false;
  DashboardModel? dashboard;
  String? errorMessage;

  late Dio _dio;

  DashboardController() {
    _initializeDio();
    Future.delayed(Duration.zero, () {
      fetchDashboard();
    });
  }

  Future<void> _initializeDio() async {
    _dio = await TokenHelper().getDioClient();
  }

  Future<void> fetchDashboard() async {
    print("🚀 Fetching dashboard...");

    if (dashboard == null) {
      isLoading = true;
      notifyListeners();
    }

    try {
      // Ensure Dio is initialized with latest token
      _dio = await TokenHelper().getDioClient();

      final token = await TokenHelper().getToken();

      if (token == null || token.isEmpty) {
        errorMessage = "Token not found. Please login again.";
        isLoading = false;
        notifyListeners();
        return;
      }

      print("🔑 Token: ${token.substring(0, 20)}...");
      print("📡 Making API call...");

      final response = await _dio.get('/dashboard');

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response data: ${response.data}");

      if (response.statusCode == 200) {
        final jsonData = response.data;

        if (jsonData["flag"] == true) {
          dashboard = DashboardModel.fromJson(jsonData);
          errorMessage = null;
          print("✅ Dashboard loaded successfully");
        } else {
          errorMessage = jsonData["message"] ?? "Failed to load data";
          print("❌ API returned flag=false");
        }
      }
    } on DioException catch (e) {
      print("❌ Dio error: ${e.type}");
      print("❌ Message: ${e.message}");
      print("❌ Response: ${e.response?.data}");

      if (e.response?.statusCode == 401) {
        errorMessage = "Session expired. Please login again.";
        await TokenHelper().clearAuthData();
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout. Please try again.";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Request timeout. Please try again.";
      } else {
        errorMessage = "Network error: ${e.message}";
      }
    } catch (e) {
      print("❌ Dashboard error: $e");
      errorMessage = "Unexpected error occurred";
    }

    isLoading = false;
    notifyListeners();
    print("🔄 UI Updated - isLoading: $isLoading, hasData: ${dashboard != null}");
  }

  Future<void> refresh() async {
    dashboard = null;
    await fetchDashboard();
  }
}