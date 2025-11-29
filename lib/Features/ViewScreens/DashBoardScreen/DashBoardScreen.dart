import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Constant/app_colors.dart';
import '../../../Core/Constant/text_constants.dart';
import 'DashboardController/DashboardController.dart';
import 'DashBoardModal/dashboardmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: Consumer<DashboardController>(
        builder: (context, controller, child) {
          if (controller.isLoading || controller.dashboard == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final dash = controller.dashboard!;
          // shortcut variable

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
                    delegate: SliverChildListDelegate(
                      [
                        _buildHeader(dash.deliveryPartner),
                        const SizedBox(height: 80),

                        // ---- MILK CARD ----
                        _buildMilkCard(dash.milk),

                        const SizedBox(height: 15),

                        _buildAddCustomerButton(context),

                        const SizedBox(height: 10),

                        // ---- METRICS GRID ----
                        _buildMetricsGrid(dash),

                        const SizedBox(height: 10),

                        // ---- DELIVERY PROGRESS ----
                        _buildDeliveryProgressCard(dash.deliveryProgress),

                        const SizedBox(height: 15),

                        // ---- SUMMARY ----
                        _buildSummaryCards(dash.deliveryProgress),

                        const SizedBox(height: 20),
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

  // ---------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------

  Widget _buildHeader(String userName) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 15, right: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$userName!",
                style: TextConstants.smallTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 14),
                  Text(
                    "Gomti Nagar Lucknow",
                    style: TextConstants.smallTextStyle.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.notifications_none, size: 24, color: AppColors.textDark),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // MILK CARD
  // ---------------------------------------------------------


  Widget _buildMilkCard(MilkData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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

            // Bike image at right
            Positioned(
              right: 10,
              bottom: 0,
              child: Image.asset(
                'assets/bike.png',  // your correct path here
                height: 100,
              ),
            ),

            // Text Content
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.water_drop, color: Colors.white),
                      const SizedBox(width: 8),
                      Text("Today's Milk",
                          style: TextConstants.subHeadingStyle.copyWith(color: Colors.white)),
                    ],
                  ),

                  const SizedBox(height: 5),
                  Text(
                    "Overview",
                    style: TextConstants.smallTextStyle.copyWith(color: Colors.white70),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      _milkItem("Taken", "${data.taken}L"),
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
          Text(title, style: TextConstants.smallTextStyle.copyWith(color: Colors.white)),
          Text(value, style: TextConstants.headingStyle.copyWith(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }




  Widget _buildMilkMetricItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title, style: TextConstants.smallTextStyle.copyWith(color: Colors.red)),
          Text(value, style: TextConstants.subHeadingStyle.copyWith(color: Colors.red)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // ADD CUSTOMER BUTTON
  // ---------------------------------------------------------

  Widget _buildAddCustomerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text("+ Add New Customer",
            style: TextConstants.smallTextStyle.copyWith(
              color: AppColors.black,
              fontSize: 16,
            )),
      ),
    );
  }

  // ---------------------------------------------------------
  // METRICS GRID
  // ---------------------------------------------------------

  Widget _buildMetricsGrid(DashboardModel dash) {
    final List<_MetricItem> items = [
      _MetricItem("Total Sales", dash.sales.total.toString(), dash.sales.deliveredPercent / 100, Colors.blue),
      _MetricItem("Cash", dash.cash.amount.toString(), dash.cash.percentage / 100, Colors.green),
      _MetricItem("Online", dash.online.amount.toString(), dash.online.percentage / 100, Colors.orange),
      _MetricItem("Pending", dash.pending.amount.toString(), dash.pending.percentage / 100, Colors.red),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.9,  // Smaller height (was larger before)
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            padding: const EdgeInsets.all(10), // Reduced padding
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12), // Smaller radius
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(item.color == Colors.blue
                        ? Icons.payments
                        : item.color == Colors.green
                        ? Icons.account_balance_wallet
                        : item.color == Colors.orange
                        ? Icons.wifi
                        : Icons.pending_actions,
                      size: 16,   // Reduced icon size
                      color: item.color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.title,
                      style: TextConstants.smallTextStyle.copyWith(fontSize: 11),  // smaller text
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  "₹${item.amount}",
                  style: TextConstants.headingStyle.copyWith(
                    fontSize: 14,  // reduced value size
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  height: 5,
                  child: LinearProgressIndicator(
                    value: item.progress,
                    minHeight: 6,  // makes the bar visible
                    backgroundColor: Colors.grey.shade300,  // light grey visible background
                    valueColor: AlwaysStoppedAnimation(item.color), // strong visible color
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------
  // DELIVERY PROGRESS
  // ---------------------------------------------------------

  Widget _buildDeliveryProgressCard(DeliveryProgress p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
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
                Text("${p.progressPercent.toStringAsFixed(0)}%", style: TextConstants.headingStyle.copyWith(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: LinearProgressIndicator(
                backgroundColor: Colors.orange.shade50,
                value: p.progressPercent / 100,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryItem("Total", p.totalConsumers.toString()),
                _buildSummaryItem("Delivered", p.delivered.toString()),
                _buildSummaryItem("Pending", p.pending.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(DeliveryProgress p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem("Consumers", p.totalConsumers.toString()),
          _buildSummaryItem("Delivered", p.delivered.toString()),
          _buildSummaryItem("Pending", p.pending.toString()),
        ],
      ),
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
          Text(value, style: TextConstants.headingStyle.copyWith(fontSize: 14)),
          const SizedBox(height: 4),
          Text(title, style: TextConstants.smallTextStyle),
        ],
      ),
    );
  }
}

class _MetricItem {
  final String title;
  final String amount;
  final double progress;
  final Color color;

  _MetricItem(this.title, this.amount, this.progress, this.color);
}
