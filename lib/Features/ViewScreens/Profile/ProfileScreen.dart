import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'ProfileController/ProfileController.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  // --- Constants ---
  // Using the exact colors from the image
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color lightCardYellow = Color(0xFFFFFBE5);
  static const Color lightCardGreen = Color(0xFFE8F5E9);
  static const Color lightCardPurple = Color(0xFFF3E5F5);
  static const Color lightCardBlue = Color(0xFFE3F2FD);
  static const Color darkTextColor = Color(0xFF333333);

  // NOTE: Ensure this path matches where you placed the uploaded image.
  static const String waveImagePath = 'assets/vector.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFFF7F7F7), // Screen background

      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. Header Section (Uses Image.asset) ---
            _buildHeader(context),

            _buildStatsSection(context),

            // --- 3. Contact Information Section ---
            _buildSectionTitle("Contact Information"),
            _buildContactInfoSection(context),

            // --- 5. Navigation Items ---
            _buildNavigationItems(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildHeader(BuildContext context) {
    // Note: 'listen: false' as we only need to read the initial data
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final partner = provider.partner;
    final topPadding = MediaQuery.of(context).padding.top;
    const double headerHeight = 280.0;

    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFF9800),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 1. IMAGE BACKGROUND LAYER (The orange wave)
            Positioned.fill(
              bottom: 80,
              child: Image.asset(
                waveImagePath, // *** Check your assets path! ***
                fit: BoxFit.fill,
              // width: 40,

              ),
            ),

            // 2. Profile Info and Top Bar Items (Layered on top of the image)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Top Bar Content (Greeting, Date, Icons)
                  Padding(
                    padding: EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Good Morning", style: TextStyle(color: Colors.black, fontSize: 14)),
                            Text("Delivery Partner Home", style: TextStyle(color: Colors.black, fontSize: 10)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.wb_sunny, color: Colors.white, size: 20),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ],
                    ),
                  ),
SizedBox(
  height: 50,
),
                  // Profile Picture & Details
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(partner.name.substring(0, 2),
                        style: const TextStyle(fontSize: 20, color: primaryOrange, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Text(partner.name,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(partner.partnerId,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 14)),
                  const Chip(
                    label: Text("Active Partner",
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStatsSection(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final partner = provider.partner;

    return Transform.translate(
      offset: const Offset(0, -60),
      child: Padding(
        padding: const EdgeInsets.only(right: 20,left: 20,top: 80),
        child: Row(
          children: [
            _buildStatCard("Total Deliveries", partner.totalDeliveries.toString(), lightCardYellow, primaryOrange),
            const SizedBox(width: 15),
            _buildStatCard("Rating", partner.rating.toString(), lightCardGreen, const Color(0xFF4CAF50), isRating: true),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color bgColor, Color primaryColor, {bool isRating = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), spreadRadius: 1, blurRadius: 8)],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                if (isRating) const Icon(Icons.star, color: Color(0xFF4CAF50), size: 24),
              ],
            ),
            const SizedBox(height: 5),
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool showIcon = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            if (showIcon)
              const Icon(Icons.settings, color: darkTextColor, size: 20),
            if (showIcon) const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkTextColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoSection(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final partner = provider.partner;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _buildInfoTile(Icons.phone, "Mobile Number", partner.mobileNumber, lightCardGreen.withOpacity(0.7), const Color(0xFF4CAF50)),
          _buildInfoTile(Icons.email, "Email Address", partner.emailAddress, primaryOrange.withOpacity(0.1), primaryOrange),
          _buildInfoTile(Icons.location_on, "Assigned Zone", partner.assignedZone, lightCardPurple, const Color(0xFF9C27B0)),
          _buildInfoTile(Icons.calendar_today, "Joined On", DateFormat.yMMMM().format(partner.joinedDate), lightCardBlue, const Color(0xFF2196F3), isLast: true),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle, Color bgColor, Color iconColor, {bool isLast = false}) {
    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1))),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 16, color: darkTextColor, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.transparent),
      ),
    );
  }



  Widget _buildNavigationItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        children: [
          // _buildNavItem(Icons.history, "Route History", primaryOrange.withOpacity(0.1), primaryOrange),
          _buildNavItem(Icons.edit, "Edit Profile", primaryOrange.withOpacity(0.1), primaryOrange),
          _buildNavItem(Icons.help_outline, "Help & Support", primaryOrange.withOpacity(0.1), primaryOrange),
          _buildNavItem(
              Icons.logout,
              "Logout",
              const Color(0xFFFFEBEE),
              const Color(0xFFE53935),
              isLogout: true,
              isLast: true,
              onTap: () => Provider.of<ProfileProvider>(context, listen: false).logout()
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, Color bgColor, Color iconColor, {bool isLogout = false, bool isLast = false, VoidCallback? onTap}) {
    final textColor = isLogout ? iconColor : darkTextColor;
    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1))),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
        trailing: Icon(Icons.keyboard_arrow_right, color: isLogout ? Colors.transparent : Colors.grey.shade400),
      ),
    );
  }
}