// lib/Controllers/dashboard_controller.dart

import 'package:flutter/material.dart';

// Assuming AppColors is available
import '../../../../Core/Constant/app_colors.dart';
import '../DashBoardModal/dashboardmodel.dart';

class DashboardController with ChangeNotifier {
  bool _isLoading = true;
  MilkData? _milkData;
  List<SalesData> _metrics = [];
  DeliverySummary? _summary;

  bool get isLoading => _isLoading;
  MilkData? get milkData => _milkData;
  List<SalesData> get metrics => _metrics;
  DeliverySummary? get summary => _summary;

  DashboardController() {
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Hardcoded data to match the image exactly
    _milkData = MilkData(token: 500, delivered: 425, returned: 75);

    _metrics = [
      SalesData(title: 'Total Sales', amount: '₹12,750', progress: 0.8, progressColor: Colors.amber),
      SalesData(title: 'Cash in Hand', amount: '₹7,500', progress: 0.65, progressColor: Colors.orange),
      SalesData(title: 'Online Payment', amount: '₹1,000', progress: 0.2, progressColor: Colors.deepOrange),
      SalesData(title: 'Pending Payments', amount: '₹4,250', progress: 0.7, progressColor: Colors.red),
    ];

    _summary = DeliverySummary(totalConsumers: 95, delivered: 85, pending: 10);

    _isLoading = false;
    notifyListeners();
  }
}