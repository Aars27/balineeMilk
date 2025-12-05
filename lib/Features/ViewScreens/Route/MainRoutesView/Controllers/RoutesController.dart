import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';  //  Add karo

import '../../../../../Components/Location/Location.dart';
import '../../../../../Components/Savetoken/SaveToken.dart';
import '../Model/RoutesModel.dart';

class RouteController with ChangeNotifier {
  bool isLoading = true;

  MapViewResponse? mapViewResponse;
  Position? currentPosition;
  String currentAddress = "Detecting location...";  // Add karo

  final LocationProvider locationHelper = LocationProvider();

  RouteController() {
    fetchMapData();
  }

  // ================= GET MAP DATA ====================
  Future<void> fetchMapData() async {
    isLoading = true;
    notifyListeners();

    try {
      final Dio dio = await TokenHelper().getDioClient();
      final response = await dio.get("/map-view");

      print("📍 Map API Response: ${response.data}");

      mapViewResponse = MapViewResponse.fromJson(response.data);
    } catch (e) {
      print("❌ MapView API Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // ================= GET CURRENT LOCATION ====================
  // Future<void> getCurrentLocation() async {
  //   try {
  //     currentPosition = await locationHelper.getCurrentLocation();
  //
  //     // ✅ Address fetch karo
  //     if (currentPosition != null) {
  //       currentAddress = await _getAddressFromLatLng(
  //         currentPosition!.latitude,
  //         currentPosition!.longitude,
  //       );
  //     }
  //
  //     notifyListeners();
  //   } catch (e) {
  //     print("❌ Location Error: $e");
  //     currentAddress = "Location unavailable";
  //     notifyListeners();
  //   }
  // }

  // ✅ Reverse Geocoding function
  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Address format: "Area, City"
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

    return "Location detected";
  }
}