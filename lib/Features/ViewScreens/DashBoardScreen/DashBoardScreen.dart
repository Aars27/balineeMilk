// lib/Views/HomeScreen.dart

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../Core/Constant/app_colors.dart';
import '../../../Core/Constant/text_constants.dart';
import 'DashboardController/DashboardController.dart';
import 'DashBoardModal/dashboardmodel.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // You must register DashboardController in your MultiProvider in main.dart
    return Scaffold(
      backgroundColor: AppColors.cardBackground, // Light background for the dashboard area
      body: Consumer<DashboardController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              // 1. Top Wavy Background (Asset needed: 'assets/dashboard_wave.png')
              // This image asset should cover the top part with the required white wave shape
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
SizedBox(height: 80,),
                        // Today's Milk Card
                        _buildMilkCard(context, controller.milkData!),

                        const SizedBox(height: 15),

                        // Add New Customer Button
                        _buildAddCustomerButton(context),

                        // const SizedBox(height: 10),


                        // Metrics Grid
                        _buildMetricsGrid(controller.metrics),

                        // Delivery Progress Card
                        _buildDeliveryProgressCard(controller.summary!),

                        const SizedBox(height: 15),

                        // Summary Cards
                        _buildSummaryCards(controller.summary!),

                        const SizedBox(height: 20), // Space for bottom navigation
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
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 15, right: 20, bottom: 10),
      child: Column(
        children: [
          Row(
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
          Icon(icon, size: 24, color: AppColors.textDark),
        ],
      ),
    );
  }

  Widget _buildMilkCard(BuildContext context, MilkData data) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0,left: 20,),
      child: SizedBox(
        height: 150,
        child: Container(
          // padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(

            gradient: LinearGradient(colors: [
               AppColors.primary,
              AppColors.accentRed
            ],
              end: Alignment.topLeft,
            begin: Alignment.topRight,

            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppColors.textDark.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.water_drop, color: AppColors.white, size: 24),
                    const SizedBox(width: 8),
                    Text("Today's Milk", style: TextConstants.subHeadingStyle.copyWith(color: AppColors.white)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text("Overview", style: TextConstants.smallTextStyle.copyWith(color: AppColors.white.withOpacity(0.8))),
                ),
                const SizedBox(height: 13),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMilkMetricItem("Token", "${data.token}L", Colors.white),
                          _buildMilkMetricItem("Delivered", "${data.delivered}L", Colors.white),
                          _buildMilkMetricItem("Returned", "${data.returned}L", Colors.white),
                        ],
                      ),
                    ),
                    // Scooter Image
                    Image.asset(
                      'assets/bike.png',
                      height: 80,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildMilkMetricItem(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title, style: TextConstants.bodyStyle.copyWith(color: color.withOpacity(0.8),fontSize: 12)),
          Text(value, style: TextConstants.subHeadingStyle.copyWith(color: color,fontSize: 10)),
        ],
      ),
    );
  }


  Widget _buildAddCustomerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            Fluttertoast.showToast(msg: 'Comming soon..'
          ); },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3,
          ),
          child: Text('+ Add New Customer', style: TextConstants.smallTextStyle.copyWith(color: AppColors.black,fontSize: 16),)
        ),
      ),
    );
  }
  Widget _buildMetricsGrid(List<SalesData> metrics) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: metrics.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.6, // Ratio adjusted to match card height in image
        ),
        itemBuilder: (context, index) {
          final item = metrics[index];
          return _buildMetricCard(item);
        },
      ),
    );
  }

  Widget _buildMetricCard(SalesData data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.credit_card, size: 18, color: data.progressColor),
              const SizedBox(width: 5),
              Text(data.title, style: TextConstants.smallTextStyle.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          Text(data.amount, style: TextConstants.subHeadingStyle.copyWith(color: AppColors.textDark,fontSize: 10)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: data.progress,
            backgroundColor: AppColors.cardBackground,
            valueColor: AlwaysStoppedAnimation<Color>(data.progressColor),
            minHeight: 5,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryProgressCard(DeliverySummary summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.textDark.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery Progress', style: TextConstants.subHeadingStyle.copyWith(fontSize: 12)),

                Text('${summary.progressPercent.toStringAsFixed(0)}%',
                    style: TextConstants.headingStyle.copyWith(color: AppColors.primary,fontSize: 10)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: summary.progressPercent / 100,
              backgroundColor: AppColors.cardBackground,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 4,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Started', style: TextConstants.smallTextStyle),
                Text('In Progress', style: TextConstants.smallTextStyle),
                Text('Complete', style: TextConstants.smallTextStyle),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(DeliverySummary summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem("Consumers", summary.totalConsumers.toString()),
          _buildSummaryItem("Delivered", summary.delivered.toString()),
          _buildSummaryItem("Pending", summary.pending.toString()),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Container(
      width: 105, // Fixed width to align with the image
      height: 60,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextConstants.headingStyle.copyWith(fontSize: 14, color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text(title, style: TextConstants.smallTextStyle.copyWith(fontWeight: FontWeight.w600,fontSize: 10)),


        ],
      ),
    );
  }



}