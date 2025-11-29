// import 'package:flutter/material.dart';
//
// import '../MainRoutesView/Model/RoutesModel.dart';
//
// class AppController with ChangeNotifier {
//   CurrentView _currentView = CurrentView.consumers;
//   List<Delivery> _deliveries = [];
//
//   CurrentView get currentView => _currentView;
//   List<Delivery> get deliveries => _deliveries;
//
//   AppController() {
//     _fetchDeliveries();
//   }
//
//   void setCurrentView(CurrentView newView) {
//     _currentView = newView;
//     notifyListeners();
//   }
//
//   void _fetchDeliveries() {
//     // स्क्रीनशॉट के अनुसार डमी डेटा
//     _deliveries = [
//       Delivery(initials: 'RK', name: 'Rajesh Kumar', time: '06:30 AM', type: 'Retailer', frequency: '2L/Day', status: DeliveryStatus.delivered),
//       Delivery(initials: 'SS', name: 'Shantanu Singh', time: '06:30 AM', type: 'Retailer', frequency: '2L/Day', status: DeliveryStatus.pending),
//       Delivery(initials: 'RK', name: 'Rajesh Kumar', time: '06:30 AM', type: 'Retailer', frequency: '2L/Day', status: DeliveryStatus.delivered),
//       Delivery(initials: 'SS', name: 'Shantanu Singh', time: '06:30 AM', type: 'Retailer', frequency: '2L/Day', status: DeliveryStatus.pending),
//       Delivery(initials: 'RK', name: 'Rajesh Kumar', time: '06:30 AM', type: 'Retailer', frequency: '2L/Day', status: DeliveryStatus.delivered),
//       Delivery(initials: 'SS', name: 'Shantanu Singh', time: '06:30 AM', type: 'Retailer', frequency: '2L/Day', status: DeliveryStatus.pending),
//     ];
//     notifyListeners();
//   }
// }