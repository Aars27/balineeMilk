import 'package:dio/dio.dart';
import '../../../../Components/Savetoken/SaveToken.dart';
import 'DistributionModal.dart';

class DistributionService {

  // ================================
  // GET DISTRIBUTION
  // ================================
  Future<List<DistributionItem>> fetchDistribution(String token) async {
    final dio = await TokenHelper().getDioClient();  // <-- FIXED

    const String url = "/distribution";

    final response = await dio.get(url);

    print("📌 Distribution API: ${response.data}");

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data["data"] != null) {
      List list = response.data["data"];
      return list.map((e) => DistributionItem.fromJson(e)).toList();
    }

    return [];
  }

  // ================================
  // POST: INTAKE MILK
  // ================================
  Future<String> recordIntake({
    required String token,
    required int productId,
    required String qty,
    required String challan,
  }) async {
    final dio = await TokenHelper().getDioClient();

    const String url = "/milk-distribution";

    final response = await dio.post(url, data: {
      "type": "intake",
      "product_id": productId,
      "provided_qty": qty,
      "challan_no": challan,
    });

    return response.data["message"] ?? "Success";
  }

  // ================================
  // POST: RETURN MILK
  // ================================
  Future<String> recordReturn({
    required String token,
    required int productId,
    required String qty,
  }) async {
    final dio = await TokenHelper().getDioClient();

    const String url = "/milk-distribution";

    final response = await dio.post(url, data: {
      "type": "return",
      "product_id": productId,
      "return_qty": qty,
    });

    return response.data["message"] ?? "Success";
  }

  // ================================
  // POST: DELIVER ORDER
  // ================================
  Future<String> submitOrder({
    required String token,
    required int orderId,
    required String qty,
    required String paymentMode,
    required String latitude,
    required String longitude,
  }) async {
    final dio = await TokenHelper().getDioClient();

    const String url = "/deliver-order";

    final response = await dio.post(url, data: {
      "order_id": orderId,
      "delivered_quantity": qty,
      "payment_mode": paymentMode,
      "latitude": latitude,
      "longitude": longitude,
    });
    print(response);

    return response.data["message"] ?? "Success";


  }

}
