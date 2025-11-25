// lib/Models/payment_model.dart

class PaymentSummary {
  final double pending;
  final double received;
  final double advance;

  PaymentSummary({
    required this.pending,
    required this.received,
    required this.advance,
  });
}

class CustomerPayment {
  final String initials;
  final String customerName;
  final String time;
  final String type; // e.g., 'Retailer'
  final String frequency; // e.g., '2L/Day'
  final String status; // e.g., 'Pending'
  final double pendingAmount;
  final double totalReceived;
  final double? advanceBalance; // Optional field

  CustomerPayment({
    required this.initials,
    required this.customerName,
    required this.time,
    required this.type,
    required this.frequency,
    required this.status,
    required this.pendingAmount,
    required this.totalReceived,
    this.advanceBalance,
  });
}