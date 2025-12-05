import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../Components/Providers/UserInfoProviders.dart';
import '../../../Core/Constant/app_colors.dart';
import '../../../Core/Constant/text_constants.dart';
import '../../NotificationScreen/NotificationScreen.dart';
import 'AddRandomcustomer/addcustomer.dart';
import 'DashboardController/DashboardController.dart';
import 'DashBoardModal/dashboardmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("🎨 HomeScreen building...");

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: Consumer<DashboardController>(
        builder: (context, controller, child) {
          print("🔄 Consumer rebuilding - isLoading: ${controller.isLoading}, hasData: ${controller.dashboard != null}");

          // Loading state - only when no data exists
          if (controller.isLoading && controller.dashboard == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    "Loading dashboard...",
                    style: TextConstants.smallTextStyle,
                  ),
                ],
              ),
            );
          }

          // Error state - when data load failed
          if (controller.dashboard == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage ?? "Failed to load dashboard",
                      style: TextConstants.subHeadingStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        print("🔄 Retry button pressed");
                        controller.fetchDashboard();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final dash = controller.dashboard!;
          print("✅ Rendering dashboard with data");

          // Success state - show dashboard
          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: CustomScrollView(
              slivers: [
                // Header as Sliver
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            'assets/vector.png',
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                            cacheHeight: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                // height: 100,
                                color: AppColors.primary.withOpacity(0.1),
                              );
                            },
                          ),
                          _buildHeader(context),
                        ],
                      ),
                    ],
                  ),
                ),

                // Rest of content
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildMilkCard(dash.milk),
                      const SizedBox(height: 15),

                      _buildAddCustomerButton(context),
                      const SizedBox(height: 15),

                      _buildMetricsSection(dash),
                      const SizedBox(height: 15),

                      _buildDeliveryProgressCard(dash.deliveryProgress),
                      const SizedBox(height: 15),

                      _buildSummaryCards(dash.deliveryProgress),
                      const SizedBox(height: 20),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);


    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 15, right: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userInfo.isLoadingUser
                    ? "Loading..."
                    : "${userInfo.getFullName()}!",
                style: TextConstants.smallTextStyle.copyWith(fontSize:20,fontWeight: FontWeight.bold),

              ),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 14),
                  Text(
                    userInfo.isLoadingLocation
                        ? "Detecting..."
                        : userInfo.getLocationOnly(),
                    style: TextConstants.smallTextStyle.copyWith(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: (){
              context.go('/notification');
            },
            child: const Icon(
              Icons.notifications_none,
              size: 24,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilkCard(MilkData data) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.accentRed],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: 0,
            child: Image.asset(
              'assets/bike.png',
              height: 100,
              cacheHeight: 100,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      "Today's Milk",
                      style: TextConstants.subHeadingStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "Overview",
                  style: TextConstants.smallTextStyle.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _milkItem("Stock", "${data.taken}L"),
                    const SizedBox(width: 5),
                    _milkItem("Delivered", "${data.delivered}L"),
                    const SizedBox(width: 5),
                    _milkItem("Returned", "${data.returned}L"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _milkItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextConstants.smallTextStyle.copyWith(color: Colors.white),
          ),
          Text(
            value,
            style: TextConstants.headingStyle.copyWith(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCustomerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Navigate to Add Customer Screen
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddCustomerScreen(),
          ),
        );

        // If customer added successfully, refresh dashboard
        if (result == true && context.mounted) {
          context.read<DashboardController>().refresh();

          Fluttertoast.showToast(
            msg: "Dashboard refreshed",
            backgroundColor: Colors.green,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        "+ Add New Customer",
        style: TextConstants.smallTextStyle.copyWith(
          color: AppColors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildMetricsSection(DashboardModel dash) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                "Total Sales",
                dash.sales.total.toString(),
                dash.sales.deliveredPercent / 100,
                Colors.blue,
                Icons.payments,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                "Cash",
                dash.cash.amount.toString(),
                dash.cash.percentage / 100,
                Colors.green,
                Icons.account_balance_wallet,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                "Online",
                dash.online.amount.toString(),
                dash.online.percentage / 100,
                Colors.orange,
                Icons.wifi,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                "Pending",
                dash.pending.amount.toString(),
                dash.pending.percentage / 100,
                Colors.red,
                Icons.pending_actions,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      String title,
      String amount,
      double progress,
      Color color,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextConstants.smallTextStyle.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "₹$amount",
            style: TextConstants.headingStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryProgressCard(DeliveryProgress p) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Delivery Progress", style: TextConstants.subHeadingStyle),
              Text(
                "${p.progressPercent.toStringAsFixed(0)}%",
                style: TextConstants.headingStyle.copyWith(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              backgroundColor: Colors.orange.shade50,
              value: p.progressPercent / 100,
              color: AppColors.primary,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProgressItem("Total", p.totalConsumers.toString()),
              _buildProgressItem("Delivered", p.delivered.toString()),
              _buildProgressItem("Pending", p.pending.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextConstants.headingStyle.copyWith(fontSize: 16),
        ),
        Text(title, style: TextConstants.smallTextStyle),
      ],
    );
  }

  Widget _buildSummaryCards(DeliveryProgress p) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryItem("Consumers", p.totalConsumers.toString()),
        _buildSummaryItem("Delivered", p.delivered.toString()),
        _buildSummaryItem("Pending", p.pending.toString()),
      ],
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextConstants.headingStyle.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextConstants.smallTextStyle),
        ],
      ),
    );
  }








}