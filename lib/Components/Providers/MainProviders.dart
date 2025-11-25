import 'package:balineemilk/Features/ViewScreens/DashBoardScreen/DashboardController/DashboardController.dart';
import 'package:balineemilk/Features/ViewScreens/PaymentScreen/PaymentController/PaymentController.dart';
import 'package:balineemilk/Features/ViewScreens/ReportScreen/ReportController/ReportController.dart';
import 'package:balineemilk/Features/ViewScreens/Route/MapView/Controllers/RoutesController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Core/Router/router.dart';
import '../../Features/ViewScreens/LoginScreen/loginController/LoginController.dart';
import 'LoginProviders.dart';
import 'Splash_provider.dart';

class Mainproviders extends StatelessWidget {
  const Mainproviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => LoginController(context)),
        ChangeNotifierProvider(create: (_)=>DashboardController()),
        ChangeNotifierProvider(create: (_)=>RouteController()),
        ChangeNotifierProvider(create: (_)=>PaymentController()),
        ChangeNotifierProvider(create: (_)=>ReportController())
      ],
      child: MaterialApp.router(
        title: 'BalineeMilk',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter,
      ),
    );
  }
}
