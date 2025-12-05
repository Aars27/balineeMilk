// lib/Features/ViewScreens/ReportScreen/ReportScreen.dart

import 'package:balineemilk/Features/ViewScreens/ReportScreen/shift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../Components/Providers/UserInfoProviders.dart';
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
          // 1. STRICT LOADING + NULL CHECK
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final ReportSummary? summary = controller.summary;

          // If summary is null – show simple message, DO NOT BUILD SCROLL VIEW
          if (summary == null) {
            return const Center(
              child: Text("No report data found"),
            );
          }

          final String selectedTab = controller.selectedTab;
          final List<PaymentDistributionData> payments =
              controller.paymentDistribution;

          return Stack(
            children: [
              // Top Background Image
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

              // Scroll Content
              CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _buildHeader(context),

                        _buildFilterTabs(context, controller),

                        const SizedBox(height: 20),

                        // ---------------- TAB CONTENT ----------------
                        if (selectedTab == 'Sales') ...[
                          _buildSalesSummaryCards(context, summary),
                          const SizedBox(height: 20),
                          _buildPaymentDistribution(context, payments),
                        ] else if (selectedTab == 'Milk') ...[
                          _buildMilkSummaryCards(context, summary),
                          const SizedBox(height: 20),
                          _buildMilkDistributionChart(context, payments),
                        ]  else if (selectedTab == 'Shift') ...[
                          const ShiftReportWidget(),  // Ye line add karo
                          const SizedBox(height: 20),
                          _buildShiftDetailsList(context, controller),
                        ],

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

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);

    return Padding(
      padding:
      const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
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
                    userInfo.isLoadingUser
                        ? "Loading..."
                        : "${userInfo.getFullName()}!",
                    style: TextConstants.smallTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 14,
                      ),
                      Text(
                        userInfo.isLoadingLocation
                            ? "Detecting..."
                            : userInfo.getLocationOnly(),
                        style: TextConstants.smallTextStyle.copyWith(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _buildHeaderIcon(Icons.notifications, null),
            ],
          ),
          const SizedBox(height: 50),
          Text(
            "Reports & Analytics",
            style: TextConstants.headingStyle.copyWith(fontSize: 20),
          ),
          Text(
            "View daily and monthly insights",
            style: TextConstants.bodyStyle.copyWith(fontSize: 12),
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
            Text(
              text,
              style: TextConstants.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          if (text != null) const SizedBox(width: 4),
          Icon(icon, size: 20, color: AppColors.textDark),
        ],
      ),
    );
  }

  // ============================================================
  // TABS
  // ============================================================

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

  Widget _buildTabButton(
      BuildContext context,
      ReportController controller,
      String tabName,
      ) {
    final bool isActive = controller.selectedTab == tabName;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setSelectedTab(tabName),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive
                  ? AppColors.primary
                  : AppColors.cardBackground,
            ),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
              )
            ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            tabName,
            style: TextConstants.bodyStyle.copyWith(
              color:
              isActive ? AppColors.white : AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // COMMON SUMMARY CARD
  // ============================================================

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
            BoxShadow(
              color: backgroundColor.withOpacity(0.4),
              blurRadius: 10,
            ),
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
            Text(
              title,
              style: TextConstants.smallTextStyle.copyWith(
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: TextConstants.headingStyle.copyWith(
                color: AppColors.white,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: TextConstants.smallTextStyle.copyWith(
                color: AppColors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SALES TAB
  // ============================================================

  Widget _buildSalesSummaryCards(
      BuildContext context, ReportSummary summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          _buildReportSummaryCard(
            context,
            'Total Sales',
            '₹${summary.totalSales.toStringAsFixed(1)}k',
            summary.salesPeriod,
            AppColors.primaryGreen,
            Icons.show_chart,
          ),
          const SizedBox(width: 15),
          _buildReportSummaryCard(
            context,
            'Cash Flow',
            '₹${summary.cashFlow.toStringAsFixed(0)}',
            summary.cashFlowType,
            AppColors.primary,
            Icons.account_balance_wallet_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDistribution(
      BuildContext context, List<PaymentDistributionData> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.textDark.withOpacity(0.05),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Download
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Mode Distribution',
                  style: TextConstants.subHeadingStyle,
                ),
                IconButton(
                  onPressed: () {
                    Fluttertoast.showToast(
                        msg: 'Download report coming soon');
                  },
                  icon: const Icon(
                    Icons.download,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Handle empty data safely
            if (data.isEmpty)
              SizedBox(
                height: 120,
                child: Center(
                  child: Text(
                    "No payment data available",
                    style: TextConstants.smallTextStyle,
                  ),
                ),
              )
            else
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: data.map((item) {
                      return PieChartSectionData(
                        color: item.color,
                        value: item.percentage,
                        title: '${item.percentage.toInt()}%',
                        radius: 50,
                        titleStyle:
                        TextConstants.smallTextStyle.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        badgeWidget: Text(
                          item.category,
                          style: TextConstants.smallTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
    );
  }

  // ============================================================
  // MILK TAB
  // ============================================================

  Widget _buildMilkSummaryCards(
      BuildContext context, ReportSummary summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          _buildReportSummaryCard(
            context,
            'Total Intake',
            '${summary.totalSales.toStringAsFixed(0)} L',
            summary.salesPeriod,
            AppColors.primaryGreen,
            Icons.local_drink_outlined,
          ),
          const SizedBox(width: 15),
          _buildReportSummaryCard(
            context,
            'Distributed',
            '${summary.cashFlow.toStringAsFixed(0)} L',
            summary.cashFlowType,
            AppColors.primary,
            Icons.timeline,
          ),
        ],
      ),
    );
  }

  Widget _buildMilkDistributionChart(
      BuildContext context, List<PaymentDistributionData> data) {

    // ✅ CREATE SEPARATE DATA FOR MILK DISTRIBUTION
    final List<MilkDistributionData> milkData = [
      MilkDistributionData(
        category: 'Distributed',
        liters: 425,
        color: AppColors.primaryGreen,
      ),
      MilkDistributionData(
        category: 'Returned',
        liters: 75,
        color: Colors.orange,
      ),
    ];



    // Calculate percentages
    final totalLiters = milkData.fold<double>(0, (sum, item) => sum + item.liters);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.textDark.withOpacity(0.05),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Milk Distribution vs Returns',
              style: TextConstants.subHeadingStyle,
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: milkData.map((item) {
                    final percentage = (item.liters / totalLiters) * 100;

                    return PieChartSectionData(
                      color: item.color,
                      value: item.liters,
                      title: '${percentage.toStringAsFixed(0)}%',
                      radius: 70,
                      titleStyle: TextConstants.smallTextStyle.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      badgeWidget: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          '${item.category}: ${item.liters.toStringAsFixed(0)}L',
                          style: TextConstants.smallTextStyle.copyWith(
                            color: item.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      badgePositionPercentageOffset:
                      item.category == 'Distributed' ? 1.4 : 1.4,
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  startDegreeOffset: 270,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ ADD LEGEND
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: milkData.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 50,
                        decoration: BoxDecoration(
                          color: item.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.category,
                        style: TextConstants.smallTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }



  // ============================================================
  // SHIFT TAB  (simple version)
  // ============================================================

  Widget _buildShiftSummaryCard(
      BuildContext context, ReportSummary summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.textDark.withOpacity(0.05),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today’s Shift",
                    style: TextConstants.subHeadingStyle.copyWith(
                      fontSize: 14,
                    )),
                const SizedBox(height: 4),
                Text(
                  "Morning • 06:00 AM - 10:00 AM",
                  style: TextConstants.smallTextStyle,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${summary.totalSales.toStringAsFixed(0)}",
                  style: TextConstants.headingStyle.copyWith(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Total Collection",
                  style: TextConstants.smallTextStyle.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShiftDetailsList(
      BuildContext context, ReportController controller) {
    // If you have some shift-wise list in controller, use that here.
    // For now, we show a static example.
    final items = controller.shiftDetails; // make sure this is List or []

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text("No shift details yet"),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: items.map((shift) {
          return Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(shift.title),
                Text(
                  "₹${shift.amount}",
                  style: TextConstants.bodyStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
