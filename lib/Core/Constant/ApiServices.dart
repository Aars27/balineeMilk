import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Features/ViewScreens/Route/Distribution/DistributionModal.dart';

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


  Future<List<DistributionItem>> fetchDistribution(String token) async {
    const url = "https://balinee.pmmsapp.com/api/distribution";

    final response = await _dio.get(
      url,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    if (response.statusCode == 200) {
      List list = response.data["data"];
      return list.map((e) => DistributionItem.fromJson(e)).toList();
    }
    return [];
  }

  // POST: Intake milk
  Future<String> recordIntake({
    required String token,
    required int productId,
    required String qty,
    required String challan,
  }) async {
    const url = "https://balinee.pmmsapp.com/api/milk-distribution";

    final response = await _dio.post(
      url,
      data: {
        "type": "intake",
        "product_id": productId,
        "provided_qty": qty,
        "challan_no": challan,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data["message"] ?? "Success";
  }

  // POST: Return milk
  Future<String> recordReturn({
    required String token,
    required int productId,
    required String qty,
  }) async {
    const url = "https://balinee.pmmsapp.com/api/milk-distribution";

    final response = await _dio.post(
      url,
      data: {
        "type": "return",
        "product_id": productId,
        "return_qty": qty,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data["message"] ?? "Success";
  }





}



