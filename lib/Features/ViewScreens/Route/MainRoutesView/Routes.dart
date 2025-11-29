import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Components/GoogleMap/GoogleMap.dart';
import '../../../../Core/Constant/app_colors.dart';
import '../../../../Core/Constant/text_constants.dart';
import '../Consumer/ConsumerScreen.dart';
import '../Consumer/Consumer_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: Consumer<RouteController>(
        builder: (context, controller, child) {
          if (controller.isLoading || controller.routeDetails == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final details = controller.routeDetails!;

          return Stack(
            children: [
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

              CustomScrollView(
                slivers: [
                  SliverList(
                    delegate:
                    SliverChildListDelegate(
                      [
                        _buildHeader(context),
                        const SizedBox(height: 80),

                        _buildRouteTrackingInfo(context),
                        const SizedBox(height: 15),

                        // SHOW ONLY THE SELECTED SECTION
                        if (_activeView == 'Map View') ...[
                          _buildMapView(),
                          const SizedBox(height: 15),
                          _buildRouteProgressCard(context, details),
                          const SizedBox(height: 20),
                          _buildRecentDeliveries(context, controller.recentDeliveries),
                        ],

                        if (_activeView == 'Consumers') ...[
                          const ConsumerScreenWidget(),
                        ],

                        if (_activeView == 'Distribution') ...[
                          _buildDistributionWidget(),
                        ],

                        const SizedBox(height: 80),
                      ],
                    )

                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // -------------------- NEW METHOD FOR SWITCHING VIEWS --------------------

  Widget _buildActiveView(RouteDetails details, List<Delivery> deliveries) {
    if (_activeView == 'Map View') {
      return Column(
        children: [
          _buildMapView(),
          const SizedBox(height: 15),
          _buildRouteProgressCard(context, details),
          const SizedBox(height: 20),
          _buildRecentDeliveries(context, deliveries),
        ],
      );
    } else if (_activeView == 'Consumers') {
      return const ConsumerScreenWidget();



    } else if (_activeView == 'Distribution') {
      return _buildDistributionWidget();
    }
    return Container();
  }


  // -------------------- NEW DISTRIBUTION WIDGET --------------------

  Widget _buildDistributionWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Distribution Content Here",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }


  // -------------------- EXISTING WIDGET BUILDERS --------------------

  Widget _buildHeader(BuildContext context) {
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
                style: TextConstants.smallTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 14),
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

  Widget _buildRouteTrackingInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Route Tracking",
                    style: TextConstants.subHeadingStyle.copyWith(fontSize: 16),
                  ),
                  Text(
                    "Track your delivery route",
                    style: TextConstants.smallTextStyle,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => SpeedometerDialog(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accentRed,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.speed, size: 20, color: AppColors.white),
                      const SizedBox(width: 5),
                      Text(
                        'Speedometer',
                        style: TextConstants.bodyStyle.copyWith(
                          color: AppColors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // TABS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRouteTab(
                'Map View',
                _activeView == 'Map View',
                    () => setState(() => _activeView = 'Map View'),
              ),
              const SizedBox(width: 10),

              _buildRouteTab(
                'Consumers',
                _activeView == 'Consumers',
                    () async {
                  print("═══════════════════════════════════════");
                  print("🔵 CONSUMER TAB CLICKED!");
                  print("═══════════════════════════════════════");

                  setState(() {
                    _activeView = 'Consumers';
                    print("✅ Active view set to: $_activeView");
                  });

                  try {
                    // Step 1: Get SharedPreferences
                    print("\n📱 STEP 1: Getting SharedPreferences...");
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    print("✅ SharedPreferences loaded");

                    // Step 2: Check ALL saved keys
                    print("\n📱 STEP 2: Checking all saved keys...");
                    Set<String> allKeys = prefs.getKeys();
                    print("📋 All Keys: $allKeys");

                    // Step 3: Try both possible token keys
                    print("\n📱 STEP 3: Checking token keys...");
                    String? token1 = prefs.getString("api_token");
                    String? token2 = prefs.getString("user_token");

                    print("🔑 api_token: ${token1 != null ? 'EXISTS (${token1.length} chars)' : 'NULL'}");
                    print("🔑 user_token: ${token2 != null ? 'EXISTS (${token2.length} chars)' : 'NULL'}");

                    // Use whichever token exists
                    String? token = token1 ?? token2;

                    if (token == null || token.isEmpty) {
                      print("\n❌ NO TOKEN FOUND!");
                      print("❌ Available keys: $allKeys");

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No authentication token found. Please login again."),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                      return;
                    }

                    print("\n✅ Token found: ${token.substring(0, 30)}...");
                    print("✅ Token length: ${token.length}");

                    // Step 4: Check if widget is mounted
                    print("\n📱 STEP 4: Checking widget mount status...");
                    if (!mounted) {
                      print("❌ Widget NOT mounted!");
                      return;
                    }
                    print("✅ Widget is mounted");

                    // Step 5: Get Provider
                    print("\n📱 STEP 5: Getting ConsumerProvider...");
                    final provider = Provider.of<ConsumerProvider>(context, listen: false);
                    print("✅ Provider instance: ${provider.hashCode}");
                    print("📊 Current consumers count: ${provider.consumers.length}");
                    print("⏳ Current loading state: ${provider.loading}");

                    // Step 6: Call loadConsumers
                    print("\n📱 STEP 6: Calling loadConsumers...");
                    await provider.loadConsumers(token);

                    print("\n🎉 LOAD COMPLETE!");
                    print("📊 Final consumers count: ${provider.consumers.length}");
                    print("❌ Error message: ${provider.errorMessage ?? 'None'}");

                    if (provider.consumers.isNotEmpty) {
                      print("✅ First consumer: ${provider.consumers[0].customerName}");
                    }

                    print("═══════════════════════════════════════");

                  } catch (e, stackTrace) {
                    print("\n💥 EXCEPTION IN TAB HANDLER!");
                    print("❌ Error: $e");
                    print("❌ Stack trace:\n$stackTrace");
                    print("═══════════════════════════════════════");

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error: $e"),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                },
              ),







              const SizedBox(width: 10),
              _buildRouteTab(
                'Distribution',
                _activeView == 'Distribution',
                    () => setState(() => _activeView = 'Distribution'),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Content based on active view
          if (_activeView == 'Map View')
            Consumer<RouteController>(
              builder: (context, controller, child) {
                if (controller.routeDetails == null) {
                  return const SizedBox.shrink();
                }
                return Row(
                  children: [
                  ],
                );
              },
            )
          else if (_activeView == 'Consumers')
            const ConsumerScreenWidget()
          else if (_activeView == 'Distribution')
            // Your distribution widget here
              const SizedBox.shrink()
            else
              const SizedBox.shrink(),
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
                fontSize: 12,
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
          Text(value, style: TextConstants.subHeadingStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextConstants.smallTextStyle),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
          ],
        ),
        child: const LiveMapWidget(),
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
                        style: TextConstants.headingStyle.copyWith(color: AppColors.accentRed, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: details.progressPercent / 100,
                  backgroundColor: AppColors.cardBackground,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 4,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$completed Completed', style: TextConstants.smallTextStyle.copyWith(fontSize: 12)),
                    Text('$pending Pending',
                        style: TextConstants.smallTextStyle.copyWith(color: AppColors.accentRed, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.location_on, color: AppColors.white, size: 12),
                  Text('Start Route Navigation',
                      style: TextConstants.subHeadingStyle.copyWith(color: AppColors.white, fontSize: 12)),
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
        border: Border(left: BorderSide(color: statusColor, width: 6)),
        boxShadow: [
          BoxShadow(color: AppColors.textDark.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(d.isCompleted ? Icons.check_circle : Icons.radio_button_checked,
                  color: statusColor, size: 24),
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
              const Icon(Icons.call, color: AppColors.primary, size: 24),
              const SizedBox(width: 10),
              const Icon(Icons.message, color: AppColors.primary, size: 24),
            ],
          ),
        ],
      ),
    );
  }
}
