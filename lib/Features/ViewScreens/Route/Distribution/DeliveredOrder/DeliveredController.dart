import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modaldelivered.dart';

class MilkController extends ChangeNotifier {
  final DeliverOrderService _deliverService = DeliverOrderService();

  String deliveryQty = "";
  String paymentMode = "cash";

  void updateDeliveryQty(String v) => deliveryQty = v;
  void updatePaymentMode(String v) => paymentMode = v;

  // Get current location (dummy if permission not given)
  String latitude = "0.0";
  String longitude = "0.0";

  void updateLocation(String lat, String lng) {
    latitude = lat;
    longitude = lng;
    notifyListeners();
  }

  Future<String> submitDelivery({
    required BuildContext context,
    required int orderId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    if (token == null) return "Token missing";

    try {
      final msg = await _deliverService.submitOrder(
        token: token,
        orderId: orderId,
        qty: deliveryQty,
        paymentMode: paymentMode,
        latitude: latitude,
        longitude: longitude,
      );

      return msg;
    } catch (e) {
      return "Error: $e";
    }
  }
}
