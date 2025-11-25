import 'package:flutter/material.dart';
import 'app_colors.dart';

class TextConstants {
  // Strings
  static const String appName = "Balinee Delivery";
  static const String splashTitle = "Your Delivery Partner";
  static const String splashSubtitle = "Delivering Freshness, every day";
  static const String poweredBy = "GenstreeAi";

  // Font Sizes
  static const double headingSize = 22.0;
  static const double subHeadingSize = 16.0;
  static const double bodySize = 14.0;
  static const double smallSize = 12.0;

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: headingSize,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    letterSpacing: 0.3,
  );

  static const TextStyle subHeadingStyle = TextStyle(
    fontSize: subHeadingSize,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: bodySize,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );

  static const TextStyle smallTextStyle = TextStyle(
    fontSize: smallSize,
    color: AppColors.grey,
  );

  static const TextStyle whiteTextStyle = TextStyle(
    fontSize: bodySize,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle errorTextStyle = TextStyle(
    fontSize: smallSize,
    color: Colors.red,
  );
}
