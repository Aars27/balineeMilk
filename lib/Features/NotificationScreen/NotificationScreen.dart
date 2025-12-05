// lib/Features/ViewScreens/NotificationScreen/NotificationScreen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../Core/Constant/app_colors.dart';
import '../../../Core/Constant/text_constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: Stack(
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

          // Main Content
          CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                floating: true,
                pinned: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.textDark),
                  onPressed: () {

                   context.go('/bottombar');
                  }

                ),
                title: Text(
                  'Notifications',
                  style: TextConstants.headingStyle.copyWith(fontSize: 20),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Mark all as read functionality
                    },
                    child: Text(
                      'Mark all read',
                      style: TextConstants.smallTextStyle.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              // Notifications List
              SliverPadding(
                padding: const EdgeInsets.only(top: 20, bottom: 80),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionHeader('Today'),
                    _buildNotificationCard(
                      icon: Icons.payments_outlined,
                      iconColor: AppColors.primaryGreen,
                      iconBg: AppColors.primaryGreen.withOpacity(0.1),
                      title: 'Payment Received',
                      description: 'You received ₹2,500 from Rajesh Kumar',
                      time: '10 mins ago',
                      isUnread: true,
                    ),
                    _buildNotificationCard(
                      icon: Icons.local_shipping_outlined,
                      iconColor: AppColors.primary,
                      iconBg: AppColors.primary.withOpacity(0.1),
                      title: 'Delivery Completed',
                      description: 'Morning shift delivery completed successfully',
                      time: '2 hours ago',
                      isUnread: true,
                    ),
                    _buildNotificationCard(
                      icon: Icons.inventory_2_outlined,
                      iconColor: Colors.orange,
                      iconBg: Colors.orange.withOpacity(0.1),
                      title: 'Low Stock Alert',
                      description: 'Milk stock is running low. Current: 50L',
                      time: '3 hours ago',
                      isUnread: true,
                    ),

                    _buildSectionHeader('Yesterday'),
                    _buildNotificationCard(
                      icon: Icons.person_add_outlined,
                      iconColor: Colors.blue,
                      iconBg: Colors.blue.withOpacity(0.1),
                      title: 'New Customer',
                      description: 'Priya Sharma added as new customer',
                      time: 'Yesterday, 6:30 PM',
                      isUnread: false,
                    ),
                    _buildNotificationCard(
                      icon: Icons.receipt_long_outlined,
                      iconColor: AppColors.primaryGreen,
                      iconBg: AppColors.primaryGreen.withOpacity(0.1),
                      title: 'Bill Generated',
                      description: 'Monthly bill for 15 customers generated',
                      time: 'Yesterday, 5:00 PM',
                      isUnread: false,
                    ),
                    _buildNotificationCard(
                      icon: Icons.schedule_outlined,
                      iconColor: Colors.purple,
                      iconBg: Colors.purple.withOpacity(0.1),
                      title: 'Shift Reminder',
                      description: 'Evening shift starts in 1 hour',
                      time: 'Yesterday, 4:45 PM',
                      isUnread: false,
                    ),

                    _buildSectionHeader('This Week'),
                    _buildNotificationCard(
                      icon: Icons.trending_up_outlined,
                      iconColor: AppColors.primaryGreen,
                      iconBg: AppColors.primaryGreen.withOpacity(0.1),
                      title: 'Sales Milestone',
                      description: 'Congratulations! You reached ₹50k sales',
                      time: '2 days ago',
                      isUnread: false,
                    ),
                    _buildNotificationCard(
                      icon: Icons.warning_amber_outlined,
                      iconColor: Colors.red,
                      iconBg: Colors.red.withOpacity(0.1),
                      title: 'Payment Overdue',
                      description: '3 customers have pending payments',
                      time: '3 days ago',
                      isUnread: false,
                    ),
                    _buildNotificationCard(
                      icon: Icons.celebration_outlined,
                      iconColor: Colors.amber,
                      iconBg: Colors.amber.withOpacity(0.1),
                      title: 'Monthly Report Ready',
                      description: 'Your November report is ready to view',
                      time: '5 days ago',
                      isUnread: false,
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: TextConstants.subHeadingStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String description,
    required String time,
    required bool isUnread,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.white
              : AppColors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnread
                ? AppColors.primary.withOpacity(0.2)
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textDark.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextConstants.bodyStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              if (isUnread)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                description,
                style: TextConstants.smallTextStyle.copyWith(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextConstants.smallTextStyle.copyWith(
                  color: Colors.grey[400],
                  fontSize: 11,
                ),
              ),
            ],
          ),
          onTap: () {
            // Handle notification tap
          },
        ),
      ),
    );
  }
}