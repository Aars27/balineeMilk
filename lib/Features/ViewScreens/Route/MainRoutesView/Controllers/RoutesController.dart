// lib/Controllers/route_controller.dart

import 'package:flutter/material.dart';

import '../Model/RoutesModel.dart';
import '../Routes.dart';


class RouteController with ChangeNotifier {
  bool _isLoading = true;
  RouteDetails? _routeDetails;
  List<Delivery> _recentDeliveries = [];

  bool get isLoading => _isLoading;
  RouteDetails? get routeDetails => _routeDetails;
  List<Delivery> get recentDeliveries => _recentDeliveries;

  RouteController() {
    fetchRouteData();
  }

  Future<void> fetchRouteData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Hardcoded data to match the image
    _routeDetails = RouteDetails(
      totalDistanceKm: 12.5,
      estimatedTimeMin: 45,
      totalStops: 25,
      completedStops: 18,
    );

    _recentDeliveries = [
      Delivery(customerName: 'Rajesh Kumar', time: '06:30 AM', isCompleted: false),
      Delivery(customerName: 'Sunita Devi', time: '07:15 AM', isCompleted: true),
    ];

    _isLoading = false;
    notifyListeners();
  }
}