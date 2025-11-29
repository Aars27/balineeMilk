// import 'package:balineemilk/Core/Constant/ApiServices.dart' show ApiService;
// import 'package:balineemilk/Features/ViewScreens/Profile/EditProfile/profilemodal.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
//
//
// class ProfileProvider extends ChangeNotifier {
//   final ApiService _apiService = ApiService();
//
//   Partner? _partner;
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   // --- Getters ---
//   Partner? get partner => _partner;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//
//   // --- Constructor (Optional: fetch data immediately on creation) ---
//   ProfileProvider() {
//     // fetchProfile();
//   }
//
//   // ------------------------------------------
//   // Fetch Profile Data
//   // ------------------------------------------
//   Future<void> fetchProfile() async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       // Assuming fetchProfileDetails returns the 'data' map from the API response
//       final profileData = await _apiService.fetchProfileDetails();
//       _partner = Partner.fromJson(profileData);
//     } catch (e) {
//       _errorMessage = 'Failed to load profile: $e';
//       print(_errorMessage);
//       _partner = null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // ------------------------------------------
//   // Update Profile Data
//   // ------------------------------------------
//   Future<String> updateProfile({
//     required String firstName,
//     required String lastName,
//     required String mobileNo,
//     required String email,
//   }) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     String successMessage = "Profile updated successfully!";
//
//     try {
//       final response = await _apiService.updateProfile(
//         firstName: firstName,
//         lastName: lastName,
//         mobileNo: mobileNo,
//         email: email,
//       );
//
//       // Update the local Partner object only if the API call succeeded
//       _partner?.updateDetails(
//         newFirstName: firstName,
//         newLastName: lastName,
//         newEmail: email,
//         newMobileNo: mobileNo,
//       );
//
//       successMessage = response['message'] ?? successMessage;
//
//     } catch (e) {
//       _errorMessage = e.toString().replaceFirst('Exception: ', '');
//       successMessage = ""; // Indicate failure
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//     return successMessage;
//   }
//
//   // ------------------------------------------
//   // Logout
//   // ------------------------------------------
//   Future<void> logout() async {
//     await _apiService.logout();
//     _partner = null; // Clear local state
//     // In a real app, this should trigger navigation back to the LoginScreen
//     notifyListeners();
//   }
// }