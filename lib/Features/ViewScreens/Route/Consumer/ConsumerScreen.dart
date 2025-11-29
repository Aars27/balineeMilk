import 'package:flutter/material.dart';

import '../../../../Core/Constant/app_colors.dart';
import '../../../../Core/Constant/text_constants.dart';
import 'ConsumerModal.dart';



class ConsumerScreenWidget extends StatelessWidget {
  const ConsumerScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Assigned Consumers",
                  style: TextConstants.subHeadingStyle.copyWith(fontSize: 16) // Assuming subHeadingStyle is available
              ),
              Text(
                  "(Manage your daily deliveries)",
                  style: TextConstants.smallTextStyle // Assuming smallTextStyle is available
              ),
              const SizedBox(height: 15),

              // Search Bar and Filter (Row)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.textLight.withOpacity(0.3)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.search, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          // Search Input Field
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search by name or mobile no.',
                                hintStyle: TextConstants.smallTextStyle,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(bottom: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Filter Button
                  // Container(
                  //   height: 40,
                  //   padding: const EdgeInsets.symmetric(horizontal: 12),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.white,
                  //     borderRadius: BorderRadius.circular(10),
                  //     border: Border.all(color: AppColors.textLight.withOpacity(0.3)),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Text('All', style: TextConstants.bodyStyle.copyWith(fontWeight: FontWeight.w600)),
                  //       const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.textDark),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),

        // Consumer List (Using ListView.builder for performance)
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Important to scroll with the parent CustomScrollView
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          itemCount: dummyConsumers.length,
          itemBuilder: (context, index) {
            final consumer = dummyConsumers[index];
            return _buildConsumerItem(consumer);
          },
        ),

        const SizedBox(height: 80), // Final spacing
      ],
    );
  }

  // Helper Widget for a single consumer item
  Widget _buildConsumerItem(ConsumerModel consumer) {
    final bool isDelivered = consumer.status == 'Delivered';
    final Color statusColor = isDelivered ? AppColors.primaryGreen : AppColors.accentRed.withOpacity(0.6);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground, // Light background for the list item
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: AppColors.textDark.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Initials, Name, Details
          Row(
            children: [
              // Initials Circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary, // Placeholder color
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  consumer.initials,
                  style: TextConstants.headingStyle.copyWith(color: AppColors.white, fontSize: 16),
                ),
              ),
              const SizedBox(width: 10),
              // Name and Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(consumer.name, style: TextConstants.bodyStyle.copyWith(fontWeight: FontWeight.w600)),
                  Text(consumer.time, style: TextConstants.smallTextStyle),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Retailer Tag
                      _buildTag(consumer.type, Colors.pink.shade100, Colors.pink.shade800),
                      const SizedBox(width: 8),
                      // Quantity Tag
                      _buildTag(consumer.quantity, Colors.lightGreen.shade100, AppColors.primaryGreen),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Right Side: Call, Chat, Status
          Row(
            children: [
              // Call Icon
              Icon(Icons.call, color: AppColors.accentRed, size: 22),
              const SizedBox(width: 10),
              // Status Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDelivered ? AppColors.primaryGreen.withOpacity(0.2) : Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  consumer.status,
                  style: TextConstants.smallTextStyle.copyWith(
                    color: isDelivered ? AppColors.primaryGreen : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widget for small tags
  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextConstants.smallTextStyle.copyWith(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}