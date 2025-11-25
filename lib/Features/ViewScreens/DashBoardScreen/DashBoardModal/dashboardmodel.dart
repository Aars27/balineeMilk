// lib/Models/dashboard_model.dart

import 'dart:ui';

class MilkData {
  final int token;
  final int delivered;
  final int returned;

  MilkData({required this.token, required this.delivered, required this.returned});
}

class SalesData {
  final String title;
  final String amount;
  final double progress;
  final Color progressColor;

  SalesData({
    required this.title,
    required this.amount,
    required this.progress,
    required this.progressColor,
  });
}

class DeliverySummary {
  final int totalConsumers;
  final int delivered;
  final int pending;
  final double progressPercent;

  DeliverySummary({
    required this.totalConsumers,
    required this.delivered,
    required this.pending,
  }) : progressPercent = (delivered / totalConsumers) * 100;
}