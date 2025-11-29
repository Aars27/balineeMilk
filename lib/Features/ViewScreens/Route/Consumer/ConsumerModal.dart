class ConsumerModel {
  final int id;
  final String productName;
  final String unit;
  final String quantity;
  final String customerName;
  final String address;
  final String time;
  final String status;

  ConsumerModel({
    required this.id,
    required this.productName,
    required this.unit,
    required this.quantity,
    required this.customerName,
    required this.address,
    required this.time,
    required this.status,
  });

  String get initials {
    if (customerName.isEmpty) return "?";
    List<String> parts = customerName.trim().split(" ");
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : "?";
    }
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  factory ConsumerModel.fromJson(Map<String, dynamic> json) {
    return ConsumerModel(
      id: json["id"] ?? 0,
      productName: json["product_name"] ?? "N/A",
      unit: json["unit"] ?? "unit",
      quantity: (json["delivery_qty"] ?? "0").toString(),
      customerName: json["customer_name"] ?? "Unknown",
      address: json["address"] ?? "No address",
      time: json["time"] ?? "Not specified",
      status: json["delivered_status"] ?? "Pending",
    );
  }
}