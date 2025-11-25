// lib/Views/RouteTrackingScreen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Components/GoogleMap/GoogleMap.dart';
import '../../../../Core/Constant/app_colors.dart';
import '../../../../Core/Constant/text_constants.dart';
import 'Controllers/RoutesController.dart';
import 'Model/RoutesModel.dart';



class RouteTrackingScreen extends StatefulWidget {
  const RouteTrackingScreen({super.key});

  @override
  State<RouteTrackingScreen> createState() => _RouteTrackingScreenState();
}

class _RouteTrackingScreenState extends State<RouteTrackingScreen> {
  String _activeView = 'Map View'; // Correctly defined here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground, // Light gray background for the main content
      body: Consumer<RouteController>(
        builder: (context, controller, child) {
          if (controller.isLoading || controller.routeDetails == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final details = controller.routeDetails!;

          return Stack(
            children: [
              // 1. Top Wavy Background (Need 'assets/dashboard_wave.png')
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/vector.png',
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),

              // 2. Main Scrollable Content
              CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        // Header and Greeting
                        _buildHeader(context),
                        SizedBox(
                            height: 80
                        ),
                        // Main Tracking Info
                        _buildRouteTrackingInfo(context),

                        // Map View
                        _buildMapView(),

                        const SizedBox(height: 15),

                        // Route Progress
                        _buildRouteProgressCard(context, details),

                        const SizedBox(height: 20),

                        // Recent Deliveries
                        _buildRecentDeliveries(context, controller.recentDeliveries),

                        const SizedBox(height: 80), // Space for bottom navigation
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

  // --- Widget Builders ---
  Widget _buildHeader(BuildContext context) {
    // This should match the dashboard header exactly
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Shantanu!",
                style: TextConstants.smallTextStyle.copyWith(fontSize:20,fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.location_on,color: Colors.red,size: 14,),
                  Text(
                    "Gomiti nagar Lucknow",
                    style: TextConstants.smallTextStyle.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          _buildHeaderIcon(Icons.person_outline, null),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, String? text) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (text != null)
            Text(text, style: TextConstants.bodyStyle.copyWith(fontWeight: FontWeight.w600)),
          if (text != null) const SizedBox(width: 4),
          Icon(icon, size: 20, color: AppColors.textDark),
        ],
      ),
    );
  }

  // Inside lib/Views/RouteTrackingScreen.dart
  Widget _buildRouteTrackingInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... (Route Tracking Title and Speedometer are unchanged)
          Row(
            // ... (unchanged title/speedometer logic)
          ),
          const SizedBox(height: 10),

          // Action Tabs (Map View, Consumers, Distribution) - MODIFIED
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

              // Map View
              _buildRouteTab('Map View', _activeView == 'Map View', () => setState(() => _activeView = 'Map View')),
          const SizedBox(width: 10),

          // Consumers
          _buildRouteTab('Consumers', _activeView == 'Consumers', () => setState(() => _activeView = 'Consumers')),
          const SizedBox(width: 10),

          // Distribution
          _buildRouteTab('Distribution', _activeView == 'Distribution', () => setState(() => _activeView = 'Distribution')),
        ],
      ),
      const SizedBox(height: 15),

      // Metrics Cards (Distance & Time) - UNCHANGED
      Consumer<RouteController>(
        builder: (context, controller, child) {
          final details = controller.routeDetails!;
          return Row(
            // ... (unchanged metric cards logic)
          );
        },
      ),
      ],
    ),
    );
  }


  Widget _buildRouteTab(String title, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          // isActive now comes directly from the function call
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: isActive ? AppColors.primary : AppColors.textLight.withOpacity(0.5)),
          ),
          child: Center(
            child: Text(
              title,
              style: TextConstants.bodyStyle.copyWith(
                  color: isActive ? AppColors.white : AppColors.textDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricDetailCard(String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: AppColors.textDark.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextConstants.subHeadingStyle.copyWith(fontSize:14,fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextConstants.smallTextStyle),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    // Replace the placeholder Container with the actual live map widget
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5)
              )
            ]
        ),
        child: const LiveMapWidget(), // <-- Using the new LiveMapWidget
      ),
    );
  }

  Widget _buildRouteProgressCard(BuildContext context, RouteDetails details) {
    final completed = details.completedStops;
    final total = details.totalStops;
    final pending = total - completed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // Progress Bar
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: AppColors.textDark.withOpacity(0.05), blurRadius: 5),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Route Progress', style: TextConstants.subHeadingStyle.copyWith(fontSize: 14)),
                    Text('${details.progressPercent.toStringAsFixed(0)}%',
                        style: TextConstants.headingStyle.copyWith(color: AppColors.accentRed,fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: details.progressPercent / 100,
                  backgroundColor: AppColors.cardBackground,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$completed Completed', style: TextConstants.smallTextStyle.copyWith(fontSize: 12)),
                    Text('$pending Pending', style: TextConstants.smallTextStyle.copyWith(color: AppColors.accentRed,fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // Start Route Button
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                // minimumSize: const Size(double.infinity,40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.location_on, color: AppColors.white,size: 12,),
                  // const SizedBox(width: 2),
                  Text('Start Route Navigation', style: TextConstants.subHeadingStyle.copyWith(color: AppColors.white,fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentDeliveries(BuildContext context, List<Delivery> deliveries) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Deliveries', style: TextConstants.subHeadingStyle),
          const SizedBox(height: 10),

          ...deliveries.map((d) => _buildDeliveryItem(d)).toList(),
        ],
      ),
    );
  }

  Widget _buildDeliveryItem(Delivery d) {
    final statusColor = d.isCompleted ? Colors.lightGreen : AppColors.accentRed;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border(
          left: BorderSide(color: statusColor, width: 6),
        ),
        boxShadow: [
          BoxShadow(color: AppColors.textDark.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(d.isCompleted ? Icons.check_circle : Icons.radio_button_checked, color: statusColor, size: 24),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.customerName, style: TextConstants.bodyStyle.copyWith(fontWeight: FontWeight.w600)),
                  Text(d.time, style: TextConstants.smallTextStyle),
                ],
              ),
            ],
          ),

          Row(
            children: [
              Icon(Icons.call, color: AppColors.primary, size: 24),
              const SizedBox(width: 10),
              Icon(Icons.message, color: AppColors.primary, size: 24),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? AppColors.white : AppColors.textDark.withOpacity(0.7), size: 24),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.white : AppColors.textDark.withOpacity(0.7),
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}