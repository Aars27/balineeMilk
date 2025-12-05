import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../Components/Savetoken/SaveToken.dart';
import '../Distribution/apiservice.dart';
import 'ConsumerModal.dart';
import 'Consumer_servicecontroller.dart'; // तुम जो भी नाम use कर रहे हो

class ConsumerProvider extends ChangeNotifier {
  final ConsumerService _service = ConsumerService();
  final DistributionService _distributionService = DistributionService(); // deliver-order के लिए

  List<ConsumerModel> consumers = [];
  bool loading = false;
  String? errorMessage;

  // ---------------- LOAD CONSUMERS ----------------
  Future<void> loadConsumers(String token) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      consumers = await _service.fetchConsumers(token);
    } catch (e) {
      errorMessage = "Failed to load consumers: $e";
      consumers = [];
    }

    loading = false;
    notifyListeners();
  }

  // ---------------- DELIVER ORDER (deliver-order API) ----------------
  Future<String> deliverOrder({
    required int orderId,
    required String deliveredQty,
    required String paymentMode,
  }) async {
    try {
      String? token = await TokenHelper().getToken();

      if (token == null || token.isEmpty) {
        return "Token not found. Please login again.";
      }

      // 2) Current location लेने की कोशिश
      String lat = "";
      String lng = "";

      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever) {
          final pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          lat = pos.latitude.toString();
          lng = pos.longitude.toString();
        } else {
          debugPrint("Location permission denied, sending empty lat/long");
        }
      } catch (e) {
        debugPrint("Location error (consumer deliver): $e");
      }

      // 3) API call (same as distribution)
      final msg = await _distributionService.submitOrder(
        token: token,
        orderId: orderId,
        qty: deliveredQty,
        paymentMode: paymentMode,
        latitude: lat,
        longitude: lng,
      );

      return msg;
    } catch (e) {
      return "Error delivering order: $e";
    }
  }
}
