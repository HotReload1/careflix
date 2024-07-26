import 'dart:ffi';

import 'package:careflix/core/routing/route_path.dart';
import 'package:careflix/layers/view/auth/signup_screen.dart';
import 'package:careflix/layers/view/coming_soon_show/coming_soon_show.dart';
import 'package:careflix/layers/view/home_screen.dart';
import 'package:careflix/layers/view/intro/onboarding_screen.dart';
import 'package:careflix/layers/view/intro/splash_screen.dart';
import 'package:careflix/layers/view/lists_screen/lists_screen.dart';
import 'package:careflix/layers/view/search_screen/filters/filter_screen.dart';
import 'package:careflix/layers/view/search_screen/search_screen.dart';
import 'package:careflix/layers/view/settings/app_language_screen.dart';
import 'package:careflix/layers/view/settings/parental_control_screen.dart';
import 'package:careflix/layers/view/settings/settings_screen.dart';
import 'package:careflix/layers/view/show_detail_screen/show_detail_screen.dart';
import 'package:careflix/layers/view/show_detail_screen/video_streaming_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../layers/view/auth/login_screen.dart';
import '../../layers/view/auth/setup_profile_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.LogIn:
        return MaterialPageRoute(builder: (_) => const LogInScreen());
      case RoutePaths.Lists:
        return MaterialPageRoute(builder: (_) => const ListsScreen());
      case RoutePaths.ShowDetail:
        final arguments = settings.arguments ?? <String, dynamic>{} as Map;
        return PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            reverseTransitionDuration: Duration(seconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) {
              final curvedAnimation =
                  CurvedAnimation(parent: animation, curve: Interval(0.0, 0.5));
              return FadeTransition(
                opacity: curvedAnimation,
                child: ShowDetailScreen(
                  show: (arguments as Map)["show"],
                  heroToken: (arguments as Map)["heroToken"],
                  animation: animation,
                ),
              );
            });
      case RoutePaths.Search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RoutePaths.FilterSearch:
        return MaterialPageRoute(builder: (_) => const FilterSearchScreen());
      case RoutePaths.ComingSoonShow:
        return MaterialPageRoute(builder: (_) => const ComingSoonShow());
      case RoutePaths.SplashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RoutePaths.OnBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case RoutePaths.LogIn:
        return MaterialPageRoute(builder: (_) => const LogInScreen());
      case RoutePaths.SignUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case RoutePaths.SetUpProfileScreen:
        return MaterialPageRoute(builder: (_) => const SetUpProfileScreen());
      case RoutePaths.SettingsScreen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case RoutePaths.AppLanguageScreen:
        return MaterialPageRoute(builder: (_) => const AppLanguageScreen());
      case RoutePaths.ParentalControlScreen:
        return MaterialPageRoute(builder: (_) => const ParentalControlScreen());
      case RoutePaths.VideoStreamingScreen:
        final arguments = settings.arguments ?? <String, dynamic>{} as Map;
        return MaterialPageRoute(
            builder: (_) => VideoStreamingScreen(
                  episode: (arguments as Map)["episode"],
                ));
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
                // child: Text('No route defined for ${settings.name}'),
                ),
          ),
        );
    }
  }
}
