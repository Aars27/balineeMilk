// lib/Core/Router/Router.dart
import "package:go_router/go_router.dart";

import "../../Components/Savetoken/SaveToken.dart";
import "../../Features/NotificationScreen/NotificationScreen.dart";
import "../../Features/ViewScreens/SplashScreen/ViewScreens.dart";
import "../../Features/ViewScreens/LoginScreen/LoginScreen.dart";
import "../../Features/BottomPage/BootamPage.dart";

final GoRouter AppRouter = GoRouter(
  initialLocation: '/',

  //  Global redirect logic for auto-login
  redirect: (context, state) async {
    final isLoggedIn = await TokenHelper().isLoggedIn();

    // Allow splash screen always
    if (state.matchedLocation == '/') {
      return null;
    }

    // If logged in, don't allow login page
    if (state.matchedLocation == '/loginpage' && isLoggedIn) {
      return '/bottombar';
    }

    // If not logged in, redirect to login (except splash)
    if (!isLoggedIn &&
        state.matchedLocation != '/' &&
        state.matchedLocation != '/loginpage') {
      return '/loginpage';
    }

    return null; // Allow navigation
  },

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
      builder: (context, state) => MainWrapperScreen(),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => NotificationScreen(),
    ),
  ],
);