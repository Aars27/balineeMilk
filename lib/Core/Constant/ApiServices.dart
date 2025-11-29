import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://balinee.pmmsapp.com/api/";

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  ApiService() {
    _initializeInterceptors();
  }
  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString("api_token");

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  // --------------------------
  // GET request
  // --------------------------
  Future<dynamic> getData(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response.data;
    } catch (e) {
      throw Exception("GET error: $e");
    }
  }

  // --------------------------
  // POST request
  // --------------------------
  Future<dynamic> postData(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      return response.data;
    } catch (e) {
      throw Exception("POST error: $e");
    }
  }

  // --------------------------
  // Login (special method)
  // --------------------------
  Future<dynamic> login(String mobile, String password) async {
    try {
      final response = await _dio.post(
        "login",
        data: {
          "mobile_no": mobile,
          "password": password,
        },
      );

      return response.data;
    } catch (e) {
      throw Exception("Login error: $e");
    }
  }
}
