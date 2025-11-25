// lib/Widgets/AddPaymentDialog.dart (New File)

import 'package:flutter/material.dart';
import '../../Core/Constant/app_colors.dart'; // Ensure these are defined
import '../../Core/Constant/text_constants.dart'; // Ensure these are defined


// A simple data structure for payment methods
class PaymentMethod {
  final String title;
  final IconData icon;
  final Color color;

  PaymentMethod({required this.title, required this.icon, required this.color});
}

// Global list of payment methods
final List<PaymentMethod> paymentMethods = [
  PaymentMethod(title: 'UPI', icon: Icons.qr_code_scanner, color: const Color(0xFF8B42F5)), // Custom Purple
  PaymentMethod(title: 'Card', icon: Icons.credit_card, color: Colors.blue),
  PaymentMethod(title: 'Cash', icon: Icons.money, color: Colors.green),
  PaymentMethod(title: 'Wallet', icon: Icons.phone_android, color: Colors.deepOrange),
];


void showAddPaymentDialog(BuildContext context) {
  // Simple state management for the selected payment method and amount
  String selectedMethod = paymentMethods.first.title;
  TextEditingController amountController = TextEditingController(text: '0.00');

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Title ---
                  Text(
                    'Payment',
                    style: TextConstants.headingStyle.copyWith(color: AppColors.accentRed, fontSize: 20),
                  ),
                  const SizedBox(height: 20),

                  // --- Enter Amount Section ---
                  Text('Enter Amount', style: TextConstants.bodyStyle.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),


                  // Amount Input Field
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground, // Light gray background
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.currency_rupee, size: 20, color: AppColors.textDark.withOpacity(0.7)),
                        hintText: '0.00',
                        hintStyle: TextConstants.subHeadingStyle.copyWith(color: AppColors.textDark.withOpacity(0.7)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      style: TextConstants.subHeadingStyle,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Quick Amount Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickAmountButton(context, 100.0, amountController, setState),
                      _buildQuickAmountButton(context, 200.0, amountController, setState),
                      _buildQuickAmountButton(context, 500.0, amountController, setState),
                      _buildQuickAmountButton(context, 1000.0, amountController, setState),
                    ],
                  ),
                  // const SizedBox(height: 30),

                  // --- Select Payment Method Section ---
                  Text('Select Payment Method', style: TextConstants.bodyStyle.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),

                  // Payment Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: paymentMethods.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final method = paymentMethods[index];
                      return _buildPaymentMethodCard(
                        method: method,
                        isSelected: selectedMethod == method.title,
                        onTap: () {
                          setState(() {
                            selectedMethod = method.title;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // --- Pay Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement payment logic here
                        Navigator.of(dialogContext).pop(); // Close dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(80, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                      ),
                      child: Text('Pay', style: TextConstants.subHeadingStyle.copyWith(color: AppColors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


// --- Helper Widgets for the Dialog ---

Widget _buildQuickAmountButton(BuildContext context, double amount, TextEditingController controller, StateSetter setState) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            controller.text = amount.toStringAsFixed(2);
          });
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.cardBackground),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextConstants.bodyStyle.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}

Widget _buildPaymentMethodCard({
  required PaymentMethod method,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.cardBackground,
          width: isSelected ? 3 : 1,
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(method.icon, color: method.color, size: 28),
          const SizedBox(height: 5),
          Text(method.title, style: TextConstants.smallTextStyle.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    ),
  );
}