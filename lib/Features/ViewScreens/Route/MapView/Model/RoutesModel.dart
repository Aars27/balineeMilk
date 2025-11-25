// lib/Models/route_model.dart

class RouteDetails {
  final double totalDistanceKm;
  final int estimatedTimeMin;
  final int totalStops;
  final int completedStops;

  RouteDetails({
    required this.totalDistanceKm,
    required this.estimatedTimeMin,
    required this.totalStops,
    required this.completedStops,
  });

  double get progressPercent => (completedStops / totalStops) * 100;
}

class Delivery {
  final String customerName;
  final String time;
  final bool isCompleted;

  Delivery({
    required this.customerName,
    required this.time,
    required this.isCompleted,
  });
}