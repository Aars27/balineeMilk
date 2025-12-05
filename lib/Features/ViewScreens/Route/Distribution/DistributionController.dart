import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Components/Savetoken/SaveToken.dart';
import 'apiservice.dart';
import 'DistributionModal.dart';

class MilkController extends ChangeNotifier {
  final DistributionService _service = DistributionService();

  bool loading = false;

  List<DistributionItem> distributionList = [];
  List<DistributionEntry> todayDistribution = [];

  // ========= INPUT STATES (new) =========
  String challanNo = "";
  String milkQty = "";
  String returnQty = "";

  String deliveryQty = "";
  String paymentMode = "cash";

  String latitude = "";
  String longitude = "";

  // ========= UPDATE METHODS (required) =========
  void updateChallanNo(String v) => challanNo = v;
  void updateMilkQty(String v) => milkQty = v;
  void updateReturnQty(String v) => returnQty = v;

  void updateDeliveryQty(String v) {
    deliveryQty = v;
    notifyListeners();
  }

  void updatePaymentMode(String mode) {
    paymentMode = mode;
    notifyListeners();
  }

  void updateLocation(String lat, String lng) {
    latitude = lat;
    longitude = lng;
    notifyListeners();
  }

  // ====================== LOAD DISTRIBUTION API ======================
  Future<void> loadDistribution() async {
    loading = true;
    notifyListeners();

    String? token = await TokenHelper().getToken();

    if (token == null) {
      loading = false;
      notifyListeners();
      return;
    }

    try {
      List<DistributionItem> list = await _service.fetchDistribution(token);
      distributionList = list;

      todayDistribution = list.map((e) {
        return DistributionEntry(
          orderId: e.id,
          initials: e.customerName.isNotEmpty
              ? e.customerName[0].toUpperCase()
              : "?",
          name: e.customerName,
          time: e.time,
          role: e.productName,
          quantityPerDay: "${e.deliveryQty}${e.unit}",
          isDelivered: e.status.toLowerCase() == "delivered",
        );
      }).toList();
      print("API LIST LENGTH = ${list.length}");
      for (var item in list) {
        print("Item: ${item.customerName} | Qty: ${item.deliveryQty}");
      }



    } catch (e) {
      print("Error loading distribution: $e");
    }

    loading = false;
    notifyListeners();
  }

  // ====================== SUBMIT INTAKE ======================
  Future<String> submitIntake(BuildContext context) async {

    if (challanNo.isEmpty || milkQty.isEmpty) {
      return "Please fill all fields";
    }

    String? token = await TokenHelper().getToken();

    if (token == null) return "Token missing";

    try {
      final msg = await _service.recordIntake(
        token: token,
        productId: 1,
        qty: milkQty,
        challan: challanNo,
      );
      return msg;
    } catch (e) {
      return "Error: $e";
    }
  }

  // ====================== SUBMIT RETURN ======================
  Future<String> submitReturn(BuildContext context) async {

    if (challanNo.isEmpty || milkQty.isEmpty) {
      return "Please fill all fields";
    }

    String? token = await TokenHelper().getToken();


    if (token == null) return "Token missing";

    try {
      final msg = await _service.recordReturn(
        token: token,
        productId: 1,
        qty: returnQty,
      );
      return msg;
    } catch (e) {
      return "Error: $e";
    }
  }

  // ====================== SUBMIT DELIVERY ======================
  Future<String> submitDelivery({
    required BuildContext context,
    required int orderId,
  }) async {
    String? token = await TokenHelper().getToken();


    if (token == null) return "Token missing";

    try {
      final msg = await _service.submitOrder(
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


  // ====================== GET CURRENT LOCATION ======================
  Future<void> fetchCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location Permission Permanently Denied!");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude.toString();
      longitude = position.longitude.toString();

      print("LOCATION UPDATED: $latitude , $longitude");

      notifyListeners();
    } catch (e) {
      print("Location Error: $e");
    }
  }




}
