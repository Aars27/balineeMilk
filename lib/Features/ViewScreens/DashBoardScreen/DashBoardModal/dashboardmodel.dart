// // lib/Models/dashboard_model.dart
//
// import 'dart:ui';
//
// class MilkData {
//   final int token;
//   final int delivered;
//   final int returned;
//
//   MilkData({required this.token, required this.delivered, required this.returned});
// }
//
// class SalesData {
//   final String title;
//   final String amount;
//   final double progress;
//   final Color progressColor;
//
//   SalesData({
//     required this.title,
//     required this.amount,
//     required this.progress,
//     required this.progressColor,
//   });
// }
//
// class DeliverySummary {
//   final int totalConsumers;
//   final int delivered;
//   final int pending;
//   final double progressPercent;
//
//   DeliverySummary({
//     required this.totalConsumers,
//     required this.delivered,
//     required this.pending,
//   }) : progressPercent = (delivered / totalConsumers) * 100;
// }
//
//
//
//
//
//













class DashboardModel {
  bool flag;
  String date;
  String deliveryPartner;
  String shift;

  MilkData milk;
  SalesMetrics sales;
  CashData cash;
  CashData online;
  CashData pending;
  DeliveryProgress deliveryProgress;

  DashboardModel({
    required this.flag,
    required this.date,
    required this.deliveryPartner,
    required this.shift,
    required this.milk,
    required this.sales,
    required this.cash,
    required this.online,
    required this.pending,
    required this.deliveryProgress,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      flag: json["flag"] ?? false,
      date: json["date"] ?? "",
      deliveryPartner: json["delivery_partner"] ?? "",
      shift: json["shift"] ?? "",
      milk: MilkData.fromJson(json),
      sales: SalesMetrics.fromJson(json["sales"]),
      cash: CashData.fromJson(json["cash"]),
      online: CashData.fromJson(json["online"]),
      pending: CashData.fromJson(json["pending"]),
      deliveryProgress: DeliveryProgress.fromJson(json["delivery_progress"]),
    );
  }
}

// ---------- MILK SECTION ----------
class MilkData {
  int taken;
  int delivered;
  int returned;

  MilkData({
    required this.taken,
    required this.delivered,
    required this.returned,
  });

  factory MilkData.fromJson(Map<String, dynamic> json) {
    return MilkData(
      taken: json["milk_taken"] ?? 0,
      delivered: json["milk_delivered"] ?? 0,
      returned: json["milk_returned"] ?? 0,
    );
  }
}

// ---------- SALES ----------
class SalesMetrics {
  int total;
  int deliveredSale;
  int deliveredPercent;

  SalesMetrics({
    required this.total,
    required this.deliveredSale,
    required this.deliveredPercent,
  });

  factory SalesMetrics.fromJson(Map<String, dynamic> json) {
    return SalesMetrics(
      total: json["total"] ?? 0,
      deliveredSale: json["delivered_sale"] ?? 0,
      deliveredPercent: json["delivered_percent"] ?? 0,
    );
  }
}

// ---------- CASH / ONLINE / PENDING ----------
class CashData {
  int amount;
  int percentage;

  CashData({
    required this.amount,
    required this.percentage,
  });

  factory CashData.fromJson(Map<String, dynamic> json) {
    return CashData(
      amount: json["amount"] ?? 0,
      percentage: json["percentage"] ?? 0,
    );
  }
}

// ---------- DELIVERY PROGRESS ----------
class DeliveryProgress {
  int totalConsumers;
  int delivered;
  int pending;
  double progressPercent;

  DeliveryProgress({
    required this.totalConsumers,
    required this.delivered,
    required this.pending,
    required this.progressPercent,
  });

  factory DeliveryProgress.fromJson(Map<String, dynamic> json) {
    return DeliveryProgress(
      totalConsumers: json["total_consumers"] ?? 0,
      delivered: json["delivered"] ?? 0,
      pending: json["pending"] ?? 0,
      progressPercent: (json["progress_percent"] ?? 0).toDouble(),
    );
  }
}
