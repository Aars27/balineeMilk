class Partner {
  final int id;
  String firstName;
  String lastName;
  String email;
  String mobileNo;
  final String? consumerId;
  final int isActive;

  Partner({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNo,
    this.consumerId,
    required this.isActive,
  });

  // Factory method to create a Partner object from API JSON response
  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      mobileNo: json['mobile_no'] as String,
      consumerId: json['consumer_id'] as String?,
      isActive: json['is_active'] as int,
    );
  }

  // Method to easily update the object's properties after a successful API call
  void updateDetails({
    required String newFirstName,
    required String newLastName,
    required String newEmail,
    required String newMobileNo,
  }) {
    firstName = newFirstName;
    lastName = newLastName;
    email = newEmail;
    mobileNo = newMobileNo;
  }
}