import 'dart:ui';

import 'package:careflix/core/configuration/styles.dart';
import 'package:flutter/cupertino.dart';

import '../utils/size_config.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: SizeConfig.screenHeight,
        ),
        Positioned(
            bottom: 20,
            left: 10,
            child: Container(
              width: SizeConfig.screenWidth * 0.8,
              height: SizeConfig.screenWidth * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Styles.ColorGradient1.withOpacity(0.7),
                      blurRadius: 100)
                ],
              ),
            )),
        Positioned(
            top: 20,
            right: 0,
            child: Container(
              width: SizeConfig.screenWidth * 0.8,
              height: SizeConfig.screenWidth * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Styles.ColorGradient2.withOpacity(0.3),
                      blurRadius: 100)
                ],
              ),
            )),
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: SizedBox(),
        )),
      ],
    );
  }
}
