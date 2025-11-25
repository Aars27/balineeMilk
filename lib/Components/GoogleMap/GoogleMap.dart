// lib/Widgets/LiveMapWidget.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'; // FIX for LocationData and PermissionStatus

class LiveMapWidget extends StatefulWidget {
  const LiveMapWidget({super.key});

  @override
  State<LiveMapWidget> createState() => _LiveMapWidgetState();
}

class _LiveMapWidgetState extends State<LiveMapWidget> {
  // Default location (e.g., center of the known area, like Lucknow)
  static const LatLng _initialLocation = LatLng(26.8467, 80.9462);

  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  final Location _location = Location();

  // Set of markers to display on the map
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location service is enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    // Check for location permission
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Get the actual current location
    _currentLocation = await _location.getLocation();

    if (_currentLocation != null) {
      setState(() {
        final LatLng currentLatLng = LatLng(
          _currentLocation!.latitude!,
          _currentLocation!.longitude!,
        );

        // Add a marker for the current location
        _markers.add(
          Marker(
            markerId: const MarkerId("current_location"),
            position: currentLatLng,
            infoWindow: const InfoWindow(title: "My Current Location"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        );

        // Move the camera to the current location
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: currentLatLng,
              zoom: 14.0, // Zoom level for a good view of the area
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: _initialLocation,
          zoom: 12.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          // If location was fetched quickly, update the camera
          if (_currentLocation != null) {
            _mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                  zoom: 14.0,
                ),
              ),
            );
          }
        },
        myLocationEnabled: true, // Shows the blue location dot
        myLocationButtonEnabled: true,
        markers: _markers,
      ),
    );
  }
}