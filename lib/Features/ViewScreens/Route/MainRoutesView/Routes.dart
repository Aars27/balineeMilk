// lib/Features/ViewScreens/Route/MainRoutesView/Routes.dart
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../Components/GoogleMap/GoogleMap.dart';
import '../../../../Components/Providers/UserInfoProviders.dart';
import '../../../../Components/Savetoken/SaveToken.dart';
import '../../../../Core/Constant/app_colors.dart';
import '../../../../Core/Constant/text_constants.dart';

import '../Consumer/ConsumerScreen.dart';
import '../Consumer/Consumer_provider.dart';
import '../Distribution/DistributionScreen.dart';
import '../SpedoMeter/speedometer.dart';

import 'Controllers/RoutesController.dart';
import 'Model/RoutesModel.dart';


class RouteTrackingScreen extends StatefulWidget {
  const RouteTrackingScreen({super.key});

  @override
  State<RouteTrackingScreen> createState() => _RouteTrackingScreenState();
}

class _RouteTrackingScreenState extends State<RouteTrackingScreen> {
  String _activeView = 'Map View';

  Future<void> _loadConsumersIfNeeded() async {
    final token = await TokenHelper().getToken();   // <-- FIXED

    if (!mounted) return;

    final provider = Provider.of<ConsumerProvider>(context, listen: false);

    if (provider.consumers.isEmpty && token != null) {
      await provider.loadConsumers(token);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: Consumer<RouteController>(
        builder: (context, controller, child) {
          if (controller.isLoading || controller.mapViewResponse == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final summary = controller.mapViewResponse!.summary;

          return Stack(
            children: [
              _backgroundImage(),

              CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _buildHeader(controller),
                        const SizedBox(height: 60),

                        _buildRouteTrackingCard(summary),
                        const SizedBox(height: 15),

                        _buildTabs(),
                        const SizedBox(height: 15),

                        // ---------------- MAP VIEW ----------------
                        if (_activeView == "Map View") ...[
                          _buildMapView(controller),
                          const SizedBox(height: 15),
                          _buildRouteProgress(summary),
                          const SizedBox(height: 15),
                          _buildRecentDeliveries(controller.mapViewResponse!.mapData)
                        ],

                        // ---------------- CONSUMERS ----------------
                        if (_activeView == "Consumers")
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: const ConsumerScreenWidget(),
                          ),

                        // ---------------- DISTRIBUTION ----------------
                        if (_activeView == "Distribution")
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: MilkDistributionScreen(),
                          ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _backgroundImage() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Image.asset(
        'assets/vector.png',
        fit: BoxFit.cover,
        height: 200,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildHeader(RouteController controller) {
    final userInfo = Provider.of<UserInfoProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(  //Overflow avoid karne ke liye
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userInfo.isLoadingUser
                      ? "Loading..."
                      : "${userInfo.getFullName()}!",
                  style: TextConstants.smallTextStyle.copyWith(fontSize:20,fontWeight: FontWeight.bold),

                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 16),
                    const SizedBox(width: 4),
                    Expanded(  //  Long address ke liye
                      child: Text(
                        userInfo.isLoadingLocation
                            ? "Detecting..."
                            : userInfo.getLocationOnly(),
                        style: TextConstants.smallTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _headerIcon(Icons.notifications),
        ],
      ),
    );
  }





  Widget _headerIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: AppColors.textDark),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildRouteTrackingCard(MapViewSummary summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Route Tracking",
                  style: TextConstants.subHeadingStyle.copyWith(fontSize: 16)),
              Text("Track your delivery route easily",
                  style: TextConstants.smallTextStyle),
            ],
          ),

          // SPEEDOMETER BUTTON
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => SpeedometerDialog(),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accentRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.speed, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text("Speedometer",
                      style: TextConstants.smallTextStyle.copyWith(
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _tab("Map View", _activeView == "Map View", () {
            setState(() => _activeView = "Map View");
          }),
          const SizedBox(width: 10),
          _tab("Consumers", _activeView == "Consumers", () async {
            setState(() => _activeView = "Consumers");
            await _loadConsumersIfNeeded();
          }),
          const SizedBox(width: 10),
          _tab("Distribution", _activeView == "Distribution", () {
            setState(() => _activeView = "Distribution");
          }),
        ],
      ),
    );
  }

  Widget _tab(String title, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: active ? AppColors.primary : Colors.grey.shade300),
          ),
          child: Center(
            child: Text(
              title,
              style: TextConstants.bodyStyle.copyWith(
                color: active ? Colors.white : AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildMapView(RouteController controller) {
    final stops = controller.mapViewResponse!.mapData;
    final pos = controller.currentPosition;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 300,
        child: LiveMapWidget(
          stops: stops,
          userLocation: pos != null
              ? LatLng(pos.latitude, pos.longitude)
              : null,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildRouteProgress(MapViewSummary summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Route Progress",
                  style: TextConstants.subHeadingStyle.copyWith(fontSize: 16),
                ),
                Text(
                  "${summary.percentage}%",
                  style: TextConstants.subHeadingStyle.copyWith(
                    fontSize: 18,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: summary.percentage / 100,
                minHeight: 8,
                color: AppColors.primary,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _progressItem(
                  Icons.check_circle,
                  "${summary.completed} Completed",
                  Colors.green,
                ),
                _progressItem(
                  Icons.pending,
                  "${summary.pending} Pending",
                  AppColors.accentRed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget _progressItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextConstants.smallTextStyle.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentDeliveries(List<MapStop> stops) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Deliveries",
            style: TextConstants.subHeadingStyle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),

          // ✅ Delivery cards
          ...stops.take(5).map((stop) => _deliveryCard(stop)).toList(),
        ],
      ),
    );
  }

  Widget _deliveryCard(MapStop stop) {
    final isDelivered = stop.status.toLowerCase() == "delivered";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ✅ Left side icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isDelivered ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isDelivered ? Icons.check_circle : Icons.inventory_2_outlined,
              color: isDelivered ? Colors.green : Colors.red,
              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          // ✅ Customer info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.customerName,
                  style: TextConstants.bodyStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        stop.address,
                        style: TextConstants.smallTextStyle.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ✅ Right side icons (call & message)
          Column(
            children: [
              _actionButton(Icons.phone, Colors.orange),
              const SizedBox(height: 8),
              _actionButton(Icons.message, Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }








}
