
import 'package:dio/dio.dart';

class DeliverOrderService {
  final Dio _dio = Dio();

  Future<String> submitOrder({
    required String token,
    required int orderId,
    required String qty,
    required String paymentMode,
    required String latitude,
    required String longitude,
  }) async {

    const url = "https://balinee.pmmsapp.com/api/deliver-order";

    final response = await _dio.post(
      url,
      data: {
        "order_id": orderId,
        "delivered_quantity": qty,
        "payment_mode": paymentMode,
        "latitude": latitude,
        "longitude": longitude,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    return response.data["message"] ?? "Success";
  }
}
