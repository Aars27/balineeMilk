import 'package:balineemilk/Features/ViewScreens/Route/Consumer/ConsumerController.dart';
import 'package:flutter/material.dart';



class DeliveryItemCard extends StatelessWidget {
  final Delivery delivery;

  const DeliveryItemCard({super.key, required this.delivery});

  @override
  Widget build(BuildContext context) {
    // स्क्रीनशॉट से रंग (लगभग)
    const primaryRed = Color(0xFFEF5350);
    const deliveredGreen = Color(0xFF8BC34A);
    const pendingBrown = Color(0xFFD7CCC8);
    const tagColor = Color(0xFFF4F4F4);

    final statusColor = delivery.status == DeliveryStatus.delivered
        ? deliveredGreen
        : pendingBrown;
    final statusText = delivery.status == DeliveryStatus.delivered
        ? 'Delivered'
        : 'Pending';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Initials Circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryRed,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                delivery.initials,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            // Name and Tags
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    delivery.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    delivery.time,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildTag(delivery.type, primaryRed.withOpacity(0.1)),
                      const SizedBox(width: 8),
                      _buildTag(delivery.frequency, deliveredGreen.withOpacity(0.1)),
                    ],
                  ),
                ],
              ),
            ),
            // Actions and Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    // Call Icon
                    Icon(Icons.call, color: primaryRed.withOpacity(0.8), size: 24),
                    const SizedBox(width: 10),
                    // Chat Icon
                    Icon(Icons.chat_bubble_outline, color: primaryRed.withOpacity(0.8), size: 24),
                  ],
                ),
                const SizedBox(height: 10),
                // Status Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
      ),
    );
  }
}