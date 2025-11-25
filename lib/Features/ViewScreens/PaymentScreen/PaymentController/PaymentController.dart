// lib/Controllers/payment_controller.dart

import 'package:flutter/material.dart';

import 'PaymentModel.dart';




class PaymentController with ChangeNotifier {
  bool _isLoading = true;
  PaymentSummary? _summary;
  List<CustomerPayment> _allPayments = [];
  List<CustomerPayment> _filteredPayments = [];
  String _searchText = '';
  String _filterType = 'All';

  bool get isLoading => _isLoading;
  PaymentSummary? get summary => _summary;
  List<CustomerPayment> get filteredPayments => _filteredPayments;
  String get filterType => _filterType;

  PaymentController() {
    fetchPaymentData();
  }

  Future<void> fetchPaymentData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Hardcoded data to match the image
    _summary = PaymentSummary(pending: 26.6, received: 80.0, advance: 5.7);

    _allPayments = [
      CustomerPayment(
        initials: 'RK',
        customerName: 'Rajesh Kumar',
        time: '06:30 AM',
        type: 'Retailer',
        frequency: '2L/Day',
        status: 'Pending',
        pendingAmount: 450,
        totalReceived: 1350,
        advanceBalance: null, // First card in image
      ),
      CustomerPayment(
        initials: 'RK',
        customerName: 'Rajesh Kumar',
        time: '06:30 AM',
        type: 'Retailer',
        frequency: '2L/Day',
        status: 'Pending',
        pendingAmount: 450,
        totalReceived: 1350,
        advanceBalance: 150, // Second card in image (with advance)
      ),
      CustomerPayment(
        initials: 'SD',
        customerName: 'Sunita Devi',
        time: '07:00 AM',
        type: 'Consumer',
        frequency: '1L/Day',
        status: 'Received',
        pendingAmount: 0,
        totalReceived: 800,
        advanceBalance: null,
      ),
    ];

    _filteredPayments = _allPayments;
    _isLoading = false;
    notifyListeners();
  }

  void setSearchText(String text) {
    _searchText = text.toLowerCase();
    _applyFilters();
  }

  void setFilterType(String type) {
    _filterType = type;
    _applyFilters();
  }

  void _applyFilters() {
    List<CustomerPayment> results = _allPayments;

    // Filter by Search Text (Name or Mobile - only searching name here for simplicity)
    if (_searchText.isNotEmpty) {
      results = results.where((p) => p.customerName.toLowerCase().contains(_searchText)).toList();
    }

    // Filter by Type (e.g., 'Pending', 'Received', 'Advance')
    if (_filterType != 'All') {
      results = results.where((p) {
        if (_filterType == 'Pending') return p.pendingAmount > 0;
        if (_filterType == 'Received') return p.pendingAmount == 0;
        if (_filterType == 'Advance') return p.advanceBalance != null && p.advanceBalance! > 0;
        return true;
      }).toList();
    }

    _filteredPayments = results;
    notifyListeners();
  }
}