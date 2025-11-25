// lib/Controllers/report_controller.dart

import 'package:flutter/material.dart';
// Assuming AppColors is available
import '../../../../Core/Constant/app_colors.dart';
import '../ReportModal/ReportModel.dart';

class ReportController with ChangeNotifier {
  bool _isLoading = true;
  ReportSummary? _summary;
  List<PaymentDistributionData> _paymentDistribution = [];
  String _selectedTab = 'Sales'; // 'Sales', 'Milk', 'Shift'

  bool get isLoading => _isLoading;
  ReportSummary? get summary => _summary;
  List<PaymentDistributionData> get paymentDistribution => _paymentDistribution;
  String get selectedTab => _selectedTab;

  ReportController() {
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Hardcoded data to match the image
    _summary = ReportSummary(
      totalSales: 80.0,
      salesPeriod: 'This Week',
      cashFlow: 35300.0,
      cashFlowType: 'Net Profit',
    );

    _paymentDistribution = [
      PaymentDistributionData(category: 'Cash', percentage: 45, color: AppColors.primaryGreen),
      PaymentDistributionData(category: 'Online', percentage: 35, color: AppColors.primary),
      PaymentDistributionData(category: 'Credit', percentage: 15, color: AppColors.accentRed),
      PaymentDistributionData(category: 'Advance', percentage: 5, color: Colors.deepPurpleAccent),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void setSelectedTab(String tab) {
    _selectedTab = tab;
    // In a real app, you would refetch data based on the selected tab here
    fetchReportData(); // Re-fetch or update data based on tab
    notifyListeners();
  }
}