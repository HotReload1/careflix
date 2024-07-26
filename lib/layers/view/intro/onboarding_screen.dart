import 'package:careflix/core/configuration/assets.dart';
import 'package:careflix/core/configuration/styles.dart';
import 'package:careflix/core/routing/route_path.dart';
import 'package:careflix/core/shared_preferences/shared_preferences_instance.dart';
import 'package:careflix/core/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/shared_preferences/shared_preferences_key.dart';
import '../../../core/utils/size_config.dart';
import '../../../generated/l10n.dart';
import 'models/onboarding_model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  late PageController _pageController;
  int index1 = 0;
  List<OnBoardingModel> screens = <OnBoardingModel>[
    OnBoardingModel(
      img: AssetsLink.RESPONSIVE,
      text: "Watch Everywhere",
      desc:
          "Stream unlimited movies and series on your phone, tablet, laptop and TV without paying more",
      bg: Colors.white,
      button: Color(0xFF4756DF),
    ),
    OnBoardingModel(
      img: AssetsLink.PARENTAL_CONTROL,
      text: "Parental Control",
      desc:
          "Managing children's use of the application by determining the content, time and periods of the child's use of this application.",
      bg: Color(0xFF4756DF),
      button: Colors.white,
    ),
    OnBoardingModel(
      img: AssetsLink.NO_INTERNET,
      text: "No Connection",
      desc:
          "You can browse the app and search for any movie or series even if there isn't Internet connection",
      bg: Colors.white,
      button: Color(0xFF4756DF),
    ),
  ];

  pushToLoginScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutePaths.LogIn, (Route<dynamic> route) => false);
    SharedPreferencesInstance.pref
        .setBool(SharedPreferencesKeys.FIRST_TIME_KEY, false);
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentIndex != 0
                    ? TextButton(
                        onPressed: () {
                          currentIndex--;
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.bounceIn,
                          );
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back_ios,
                                size: 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .color!),
                            CommonSizes.hSmallerSpace,
                            Text(
                              S.of(context).back,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .color,
                              ),
                            )
                          ],
                        ))
                    : SizedBox(),
                TextButton(
                    onPressed: () => pushToLoginScreen(),
                    child: Row(
                      children: [
                        Text(
                          S.of(context).skip,
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.titleMedium!.color,
                          ),
                        ),
                        CommonSizes.hSmallerSpace,
                        Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context).textTheme.titleMedium!.color,
                          size: 20,
                        )
                      ],
                    ))
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: PageView.builder(
                            itemCount: screens.length,
                            controller: _pageController,
                            physics: NeverScrollableScrollPhysics(),
                            onPageChanged: (int index) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            itemBuilder: (_, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    screens[index].img,
                                    width: SizeConfig.screenWidth * 0.8,
                                    height: SizeConfig.screenHeight * 0.35,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  CommonSizes.vBigSpace,
                                  Text(
                                    screens[index].text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  CommonSizes.vSmallSpace,
                                  SizedBox(
                                    width: SizeConfig.screenWidth * 0.8,
                                    child: Text(
                                      screens[index].desc,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: 'Roboto',
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .color!
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 10.0,
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          child: ListView.builder(
                            itemCount: screens.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 3.0),
                                      width: 22,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: currentIndex == index
                                            ? Styles.colorPrimary
                                            : Color(0xFFD3D3D3),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ]);
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (currentIndex == screens.length - 1) {
                              pushToLoginScreen();
                            }
                            setState(() {
                              currentIndex++;
                            });
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.bounceIn,
                            );
                          },
                          child: Container(
                            height: 75,
                            width: 75,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Provider.of<ThemeProvider>(context,
                                                    listen: false)
                                                .themeMode ==
                                            ThemeMode.dark
                                        ? Colors.white
                                        : Styles.colorPrimary,
                                    width: 2)),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Provider.of<ThemeProvider>(context,
                                                  listen: false)
                                              .themeMode ==
                                          ThemeMode.dark
                                      ? Colors.white
                                      : Styles.colorPrimary,
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Provider.of<ThemeProvider>(context,
                                                listen: false)
                                            .themeMode ==
                                        ThemeMode.dark
                                    ? Styles.colorPrimary
                                    : Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
