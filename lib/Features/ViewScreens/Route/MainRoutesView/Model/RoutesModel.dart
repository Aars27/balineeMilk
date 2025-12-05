// lib/models/map_view_model.dart
class MapViewResponse {
  final MapViewSummary summary;
  final List<MapStop> mapData;

  MapViewResponse({
    required this.summary,
    required this.mapData,
  });

  factory MapViewResponse.fromJson(Map<String, dynamic> json) {
    return MapViewResponse(
      summary: MapViewSummary.fromJson(json["summary"]),
      mapData: (json["map_data"] as List)
          .map((e) => MapStop.fromJson(e))
          .toList(),
    );
  }
}

class MapViewSummary {
  final int totalStops;
  final int completed;
  final int pending;
  final int percentage;

  MapViewSummary({
    required this.totalStops,
    required this.completed,
    required this.pending,
    required this.percentage,
  });

  factory MapViewSummary.fromJson(Map<String, dynamic> json) {
    return MapViewSummary(
      totalStops: json["total_stops"] ?? 0,
      completed: json["completed"] ?? 0,
      pending: json["pending"] ?? 0,
      percentage: json["percentage"] ?? 0,
    );
  }
}

class MapStop {
  final int id;
  final String customerName;
  final String address;
  final String latitude;
  final String longitude;
  final String status;

  MapStop({
    required this.id,
    required this.customerName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  factory MapStop.fromJson(Map<String, dynamic> json) {
    return MapStop(
      id: json["id"] ?? 0,
      customerName: json["customer_name"] ?? "",
      address: json["address"] ?? "",
      latitude: json["latitude"]?.toString() ?? "",
      longitude: json["longitude"]?.toString() ?? "",
      status: json["delivered_status"] ?? "Pending",
    );
  }
}
