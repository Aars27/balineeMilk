import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Core/Constant/app_colors.dart';
import '../../../../Core/Constant/text_constants.dart';
import 'Consumer_provider.dart';

class ConsumerScreenWidget extends StatefulWidget {
  const ConsumerScreenWidget({super.key});

  @override
  State<ConsumerScreenWidget> createState() => _ConsumerScreenWidgetState();
}

class _ConsumerScreenWidgetState extends State<ConsumerScreenWidget> {

  // Function to make phone call
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
      print('Error launching dialer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConsumerProvider>(
      builder: (context, provider, child) {
        return Column(
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
                    style: TextConstants.subHeadingStyle.copyWith(fontSize: 16),
                  ),
                  Text(
                    "(Manage your daily deliveries)",
                    style: TextConstants.smallTextStyle,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

            // Loading State
            if (provider.loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              )

            // Error State
            else if (provider.errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 10),
                      Text(
                        "Failed to load consumers",
                        style: TextConstants.bodyStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )

            // Empty State
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

              // Data List - FIXED: Removed shrinkWrap & NeverScrollableScrollPhysics
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: provider.consumers
                        .map((consumer) => _buildConsumerItem(consumer))
                        .toList(),
                  ),
                ),

            const SizedBox(height: 50),
          ],
        );
      },
    );
  }

  Widget _buildConsumerItem(consumer) {
    final bool isDelivered = consumer.status.toLowerCase() == "delivered";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
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

          // MIDDLE - Consumer Details
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

                // Product Tags
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

          // RIGHT - Call Button & Status
          Column(
            children: [
              // Call Icon Button
              InkWell(
                onTap: () {
                  // Add phone number to your ConsumerModel if not present
                  // For now using a placeholder
                  final phoneNumber = consumer.phoneNumber ?? "";
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
                  child: Icon(
                    Icons.phone,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDelivered
                      ? AppColors.primaryGreen.withOpacity(0.15)
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  consumer.status,
                  style: TextConstants.smallTextStyle.copyWith(
                    color: isDelivered ? AppColors.primaryGreen : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
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
}