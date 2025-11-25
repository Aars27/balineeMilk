// lib/models/location_model.dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Often used with geolocator

class LocationModel {
  String currentAddress = 'Fetching location...';

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When permissions are granted, return the current position.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      // Use geocoding package to convert coordinates to an address
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];

      // Construct a simple address string
      return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}";
    } catch (e) {
      print(e);
      return "Address not found";
    }
  }
}