// lib/Models/report_model.dart

import 'package:flutter/material.dart';

class ReportSummary {
  final double totalSales;
  final String salesPeriod;
  final double cashFlow;
  final String cashFlowType;

  ReportSummary({
    required this.totalSales,
    required this.salesPeriod,
    required this.cashFlow,
    required this.cashFlowType,
  });
}

class PaymentDistributionData {
  final String category;
  final double percentage;
  final Color color;

  PaymentDistributionData({
    required this.category,
    required this.percentage,
    required this.color,
  });
}


class ShiftItem {
  final String title;
  final double amount;

  ShiftItem({
    required this.title,
    required this.amount,
  });
}

// Add this to ReportModal/ReportModel.dart or at top of ReportScreen.dart
class MilkDistributionData {
  final String category;
  final double liters;
  final Color color;

  MilkDistributionData({
    required this.category,
    required this.liters,
    required this.color,
  });
}


