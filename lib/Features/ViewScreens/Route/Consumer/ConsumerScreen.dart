import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Core/Constant/app_colors.dart';
import '../../../../Core/Constant/text_constants.dart';
import 'Consumer_provider.dart';
import 'ConsumerModal.dart';

class ConsumerScreenWidget extends StatefulWidget {
  const ConsumerScreenWidget({super.key});

  @override
  State<ConsumerScreenWidget> createState() => _ConsumerScreenWidgetState();
}

class _ConsumerScreenWidgetState extends State<ConsumerScreenWidget> {
  // Call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch phone dialer')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching dialer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConsumerProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Assigned Consumers",
                      style:
                      TextConstants.subHeadingStyle.copyWith(fontSize: 16),
                    ),
                    Text(
                      "(Manage your daily deliveries)",
                      style: TextConstants.smallTextStyle,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),

              // Loading
              if (provider.loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                )

              // Error
              else if (provider.errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 10),
                        Text(
                          provider.errorMessage!,
                          style: TextConstants.bodyStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )

              // Empty
              else if (provider.consumers.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "No consumers assigned",
                            style: TextConstants.bodyStyle.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                // List
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: provider.consumers
                          .map((consumer) => _buildConsumerItem(context, consumer))
                          .toList(),
                    ),
                  ),

              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConsumerItem(BuildContext context, ConsumerModel consumer) {
    final bool isDelivered =
        consumer.status.toLowerCase() == "delivered";

    return GestureDetector(
      onTap: () {
        // Card tap → open delivery dialog
        _showDeliveryDialog(context, consumer);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            // LEFT - Avatar
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                consumer.initials,
                style: TextConstants.headingStyle.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // MIDDLE - Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    consumer.customerName,
                    style: TextConstants.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    consumer.time,
                    style: TextConstants.smallTextStyle,
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      _buildTag(
                        consumer.productName,
                        Colors.pink.shade100,
                        Colors.pink.shade800,
                      ),
                      const SizedBox(width: 6),
                      _buildTag(
                        "${consumer.quantity}${consumer.unit}",
                        Colors.green.shade100,
                        AppColors.primaryGreen,
                      ),
                    ],
                  ),

                  const SizedBox(height: 3),
                  Text(
                    consumer.address,
                    style: TextConstants.smallTextStyle.copyWith(
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // RIGHT - Call + Status
            Column(
              children: [
                InkWell(
                  onTap: () {
                    final phoneNumber = consumer.mobileNo; // FIXED
                    if (phoneNumber.isNotEmpty) {
                      _makePhoneCall(phoneNumber);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Phone number not available'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.phone,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDelivered
                        ? AppColors.primaryGreen.withOpacity(0.15)
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    consumer.status,
                    style: TextConstants.smallTextStyle.copyWith(
                      color: isDelivered
                          ? AppColors.primaryGreen
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextConstants.smallTextStyle.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  // ---------------- DELIVERY DIALOG (UI + API CALL) ----------------
  void _showDeliveryDialog(BuildContext context, ConsumerModel consumer) {
    final provider = context.read<ConsumerProvider>();

    final TextEditingController qtyCtrl = TextEditingController();
    String payment = "cash";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Close
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Deliver to ${consumer.customerName}",
                      style: TextConstants.subHeadingStyle
                          .copyWith(fontSize: 15),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(dialogCtx),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  consumer.address,
                  style: TextConstants.smallTextStyle,
                ),
                const SizedBox(height: 8),

                // Product info
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_drink,
                          size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              consumer.productName,
                              style: TextConstants.bodyStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "Scheduled: ${consumer.quantity}${consumer.unit}",
                              style: TextConstants.smallTextStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Delivered quantity
                TextField(
                  controller: qtyCtrl,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: "Delivered Quantity (${consumer.unit})",
                    hintText: "Enter quantity e.g. 3.5",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Payment mode
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Payment Mode",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: payment,
                  items: const [
                    DropdownMenuItem(
                      value: "cash",
                      child: Text("Cash"),
                    ),
                    DropdownMenuItem(
                      value: "upi",
                      child: Text("UPI"),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      payment = v;
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogCtx),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        final qty = qtyCtrl.text.trim();

                        // Basic validation
                        if (qty.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter delivered quantity"),
                            ),
                          );
                          return;
                        }

                        // API hit
                        final msg = await provider.deliverOrder(
                          orderId: consumer.id,
                          deliveredQty: qty,
                          paymentMode: payment,
                        );

                        if (mounted) {
                          Navigator.pop(dialogCtx);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(msg)),
                          );
                        }

                        // UPI case: यहां Razorpay navigation कर सकते हो
                        // if (payment == "upi") {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) => RazorPayPage(),
                        //     ),
                        //   );
                        // }
                      },
                      child: const Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          "Confirm Delivery",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
