import 'package:balineemilk/Core/Constant/app_colors.dart';
import 'package:balineemilk/Features/ViewScreens/ReportScreen/RportsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewScreens/PaymentScreen/PaymentScreen.dart';
import '../ViewScreens/Route/MapView/Routes.dart';
import 'MainNavigator.dart';
import '../ViewScreens/DashBoardScreen/DashBoardScreen.dart';




class MainWrapperScreen extends StatelessWidget {
  MainWrapperScreen({super.key});

  final List<Widget> _screens =  [
    HomeScreen(),
    RouteTrackingScreen(),
    PaymentManagementScreen(),
    ReportScreen(),
    HomeScreen()


  ];

  @override
  Widget build(BuildContext context) {
    // Provide the controller for the navigation state
    return ChangeNotifierProvider(
      create: (_) => MainNavigationController(),
      child: Consumer<MainNavigationController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            // Display the current screen based on the controller's state
            body: _screens[controller.currentIndex],

            // Use the updated bottom navigation bar
            bottomNavigationBar: _buildBottomNavBar(context, controller),
          );
        },
      ),
    );
  }

  // Updated _buildBottomNavBar function
  Widget _buildBottomNavBar(BuildContext context, MainNavigationController controller) {
    return SizedBox(
      height: 60,
      child: BottomNavigationBar(
        backgroundColor: AppColors.primary,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        showUnselectedLabels: true,

        // Get the current index from the controller
        currentIndex: controller.currentIndex,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Route'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payment'),
          BottomNavigationBarItem(icon: Icon(Icons.note_outlined), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.production_quantity_limits_sharp), label: 'Product'),
        ],

        // Call the controller's method on tap
        onTap: (index) {
          controller.setIndex(index);
        },
      ),
    );
  }
}