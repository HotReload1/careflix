import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:careflix/core/app/state/app_state.dart';
import 'package:careflix/core/configuration/assets.dart';
import 'package:careflix/core/configuration/styles.dart';
import 'package:careflix/core/constants.dart';
import 'package:careflix/core/routing/route_path.dart';
import 'package:careflix/core/shared_preferences/shared_preferences_instance.dart';
import 'package:careflix/core/utils/size_config.dart';
import 'package:careflix/l10n/local_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/shared_preferences/shared_preferences_key.dart';
import '../../../injection_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundAnimationController;
  late AnimationController _textAnimationController;
  late AnimationController _controller;
  late AnimationController _imageAnimation;
  late Animation<Color?> _animationColorBg;
  late Animation<int> _characterCount;
  late Animation<double> _imageHeight;

  bool viewSpace = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _navigateAfterDelay();
  }

  void _initializeBackgroundAnimation() {
    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationColorBg = ColorTween(
      begin: Styles.colorPrimary,
      end: Styles.backgroundColor,
    ).animate(_backgroundAnimationController);
  }

  void _initializeTextAnimation() {
    _textAnimationController = new AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _characterCount = new StepTween(begin: 0, end: Constants.appName.length)
        .animate(new CurvedAnimation(
            parent: _textAnimationController, curve: Curves.easeIn));
  }

  void _initializeImageAnimation() {
    _imageAnimation = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _imageHeight = new Tween(begin: 130.0, end: 40.0).animate(_imageAnimation);
  }

  void _initializeAnimation() async {
    _initializeBackgroundAnimation();
    _initializeTextAnimation();
    _initializeImageAnimation();

    _backgroundAnimationController.forward();

    _backgroundAnimationController.addListener(() {
      setState(() {});
    });

    _backgroundAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _imageAnimation.forward();
      }
    });

    // Future.delayed(Duration(milliseconds: 1000), () {});

    _imageHeight.addListener(() {
      setState(() {});
    });

    _imageHeight.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          viewSpace = true;
        });
      }
    });

    _controller = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _textAnimationController.forward();
        }
      });
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 5));
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _navigateBasedOnUserProfile(user);
    } else {
      _navigateBasedOnFirstTime();
    }
  }

  void _navigateBasedOnUserProfile(User user) async {
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      await Provider.of<AppState>(context, listen: false).init();
      _navigateTo(RoutePaths.Home);
    } else {
      _navigateTo(RoutePaths.SetUpProfileScreen);
    }
  }

  void _navigateBasedOnFirstTime() {
    bool? isFirstTime = SharedPreferencesInstance.pref
        .getBool(SharedPreferencesKeys.FIRST_TIME_KEY);

    if (isFirstTime == null || isFirstTime) {
      _navigateTo(RoutePaths.OnBoardingScreen);
    } else {
      _navigateTo(RoutePaths.LogIn);
    }
  }

  void _navigateTo(String route) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: _animationColorBg.value,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  height: _imageHeight.value,
                  AssetsLink.APP_LOGO,
                ),
                Visibility(visible: viewSpace, child: CommonSizes.hSmallSpace),
                Container(
                  color: Colors.white,
                  height: 20,
                  width: 2,
                ).animate(controller: _controller).scaleY(
                    delay: Duration(milliseconds: 1400),
                    duration: Duration(milliseconds: 300),
                    begin: 0,
                    end: 1.5),
                Visibility(visible: viewSpace, child: CommonSizes.hSmallSpace),
                _characterCount == null
                    ? SizedBox()
                    : AnimatedBuilder(
                        animation: _characterCount,
                        builder: (context, child) {
                          String text = Constants.appName
                              .substring(0, _characterCount.value);
                          return Text(
                            text,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          );
                        },
                      )
              ],
            ),
            CommonSizes.vSmallSpace,
            Text("Where Entertainment Meets Safety")
                .animate()
                .fadeIn(
                  delay: Duration(milliseconds: 2600),
                  duration: Duration(milliseconds: 500),
                )
                .slideY(
                    delay: Duration(milliseconds: 2600),
                    duration: Duration(milliseconds: 700),
                    begin: 0.5,
                    end: 0)
          ],
        ),
      ),
    );
  }
}
