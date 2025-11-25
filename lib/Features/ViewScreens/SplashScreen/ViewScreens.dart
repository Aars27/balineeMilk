import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Components/Providers/Splash_provider.dart';
import '../../../Core/Constant/app_colors.dart';
import '../../../Core/Constant/text_constants.dart';
import 'SplashController/SplashControllers.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Assuming these are necessary for your app's logic (loading/navigation)
  late SplashController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SplashController(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.startLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    // We will use MediaQuery to get the screen height for responsive positioning
    final screenHeight = MediaQuery.of(context).size.height;
    final splashProvider = Provider.of<SplashProvider>(context); // Kept if used elsewhere

    return Scaffold(
      backgroundColor: AppColors.primary, // The main background color is yellow
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
              // Use a Stack for the background image and the logo
              SizedBox(
                height: screenHeight * 0.45, // Same height as the top white container
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/splash.png', // Assuming 'splash.png' contains the wave
                        // fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),

                    // Logo positioned correctly
                    Positioned(
                      top: 40, // Adjust this value to match the image precisely
                      child: Image.asset(
                        'assets/milk.gif',// Balinee logo
                        width: 120, // Adjusted for better visibility
                      ),
                    ),
                  ],
                ),
              ),

              // --- 2. Delivery Person Image ---
              // The image is placed visually within the yellow section
              Image.asset(
                'assets/loader.gif'
                    , // You need a new asset for the scooter/person
                width: 200,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 50),

              // --- 3. Text and Indicator Section ---
              Text(
                TextConstants.splashTitle,
                style: TextConstants.headingStyle.copyWith(
                  color: Colors.black,
                  fontSize: 28, // Increase font size to match the image
                ),
              ),
              const SizedBox(height: 15),

              // Page indicator (Solid for active, outline for others)
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
                        color: index == 0 ? Colors.white : Colors.white70.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              // const Spacer(),

              // --- 4. Footer (Tagline and GensTreeAi Logo) ---
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                     Text(
                      "Delivering Freshness, every day", // Matches the image text
                      style: TextConstants.bodyStyle.copyWith(
                        color: Colors.black,
                        fontSize: 16, // Adjust font size
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Replace your old GensTree logo code
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/genslogo.png',
                          height: 16, // Adjusted size
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