class PartnerModel {
  final String name;
  final String partnerId;
  final int totalDeliveries;
  final double rating;
  final String mobileNumber;
  final String emailAddress;
  final String assignedZone;
  final DateTime joinedDate;

  PartnerModel({
    required this.name,
    required this.partnerId,
    required this.totalDeliveries,
    required this.rating,
    required this.mobileNumber,
    required this.emailAddress,
    required this.assignedZone,
    required this.joinedDate,
  });
}