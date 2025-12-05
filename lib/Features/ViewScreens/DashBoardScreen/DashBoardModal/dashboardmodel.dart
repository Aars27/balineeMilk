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
    try {
      return DashboardModel(
        flag: json["flag"] ?? false,
        date: json["date"]?.toString() ?? "",
        deliveryPartner: json["delivery_partner"]?.toString() ?? "",
        shift: json["shift"]?.toString() ?? "",
        milk: MilkData.fromJson(json),
        sales: SalesMetrics.fromJson(json["sales"] ?? {}),
        cash: CashData.fromJson(json["cash"] ?? {}),
        online: CashData.fromJson(json["online"] ?? {}),
        pending: CashData.fromJson(json["pending"] ?? {}),
        deliveryProgress: DeliveryProgress.fromJson(json["delivery_progress"] ?? {}),
      );
    } catch (e) {
      print("❌ DashboardModel parsing error: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "flag": flag,
      "date": date,
      "delivery_partner": deliveryPartner,
      "shift": shift,
      "milk_taken": milk.taken,
      "milk_delivered": milk.delivered,
      "milk_returned": milk.returned,
      "sales": sales.toJson(),
      "cash": cash.toJson(),
      "online": online.toJson(),
      "pending": pending.toJson(),
      "delivery_progress": deliveryProgress.toJson(),
    };
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
    try {
      return MilkData(
        taken: _parseToInt(json["milk_taken"]),
        delivered: _parseToInt(json["milk_delivered"]),
        returned: _parseToInt(json["milk_returned"]),
      );
    } catch (e) {
      print("❌ MilkData parsing error: $e");
      print("   Raw data: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "milk_taken": taken,
      "milk_delivered": delivered,
      "milk_returned": returned,
    };
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
    try {
      return SalesMetrics(
        total: _parseToInt(json["total"]),
        deliveredSale: _parseToInt(json["delivered_sale"]),
        deliveredPercent: _parseToInt(json["delivered_percent"]),
      );
    } catch (e) {
      print("❌ SalesMetrics parsing error: $e");
      print("   Raw data: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "total": total,
      "delivered_sale": deliveredSale,
      "delivered_percent": deliveredPercent,
    };
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
    try {
      return CashData(
        amount: _parseToInt(json["amount"]),
        percentage: _parseToInt(json["percentage"]),
      );
    } catch (e) {
      print("❌ CashData parsing error: $e");
      print("   Raw data: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "percentage": percentage,
    };
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
    try {
      return DeliveryProgress(
        totalConsumers: _parseToInt(json["total_consumers"]),
        delivered: _parseToInt(json["delivered"]),
        pending: _parseToInt(json["pending"]),
        progressPercent: _parseToDouble(json["progress_percent"]),
      );
    } catch (e) {
      print("❌ DeliveryProgress parsing error: $e");
      print("   Raw data: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "total_consumers": totalConsumers,
      "delivered": delivered,
      "pending": pending,
      "progress_percent": progressPercent,
    };
  }
}

// ========== HELPER FUNCTIONS ==========

/// Safely parse dynamic value to int
/// Handles: int, double, String, null
int _parseToInt(dynamic value) {
  if (value == null) return 0;

  // Already an int
  if (value is int) return value;

  // Convert double to int
  if (value is double) {
    return value.toInt();
  }

  // Parse string to int
  if (value is String) {
    // Remove any whitespace
    final trimmed = value.trim();

    // Try parsing as int
    final parsed = int.tryParse(trimmed);
    if (parsed != null) return parsed;

    // Try parsing as double first, then convert to int
    final parsedDouble = double.tryParse(trimmed);
    if (parsedDouble != null) return parsedDouble.toInt();
  }

  print("⚠️ Could not parse to int: $value (${value.runtimeType})");
  return 0;
}

/// Safely parse dynamic value to double
/// Handles: double, int, String, null
double _parseToDouble(dynamic value) {
  if (value == null) return 0.0;

  // Already a double
  if (value is double) return value;

  // Convert int to double
  if (value is int) {
    return value.toDouble();
  }

  // Parse string to double
  if (value is String) {
    final trimmed = value.trim();
    final parsed = double.tryParse(trimmed);
    if (parsed != null) return parsed;
  }

  print("⚠️ Could not parse to double: $value (${value.runtimeType})");
  return 0.0;
}

// ========== EXTENSIONS FOR CONVENIENCE ==========

extension DashboardModelExtension on DashboardModel {
  /// Check if dashboard has valid data
  bool get hasValidData {
    return flag &&
        deliveryPartner.isNotEmpty &&
        date.isNotEmpty;
  }

  /// Get total milk quantity
  int get totalMilk => milk.taken;

  /// Get remaining milk
  int get remainingMilk => milk.taken - milk.delivered - milk.returned;

  /// Check if delivery is complete
  bool get isDeliveryComplete => deliveryProgress.pending == 0;
}

extension DeliveryProgressExtension on DeliveryProgress {
  /// Get progress as percentage string
  String get progressString => "${progressPercent.toStringAsFixed(0)}%";

  /// Check if more than 50% complete
  bool get isMoreThanHalfDone => progressPercent >= 50;

  /// Get completion ratio
  double get completionRatio => delivered / totalConsumers;
}