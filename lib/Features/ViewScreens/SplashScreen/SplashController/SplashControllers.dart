import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../Components/Providers/Splash_provider.dart';
import '../../../../Core/Constant/ApiServices.dart';

class SplashController {
  final BuildContext context;
  SplashController(this.context);

  void startLoading() async {
    final provider = Provider.of<SplashProvider>(context, listen: false);

    final api = ApiService(); // ← create instance

    try {
      final data = await api.getData("config"); // ← call via instance
      provider.setApiResponse(data);
    } catch (e) {
      provider.setError(e.toString());
    }

    await Future.delayed(const Duration(seconds: 2));
    provider.updateProgress(1.0);

    if (context.mounted) {
      context.go('/loginpage');
    }
  }
}
