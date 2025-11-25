
import "package:balineemilk/Features/ViewScreens/LoginScreen/LoginScreen.dart";
import "package:balineemilk/Features/ViewScreens/SplashScreen/ViewScreens.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../../Features/BottomPage/BootamPage.dart";

final GoRouter AppRouter = GoRouter(
  // initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/loginpage',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/bottombar',
      builder: (context, state) =>   MainWrapperScreen(),
    ),
  ],
);
