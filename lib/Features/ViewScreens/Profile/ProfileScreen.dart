import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Components/Providers/UserInfoProviders.dart';
import '../../../Components/Savetoken/SaveToken.dart';
import '../../../Core/Constant/text_constants.dart';
import 'EditProfile/EditProfilepage.dart';
import 'Help&Support/HelpSupport.dart';
import 'ProfileController/ProfileController.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color lightCardYellow = Color(0xFFFFFBE5);
  static const Color lightCardGreen = Color(0xFFE8F5E9);
  static const Color lightCardPurple = Color(0xFFF3E5F5);
  static const Color lightCardBlue = Color(0xFFE3F2FD);
  static const Color darkTextColor = Color(0xFF333333);
  static const String waveImagePath = 'assets/vector.png';
  static const double headerHeight = 280.0;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ Load user info when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
      userInfoProvider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildStatsSection(context),
              _buildSectionTitle("Contact Information"),
              _buildContactInfoSection(context),
              _buildSectionTitle("Settings", showIcon: true),
              _buildNavigationItems(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final partner = provider.partner;

    //  Get User Info Provider
    final userInfo = Provider.of<UserInfoProvider>(context);

    final topPadding = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: ProfileScreen.headerHeight,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Background Wave
            Positioned.fill(
              bottom: ProfileScreen.headerHeight / 3,
              child: Image.asset(
                ProfileScreen.waveImagePath,
                fit: BoxFit.fill,
              ),
            ),

            // ✅ Top Bar with Dynamic User Info
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //  Dynamic User Name
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
                              Icon(Icons.location_on, color: Colors.red, size: 16),
                              SizedBox(width: 4),
                              // Dynamic Location
                              Expanded(
                                child: Text(
                                  userInfo.isLoadingLocation
                                      ? "Detecting..."
                                      : userInfo.getLocationOnly(),
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.notifications_none_sharp, color: Colors.black, size: 24),
                  ],
                ),
              ),
            ),

            // Profile Picture & Details
            Positioned(
              top: topPadding + 80,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Text(
                      _getInitials(userInfo.getFullName()),
                      style: const TextStyle(
                        fontSize: 22,
                        color: ProfileScreen.primaryOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userInfo.getFullName(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    partner.partnerId,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Chip(
                    label: Text(
                      "Active Partner",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
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

  //  Helper: Get Initials from Name
  String _getInitials(String name) {
    if (name.isEmpty) return "GU";
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0].substring(0, 2).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Widget _buildStatsSection(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final partner = provider.partner;

    return Transform.translate(
      offset: const Offset(0, -50),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
        child: Row(
          children: [
            _buildStatCard(
              "Total Deliveries",
              partner.totalDeliveries.toString(),
              ProfileScreen.lightCardYellow,
              ProfileScreen.primaryOrange,
            ),
            const SizedBox(width: 15),
            _buildStatCard(
              "Rating",
              partner.rating.toStringAsFixed(1),
              ProfileScreen.lightCardGreen,
              const Color(0xFF4CAF50),
              isRating: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color bgColor, Color primaryColor, {bool isRating = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                if (isRating) const Icon(Icons.star, color: Color(0xFF4CAF50), size: 24),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
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
            if (showIcon) const Icon(Icons.settings, color: ProfileScreen.darkTextColor, size: 20),
            if (showIcon) const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ProfileScreen.darkTextColor,
              ),
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
          _buildInfoTile(
            Icons.phone,
            "Mobile Number",
            partner.mobileNumber,
            ProfileScreen.lightCardGreen.withOpacity(0.7),
            const Color(0xFF4CAF50),
          ),
          _buildInfoTile(
            Icons.email,
            "Email Address",
            partner.emailAddress,
            ProfileScreen.primaryOrange.withOpacity(0.1),
            ProfileScreen.primaryOrange,
          ),
          _buildInfoTile(
            Icons.location_on,
            "Assigned Zone",
            partner.assignedZone,
            ProfileScreen.lightCardPurple,
            const Color(0xFF9C27B0),
          ),
          _buildInfoTile(
            Icons.calendar_today,
            "Joined On",
            DateFormat.yMMMMd().format(partner.joinedDate),
            ProfileScreen.lightCardBlue,
            const Color(0xFF2196F3),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle, Color bgColor, Color iconColor, {bool isLast = false}) {
    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
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
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: ProfileScreen.darkTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _buildNavItem(
            Icons.edit,
            "Edit Profile",
            ProfileScreen.primaryOrange.withOpacity(0.1),
            ProfileScreen.primaryOrange,
            onTap: () {
              // Navigate to Edit Profile
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Ed()),
              // );
            },
          ),
          _buildNavItem(
            Icons.help_outline,
            "Help & Support",
            ProfileScreen.primaryOrange.withOpacity(0.1),
            ProfileScreen.primaryOrange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpAndSupportPage()),
              );
            },
          ),
          _buildNavItem(
            Icons.logout,
            "Logout",
            const Color(0xFFFFEBEE),
            const Color(0xFFE53935),
            isLogout: true,
            isLast: true,
            onTap: () {
              Provider.of<ProfileProvider>(context, listen: false).logout(context);
              // ✅ Clear user info on logout
              Provider.of<UserInfoProvider>(context, listen: false).clearData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, Color bgColor, Color iconColor, {bool isLogout = false, bool isLast = false, VoidCallback? onTap}) {
    final textColor = isLogout ? iconColor : ProfileScreen.darkTextColor;
    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
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
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: isLogout ? Colors.transparent : Colors.grey.shade400,
        ),
      ),
    );
  }
}