import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../Components/Savetoken/SaveToken.dart';
import '../ProfileModel/ProfileModal.dart';

class ProfileProvider with ChangeNotifier {
  // Mock Data Initialization
  PartnerModel _partner = PartnerModel(
    name: "Ramesh Sharma",
    partnerId: "DP-12345",
    totalDeliveries: 2450,
    rating: 4.8,
    mobileNumber: "+91 9876543210",
    emailAddress: "ramesh.sharma@milkdist.com",
    assignedZone: "North Delhi - Zone A",
    joinedDate: DateTime(2023, 1, 1),
  );

  bool _isPushNotificationEnabled = true;
  bool _isGPSTrackingEnabled = true;
  bool _isPrivacyModeEnabled = false;

  // Getters
  PartnerModel get partner => _partner;
  bool get isPushNotificationEnabled => _isPushNotificationEnabled;
  bool get isGPSTrackingEnabled => _isGPSTrackingEnabled;
  bool get isPrivacyModeEnabled => _isPrivacyModeEnabled;

  // Setters/Business Logic
  void togglePushNotifications(bool value) {
    _isPushNotificationEnabled = value;
    // Notify listeners to update the UI
    notifyListeners();
  }

  void toggleGPSTracking(bool value) {
    _isGPSTrackingEnabled = value;
    notifyListeners();
  }

  void togglePrivacyMode(bool value) {
    _isPrivacyModeEnabled = value;
    notifyListeners();
  }

  // Example for a mock action
  Future<void> logout(BuildContext context) async {
    await TokenHelper().clearAuthData();

    if (context.mounted) {
      context.go('/loginpage');
    }
  }
}