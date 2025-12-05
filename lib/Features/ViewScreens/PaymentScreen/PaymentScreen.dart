
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Components/Providers/UserInfoProviders.dart';
import '../../../Core/Constant/app_colors.dart';
import '../../../Core/Constant/text_constants.dart';

import '../../../Core/PaymentScreenMode/PaymentScreen.dart';
import 'PaymentController/PaymentController.dart';
import 'PaymentController/PaymentModel.dart';



class PaymentManagementScreen extends StatelessWidget {
  const PaymentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: Consumer<PaymentController>(
        builder: (context, controller, child) {
          if (controller.isLoading || controller.summary == null) {
            return const Center(child: CircularProgressIndicator());
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

                        // Payment Summary Cards
                        _buildSummaryCards(context, controller.summary!),

                        // Search and Filter Bar
                        _buildSearchAndFilter(context, controller),

                        // Payment List
                        ...controller.filteredPayments.map((p) => _buildPaymentItemCard(context, p)).toList(),

                        const SizedBox(height: 80), // Space for bottom navigation
                      ],
                    ),
                  ),
                ],
              ),

              // 3. Bottom Navigation Bar
            ],
          );
        },
      ),
    );
  }

  // --- Widget Builders ---

  // Reusing components from the Dashboard
  Widget _buildHeader(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);

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
                    userInfo.isLoadingUser
                        ? "Loading..."
                        : "${userInfo.getFullName()}!",
                    style: TextConstants.smallTextStyle.copyWith(fontSize:20,fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on,color: Colors.red,size: 14,),
                      Text(
                        userInfo.isLoadingLocation
                            ? "Detecting..."
                            : userInfo.getLocationOnly(),
                        style: TextConstants.smallTextStyle.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              _buildHeaderIcon(Icons.notifications, null),
            ],
          ),
          const SizedBox(height: 80),
          Text("Payment Management", style: TextConstants.headingStyle.copyWith(fontSize: 18)),
          Text("Track and manage payments", style: TextConstants.bodyStyle.copyWith(fontSize: 12)),
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

  // FIX: Add BuildContext context to the signature
  Widget _buildSummaryCards(BuildContext context, PaymentSummary summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Pending Card (Red)
          _buildSummaryItem(
              context, // <-- Now passing the correct context
              'Pending',
              '₹${summary.pending.toStringAsFixed(1)}k',
              AppColors.accentRed,
              Icons.access_time
          ),
          // Received Card (Green)
          _buildSummaryItem(
              context, // <-- Now passing the correct context
              'Received',
              '₹${summary.received.toStringAsFixed(1)}k',
              Colors.green,
              Icons.check_circle_outline
          ),
          // Advance Card (Blue)
          _buildSummaryItem(
              context, // <-- Now passing the correct context
              'Advance',
              '₹${summary.advance.toStringAsFixed(1)}k',
              Colors.blue,
              Icons.trending_up
          ),
        ],
      ),
    );
  }



  Widget _buildSummaryItem(BuildContext context, String title, String value, Color color, IconData icon) {
    return Container(
      // FIX: Use the passed context
      width: MediaQuery.of(context).size.width / 3.7, // Distributes space evenly
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        // gradient: LinearGradient(
        //     colors:[
        //       AppColors.advanceColor,
        //       AppColors.advanceboxColor
        //     ],
        //     end: Alignment.topCenter,
        //     begin: Alignment.bottomCenter
        // ),

        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.white, size: 24),
          const SizedBox(height: 5),
          Text(title, style: TextConstants.smallTextStyle.copyWith(color: AppColors.white)),
          Text(value, style: TextConstants.subHeadingStyle.copyWith(color: AppColors.white, fontSize: 18)),
        ],
      ),
    );
  }





  Widget _buildSearchAndFilter(BuildContext context, PaymentController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBackground)
              ),
              child: TextField(
                onChanged: controller.setSearchText,
                decoration: InputDecoration(
                  hintText: 'Search by name or mobile no.',
                  hintStyle: TextConstants.smallTextStyle,
                  prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textLight),
                  suffixIcon: const Icon(Icons.close, size: 20, color: AppColors.textLight),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  border: InputBorder.none,
                ),
                style: TextConstants.bodyStyle,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Filter Dropdown
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.cardBackground)
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.filterType,
                icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textDark),
                style: TextConstants.bodyStyle.copyWith(color: AppColors.textDark),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.setFilterType(newValue);
                  }
                },
                items: <String>['All', 'Pending', 'Received', 'Advance']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItemCard(BuildContext context, CustomerPayment payment) {
    final statusColor = payment.status == 'Pending' ? AppColors.accentRed : Colors.green;
    final advanceRow = payment.advanceBalance != null
        ? _buildInfoRow('Advance Balance', '₹${payment.advanceBalance!.toStringAsFixed(0)}', null)
        : const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
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
          children: [
            // Top Row (Name, Time, Icons)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.accentRed,
                      child: Text(payment.initials, style: TextConstants.bodyStyle.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(payment.customerName, style: TextConstants.subHeadingStyle),
                        Text(payment.time, style: TextConstants.smallTextStyle
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Icon(Icons.call, color: AppColors.primary, size: 24),
                    SizedBox(width: 15),
                    Icon(Icons.warning_amber, color: AppColors.accentRed, size: 24),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Tags Row
            Row(
              children: [
                _buildTag(payment.type, AppColors.accentRed.withOpacity(0.1), AppColors.accentRed),
                const SizedBox(width: 8),
                _buildTag(payment.frequency, Colors.green.withOpacity(0.1), Colors.green),
                const SizedBox(width: 8),
                _buildTag(payment.status, statusColor.withOpacity(0.1), statusColor),
              ],
            ),
            const SizedBox(height: 15),

            // Payment Details
            _buildInfoRow('Pending Amount', '₹${payment.pendingAmount.toStringAsFixed(0)}', statusColor),
            _buildInfoRow('Total Received', '₹${payment.totalReceived.toStringAsFixed(0)}', AppColors.primary),
            advanceRow, // Advance Balance
            const SizedBox(height: 15),

            // Add Payment Button
            ElevatedButton(
              onPressed: () {
                showAddPaymentDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(200,35),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.credit_card, color: AppColors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('Add Payment', style: TextConstants.bodyStyle.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildTag(String text, Color background, Color foreground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(text, style: TextConstants.smallTextStyle.copyWith(color: foreground, fontWeight: FontWeight.w600)),
    );
  }


  Widget _buildInfoRow(String title, String value, Color? valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextConstants.bodyStyle.copyWith(fontSize: 12)
          ),
          Text(
              value,
              style: TextConstants.subHeadingStyle.copyWith(
                  color: valueColor ?? AppColors.textDark,
                  fontSize: 14
              )
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