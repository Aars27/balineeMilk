// lib/Features/ViewScreens/ReportScreen/ReportScreen.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../Core/Constant/app_colors.dart';
import '../../../Core/Constant/text_constants.dart';
import 'ReportController/ReportController.dart';
import 'ReportModal/ReportModel.dart';





class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: Consumer<ReportController>(
        builder: (context, controller, child) {
          // ... (existing loading check)
          if (controller.isLoading || controller.summary == null) {
            // Show loading over the existing content for smooth transition
          }

          return Stack(
            children: [
              // 1. Top Background
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/vector.png', // Reusing the same asset
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
                        // Filter Tabs (Sales, Milk, Shift)
                        _buildFilterTabs(context, controller),

                        const SizedBox(height: 20),

                        // Summary Cards (Total Sales, Cash Flow)
                        // _buildMilkSummaryCards(BuildContext context, ReportSummary summary),

                        const SizedBox(height: 20),
                        

                        // Payment Mode Distribution Pie Chart
                        _buildPaymentDistribution(context, controller.paymentDistribution),

                        const SizedBox(height: 30),

                        // Download Report Button
                        // _buildDownloadReportButton(context),

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

  // Reusing components from the Dashboard
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
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
          const SizedBox(height: 50),
          Text("Reports & Analytics", style: TextConstants.headingStyle.copyWith(fontSize: 20)),
          Text("View daily and monthly Insights", style: TextConstants.bodyStyle.copyWith(fontSize: 12)),
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

  Widget _buildFilterTabs(BuildContext context, ReportController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        children: [
          _buildTabButton(context, controller, 'Sales'),
          const SizedBox(width: 10),
          _buildTabButton(context, controller, 'Milk'),
          const SizedBox(width: 10),
          _buildTabButton(context, controller, 'Shift'),
        ],
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, ReportController controller, String tabName) {
    final bool isActive = controller.selectedTab == tabName;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setSelectedTab(tabName),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isActive ? AppColors.primary : AppColors.cardBackground),
            boxShadow: isActive ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8)] : [],
          ),
          alignment: Alignment.center,
          child: Text(
            tabName,
            style: TextConstants.bodyStyle.copyWith(
              color: isActive ? AppColors.white : AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
  //
  // Widget _buildSummaryCards(BuildContext context, ReportSummary summary) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         // Total Sales Card (Green)
  //         _buildReportSummaryCard(
  //           context,
  //           'Total Sales',
  //           '₹${summary.totalSales.toStringAsFixed(1)}k',
  //           summary.salesPeriod,
  //           AppColors.primaryGreen,
  //           Icons.show_chart,
  //         ),
  //         const SizedBox(width: 15),
  //         // Cash Flow Card (Orange)
  //         _buildReportSummaryCard(
  //           context,
  //           'Cash Flow',
  //           '₹${summary.cashFlow.toStringAsFixed(0)}',
  //           summary.cashFlowType,
  //           AppColors.primary,
  //           Icons.account_balance_wallet_outlined,
  //         ),
  //       ],
  //     ),
  //   );
  // }



  Widget _buildReportSummaryCard(
      BuildContext context,
      String title,
      String value,
      String subtitle,
      Color backgroundColor,
      IconData icon,
      ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: backgroundColor.withOpacity(0.4), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(icon, color: AppColors.white, size: 28),
            ),
            const SizedBox(height: 5),
            Text(title, style: TextConstants.smallTextStyle.copyWith(color: AppColors.white,fontSize: 14)),
            Text(value, style: TextConstants.headingStyle.copyWith(color: AppColors.white, fontSize: 16)),
            Text(subtitle, style: TextConstants.smallTextStyle.copyWith(color: AppColors.white.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDistribution(BuildContext context, List<PaymentDistributionData> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
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
                Text('Payment Mode Distribution', style: TextConstants.subHeadingStyle),

                IconButton(onPressed: (){
                  Fluttertoast.showToast(msg: 'Download Report');
                }, icon:
                    Icon(Icons.download,size: 20,color: Colors.grey,),
                )


              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200, // Adjust height as needed
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: PieChart(
                      PieChartData(
                        sections: data.map((item) {
                          return PieChartSectionData(
                            color: item.color,
                            value: item.percentage,
                            title: '${item.percentage.toInt()}%',
                            radius: 50,
                            titleStyle: TextConstants.smallTextStyle.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                            badgeWidget: Text(item.category, style: TextConstants.smallTextStyle.copyWith(fontWeight: FontWeight.w600)),
                            badgePositionPercentageOffset: 1.3,
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        startDegreeOffset: 270,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildMilkSummaryCards(BuildContext context, ReportSummary summary) {
    // This replaces _buildSummaryCards for Milk tab
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total Intake Card (Green)
          _buildReportSummaryCard(
            context,
            'Total Intake',
            '${summary.totalSales.toStringAsFixed(0)} L', // Use totalSales for intake
            summary.salesPeriod,
            AppColors.primaryGreen,
            Icons.local_drink_outlined, // Milk icon
          ),
          const SizedBox(width: 15),
          // Distributed Card (Orange)
          _buildReportSummaryCard(
            context,
            'Distributed',
            '${summary.cashFlow.toStringAsFixed(0)} L', // Use cashFlow for distributed amount
            summary.cashFlowType,
            AppColors.primary,
            Icons.timeline, // Distribution icon
          ),
        ],
      ),
    );
  }

  Widget _buildMilkDistributionChart(BuildContext context, List<PaymentDistributionData> data) {
    // This replaces _buildPaymentDistribution for Milk tab
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
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
            Text('Milk Distribution vs Returns', style: TextConstants.subHeadingStyle),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: data.map((item) {
                    return PieChartSectionData(
                      color: item.color,
                      value: item.percentage,
                      title: '', // Remove percentage title in center
                      radius: 70, // Slightly larger radius
                      // Using the category for the badge/label
                      badgeWidget: Text(
                          item.category.contains('Distributed') ? 'Distributed: 425L' : 'Returned: 75L',
                          style: TextConstants.smallTextStyle.copyWith(color: item.color, fontWeight: FontWeight.bold)
                      ),
                      badgePositionPercentageOffset: item.category.contains('Distributed') ? 0.3 : 1.3,
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 0, // Make the chart full circle
                  startDegreeOffset: 270,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Rename existing methods for clarity in dynamic content ---

  // // Renaming old _buildSummaryCards to _buildSalesSummaryCards
  // Widget _buildSalesSummaryCards(BuildContext context, ReportSummary summary) {
  //
  // }
  //
  // // Renaming old _buildPaymentDistribution to _buildSalesPaymentDistribution
  // Widget _buildSalesPaymentDistribution(BuildContext context, List<PaymentDistributionData> data) {
  //
  // }


}