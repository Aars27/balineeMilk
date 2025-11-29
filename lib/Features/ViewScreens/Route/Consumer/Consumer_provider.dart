import 'package:flutter/material.dart';
import 'ConsumerModal.dart';
import 'Consumer_servicecontroller.dart';



class ConsumerProvider extends ChangeNotifier {
  final ConsumerService _service = ConsumerService();

  List<ConsumerModel> consumers = [];
  bool loading = false;
  String? errorMessage;  // ✅ Added this property


  Future<void> loadConsumers(String token) async {
    loading = true;
    notifyListeners();

    try {
      consumers = await _service.fetchConsumers(token);
    } catch (e) {
      print("ERROR: $e");
    }

    loading = false;
    notifyListeners();
  }
}
