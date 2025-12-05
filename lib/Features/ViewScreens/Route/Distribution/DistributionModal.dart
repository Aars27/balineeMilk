class DistributionItem {
  final int id;
  final String productName;
  final String unit;
  final String deliveryQty;
  final String customerName;
  final String address;
  final String status;
  final String time;

  DistributionItem({
    required this.id,
    required this.productName,
    required this.unit,
    required this.deliveryQty,
    required this.customerName,
    required this.address,
    required this.status,
    required this.time,
  });

  factory DistributionItem.fromJson(Map<String, dynamic> json) {
    return DistributionItem(
      id: json["id"] ?? 0,
      productName: json["product_name"] ?? "",
      unit: json["unit"] ?? "",
      deliveryQty: json["delivery_qty"].toString(),
      customerName: json["customer_name"] ?? "Unknown",
      address: json["address"] ?? "",
      status: json["delivered_status"] ?? "Pending",
      time: json["time"] ?? "",
    );
  }
}


class DistributionEntry {
  final int orderId;        // ADD THIS
  final String initials;
  final String name;
  final String time;
  final String role;
  final String quantityPerDay;
  final bool isDelivered;

  DistributionEntry({
    required this.orderId,   // ADD THIS
    required this.initials,
    required this.name,
    required this.time,
    required this.role,
    required this.quantityPerDay,
    this.isDelivered = false,
  });
}
