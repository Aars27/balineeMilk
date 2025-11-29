class Delivery {
  final String initials;
  final String name;
  final String time;
  final String type; // Retailer/Consumer
  final String frequency; // 2L/Day
  final DeliveryStatus status;

  Delivery({
    required this.initials,
    required this.name,
    required this.time,
    required this.type,
    required this.frequency,
    required this.status,
  });
}

enum DeliveryStatus { delivered, pending }
