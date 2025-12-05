import 'package:balineemilk/Features/ViewScreens/DashBoardScreen/DashboardController/DashboardController.dart';
import 'package:balineemilk/Features/ViewScreens/PaymentScreen/PaymentController/PaymentController.dart';
import 'package:balineemilk/Features/ViewScreens/ReportScreen/ReportController/ReportController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Core/Router/router.dart';
import '../../Features/ViewScreens/LoginScreen/loginController/LoginController.dart';
import '../../Features/ViewScreens/Profile/ProfileController/ProfileController.dart';
import '../../Features/ViewScreens/Route/Consumer/Consumer_provider.dart';
import '../../Features/ViewScreens/Route/Distribution/DistributionController.dart';
import '../../Features/ViewScreens/Route/MainRoutesView/Controllers/RoutesController.dart';
import '../Location/Location.dart';
import '../../Features/ViewScreens/LoginScreen/Providers/LoginProviders.dart';
import '../../Features/ViewScreens/SplashScreen/SplashController/Splash_provider.dart';
import 'UserInfoProviders.dart';

class Mainproviders extends StatelessWidget {
  const Mainproviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => RouteController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),
        ChangeNotifierProvider(create: (_) => ReportController()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ConsumerProvider()),
        ChangeNotifierProvider(create: (_) => MilkController()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => UserInfoProvider()..initialize()),
      ],
      child: MaterialApp.router(
        title: 'BalineeMilk',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter,
      ),
    );
  }
}
