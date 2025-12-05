import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

/// Centralized token and user data management
class TokenHelper {
  // Keys
  static const String _tokenKey = "user_token";
  static const String _userNameKey = "user_name";
  static const String _userIdKey = "user_id";
  static const String _fullNameKey = "full_name";  //  ADDED THIS

  // Singleton pattern
  static final TokenHelper _instance = TokenHelper._internal();
  factory TokenHelper() => _instance;
  TokenHelper._internal();

  // Cache for quick access
  String? _cachedToken;
  String? _cachedUserName;
  String? _cachedUserId;
  String? _cachedFullName;  //  ADDED THIS

  ///  UPDATED: Save authentication data after login
  Future<bool> saveAuthData({
    required String token,
    String? userName,
    String? userId,
    String? fullName,  // ✅ NEW PARAMETER
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_tokenKey, token);
      _cachedToken = token;

      if (userName != null) {
        await prefs.setString(_userNameKey, userName);
        _cachedUserName = userName;
      }

      if (userId != null) {
        await prefs.setString(_userIdKey, userId);
        _cachedUserId = userId;
      }

      // ✅ SAVE FULL NAME
      if (fullName != null) {
        await prefs.setString(_fullNameKey, fullName);
        _cachedFullName = fullName;
      }

      print("✅ TokenHelper: Auth data saved");
      print("   - Token: ${token.substring(0, 20)}...");
      print("   - Full Name: $fullName");
      print("   - User ID: $userId");

      return true;
    } catch (e) {
      print("❌ TokenHelper: Error saving auth data: $e");
      return false;
    }
  }

  /// Get token (with caching for performance)
  Future<String?> getToken() async {
    if (_cachedToken != null) {
      return _cachedToken;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedToken = prefs.getString(_tokenKey);
      return _cachedToken;
    } catch (e) {
      print("❌ TokenHelper: Error getting token: $e");
      return null;
    }
  }

  /// Get user name
  Future<String?> getUserName() async {
    if (_cachedUserName != null) {
      return _cachedUserName;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedUserName = prefs.getString(_userNameKey);
      return _cachedUserName;
    } catch (e) {
      print("❌ Error getting user name: $e");
      return null;
    }
  }

  /// ✅ Get full name (FIXED METHOD)
  Future<String?> getFullName() async {
    if (_cachedFullName != null) {
      print("✅ Returning cached full name: $_cachedFullName");
      return _cachedFullName;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedFullName = prefs.getString(_fullNameKey);
      print("✅ Retrieved full name from storage: $_cachedFullName");
      return _cachedFullName;
    } catch (e) {
      print("❌ Error getting full name: $e");
      return null;
    }
  }

  /// Get user ID
  Future<String?> getUserId() async {
    if (_cachedUserId != null) {
      return _cachedUserId;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedUserId = prefs.getString(_userIdKey);
      return _cachedUserId;
    } catch (e) {
      print("❌ TokenHelper: Error getting user ID: $e");
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Get authorization headers for API calls
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();

    return {
      "Authorization": "Bearer ${token ?? ''}",
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
  }

  /// Clear all auth data (logout)
  Future<void> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_tokenKey);
      await prefs.remove(_userNameKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_fullNameKey);  // ✅ CLEAR FULL NAME

      // Clear cache
      _cachedToken = null;
      _cachedUserName = null;
      _cachedUserId = null;
      _cachedFullName = null;  // ✅ CLEAR CACHED FULL NAME

      print("✅ TokenHelper: Auth data cleared");
    } catch (e) {
      print("❌ TokenHelper: Error clearing auth data: $e");
    }
  }

  /// Update token (e.g., after token refresh)
  Future<void> updateToken(String newToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, newToken);
      _cachedToken = newToken;
      print("✅ TokenHelper: Token updated");
    } catch (e) {
      print("❌ TokenHelper: Error updating token: $e");
    }
  }

  /// ✅ Debug: Print all stored data
  Future<void> debugPrintAuthData() async {
    final token = await getToken();
    final userName = await getUserName();
    final fullName = await getFullName();
    final userId = await getUserId();

    print("🔍 TokenHelper Debug:");
    print("  Token: ${token != null ? '${token.substring(0, 20)}...' : 'null'}");
    print("  User Name: $userName");
    print("  Full Name: $fullName");  // ✅ ADDED
    print("  User ID: $userId");
  }

  /// Create configured Dio instance with token
  Future<Dio> getDioClient() async {
    final token = await getToken();

    final dio = Dio(BaseOptions(
      baseUrl: "https://balinee.pmmsapp.com/api",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Authorization": "Bearer ${token ?? ''}",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    ));

    // Add interceptor for logging and error handling
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print("🌐 ${options.method} ${options.path}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("✅ ${response.statusCode} ${response.requestOptions.path}");
        return handler.next(response);
      },
      onError: (error, handler) {
        print("❌ Error: ${error.response?.statusCode} ${error.message}");

        // Handle 401 - token expired
        if (error.response?.statusCode == 401) {
          print("⚠️ Token expired - clearing auth data");
          clearAuthData();
        }

        return handler.next(error);
      },
    ));

    return dio;
  }
}