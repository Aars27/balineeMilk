// lib/Providers/UserInfoProvider.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../Savetoken/SaveToken.dart';

/// Global Provider for User Info + Location
class UserInfoProvider with ChangeNotifier {
  // User Data
  String? _fullName;
  String? _userId;

  // Location Data
  Position? _currentPosition;
  String _currentAddress = "Detecting location...";
  bool _isLoadingLocation = false;
  bool _isLoadingUser = false;

  // Getters
  String? get fullName => _fullName;
  String? get userId => _userId;
  Position? get currentPosition => _currentPosition;
  String get currentAddress => _currentAddress;
  bool get isLoadingLocation => _isLoadingLocation;
  bool get isLoadingUser => _isLoadingUser;
  bool get isLoading => _isLoadingLocation || _isLoadingUser;

  // ✅ Combined: Fetch User + Location (Call this once on app start)
  Future<void> initialize() async {
    await Future.wait([
      fetchUserData(),
      fetchLocation(),
    ]);
  }

  // ✅ Fetch User Data from TokenHelper
  Future<void> fetchUserData() async {
    _isLoadingUser = true;
    notifyListeners();

    try {
      final tokenHelper = TokenHelper();
      _fullName = await tokenHelper.getFullName();
      _userId = await tokenHelper.getUserId();

      print("✅ User Data Loaded: $_fullName");
    } catch (e) {
      print("❌ Error fetching user data: $e");
      _fullName = "Guest User";
    }

    _isLoadingUser = false;
    notifyListeners();
  }

  // ✅ Fetch Current Location
  Future<void> fetchLocation() async {
    _isLoadingLocation = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _currentAddress = "Location services disabled";
        _isLoadingLocation = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _currentAddress = "Gomti Nagar, Lucknow"; // Fallback
          _isLoadingLocation = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _currentAddress = "Gomti Nagar, Lucknow"; // Fallback
        _isLoadingLocation = false;
        notifyListeners();
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (_currentPosition != null) {
        _currentAddress = await _getAddressFromLatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }
    } catch (e) {
      print("❌ Location Error: $e");
      _currentAddress = "Gomti Nagar, Lucknow"; // Fallback
    }

    _isLoadingLocation = false;
    notifyListeners();
  }

  // ✅ Reverse Geocoding
  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '';

        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          address += '${place.subLocality}, ';
        } else if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
          address += '${place.thoroughfare}, ';
        }

        if (place.locality != null && place.locality!.isNotEmpty) {
          address += place.locality!;
        }

        return address.isNotEmpty ? address : "Lucknow, UP";
      }
    } catch (e) {
      print("❌ Geocoding Error: $e");
    }

    return "Gomti Nagar, Lucknow"; // Fallback
  }

  // ✅ Refresh Location Manually
  Future<void> refreshLocation() async {
    await fetchLocation();
  }

  // ✅ Clear Data on Logout
  void clearData() {
    _fullName = null;
    _userId = null;
    _currentPosition = null;
    _currentAddress = "Location unavailable";
    notifyListeners();
  }

  // ✅ Get Display String: "Name · Location"
  String getDisplayText() {
    final name = _fullName ?? "Guest";
    final location = _currentAddress;
    return "$name · $location";
  }


  // ✅ Get Short Display: "Name" only
  String getFullName() {
    return _fullName ?? "Guest User";
  }


  // ✅ Get Location Only
  String getLocationOnly() {
    return _currentAddress;
  }
}