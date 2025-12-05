// lib/components/google_map/live_map_widget.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Features/ViewScreens/Route/MainRoutesView/Model/RoutesModel.dart';


class LiveMapWidget extends StatefulWidget {
  final List<MapStop> stops;
  final LatLng? userLocation;

  const LiveMapWidget({
    super.key,
    required this.stops,
    this.userLocation,
  });

  @override
  State<LiveMapWidget> createState() => _LiveMapWidgetState();
}

class _LiveMapWidgetState extends State<LiveMapWidget> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    _markers.clear();

    for (var stop in widget.stops) {
      // ✅ Null aur "0.0" dono check karo
      if (stop.latitude.isNotEmpty &&
          stop.longitude.isNotEmpty &&
          stop.latitude != "0.0" &&
          stop.longitude != "0.0") {

        try {
          _markers.add(
            Marker(
              markerId: MarkerId("stop_${stop.id}"),
              position: LatLng(
                double.parse(stop.latitude),
                double.parse(stop.longitude),
              ),
              infoWindow: InfoWindow(
                title: stop.customerName,
                snippet: "${stop.status} • ${stop.address}",
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                stop.status.toLowerCase() == "delivered"
                    ? BitmapDescriptor.hueGreen
                    : BitmapDescriptor.hueRed,
              ),
            ),
          );
        } catch (e) {
          print("❌ Invalid coordinates for ${stop.customerName}: $e");
        }
      }
    }

    // User location marker...
    if (widget.userLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId("me"),
          position: widget.userLocation!,
          infoWindow: const InfoWindow(title: "📍 Your Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    setState(() {});
  }






  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.userLocation ?? const LatLng(26.8467, 80.9462),
            zoom: 13,
          ),
          markers: _markers,
          onMapCreated: (controller) => mapController = controller,
          myLocationEnabled: true,
        ),

        // ✅ Text labels as overlay
        ...widget.stops.map((stop) {
          if (stop.latitude.isEmpty || stop.longitude.isEmpty) return const SizedBox();

          return Positioned(
            left: 50, // Calculate based on lat/lng to screen conversion
            top: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: stop.status.toLowerCase() == "delivered"
                    ? Colors.green
                    : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                stop.customerName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
