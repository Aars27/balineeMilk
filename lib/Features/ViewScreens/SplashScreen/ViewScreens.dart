import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../Components/Location/Location.dart';
import 'SplashController/Splash_provider.dart';
import '../../../Components/Savetoken/SaveToken.dart';
import '../../../Core/Constant/ApiServices.dart';
import '../../../Core/Constant/app_colors.dart';
import '../../../Core/Constant/text_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();  // ✅ Only one initialize function
    });
  }

  Future<void> _initialize() async {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    try {
      // ✅ API config fetch
      final api = ApiService();
      final data = await api.getData("config");
      splashProvider.setApiResponse(data);

      // ✅ Location fetch (parallel - non-blocking)
      locationProvider.fetchLocation();

    } catch (e) {
      splashProvider.setError(e.toString());
    }

    // ✅ Wait 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    splashProvider.updateProgress(1.0);

    if (!mounted) return;

    // ✅ Check login status
    final isLoggedIn = await TokenHelper().isLoggedIn();

    if (isLoggedIn) {
      context.go('/bottombar');  // ✅ Dashboard
    } else {
      context.go('/loginpage');  // ✅ Login
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          Column(
            children: [
              // Wave background + Logo
              SizedBox(
                height: screenHeight * 0.45,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/splash.png',
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Positioned(
                      top: 40,
                      child: Image.asset(
                        'assets/milk.gif',
                        width: 120,
                      ),
                    ),
                  ],
                ),
              ),

              // Delivery person animation
              Image.asset(
                'assets/loader.gif',
                width: 200,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 50),

              // Title
              Text(
                TextConstants.splashTitle,
                style: TextConstants.headingStyle.copyWith(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 15),

              // Page indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == 0
                            ? Colors.white
                            : Colors.white70.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Footer
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    Text(
                      "Delivering Freshness, every day",
                      style: TextConstants.bodyStyle.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/genslogo.png',
                          height: 16,
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}