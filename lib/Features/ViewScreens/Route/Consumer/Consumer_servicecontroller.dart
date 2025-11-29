import 'package:dio/dio.dart';
import 'ConsumerModal.dart';

class ConsumerService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<ConsumerModel>> fetchConsumers(String token) async {
    const url = "https://balinee.pmmsapp.com/api/consumer-deliveries";

    print("🔵 Starting API Call...");
    print("🔵 URL: $url");
    print("🔵 Token: ${token.substring(0, 20)}..."); // First 20 chars only

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          validateStatus: (status) {
            // Accept any status code to see the response
            return status! < 500;
          },
        ),
      );

      print("✅ STATUS CODE: ${response.statusCode}");
      print("✅ FULL RESPONSE: ${response.data}");
      print("✅ RESPONSE TYPE: ${response.data.runtimeType}");

      if (response.statusCode == 200) {
        if (response.data == null) {
          print("⚠️ Response data is null");
          return [];
        }

        // Check different possible response structures
        if (response.data is Map) {
          print("✅ Response is Map");

          if (response.data.containsKey("data")) {
            print("✅ 'data' key found");
            var dataField = response.data["data"];
            print("✅ Data field type: ${dataField.runtimeType}");
            print("✅ Data field value: $dataField");

            if (dataField is List) {
              print("✅ Data is List with ${dataField.length} items");
              List<ConsumerModel> consumers = dataField
                  .map((e) => ConsumerModel.fromJson(e))
                  .toList();
              print("✅ Parsed ${consumers.length} consumers");
              return consumers;
            } else {
              print("❌ 'data' is not a List, it's ${dataField.runtimeType}");
              return [];
            }
          } else {
            print("❌ No 'data' key found. Keys: ${response.data.keys}");
            return [];
          }
        } else if (response.data is List) {
          print("✅ Response is directly a List");
          List list = response.data;
          return list.map((e) => ConsumerModel.fromJson(e)).toList();
        } else {
          print("❌ Unexpected response type: ${response.data.runtimeType}");
          return [];
        }
      } else {
        print("❌ Status code not 200: ${response.statusCode}");
        print("❌ Response: ${response.data}");
        return [];
      }
    } on DioException catch (e) {
      print("❌ DIO EXCEPTION TYPE: ${e.type}");
      print("❌ DIO ERROR MESSAGE: ${e.message}");
      print("❌ DIO RESPONSE: ${e.response?.data}");
      print("❌ DIO STATUS CODE: ${e.response?.statusCode}");

      if (e.type == DioExceptionType.connectionTimeout) {
        print("❌ Connection Timeout!");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        print("❌ Receive Timeout!");
      } else if (e.type == DioExceptionType.badResponse) {
        print("❌ Bad Response!");
      }

      throw Exception("API Error: ${e.message}");
    } catch (e, stackTrace) {
      print("❌ GENERAL ERROR: $e");
      print("❌ STACK TRACE: $stackTrace");
      throw Exception("Unexpected Error: $e");
    }
  }
}