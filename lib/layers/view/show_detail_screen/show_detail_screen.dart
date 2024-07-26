import 'dart:ffi';
import 'dart:math';

import 'package:careflix/core/configuration/styles.dart';
import 'package:careflix/core/hero_tags.dart';
import 'package:careflix/core/ui/gradient_widget.dart';
import 'package:careflix/core/ui/hero_widget.dart';
import 'package:careflix/layers/data/model/show.dart';
import 'package:careflix/layers/view/show_detail_screen/widget/content_body.dart';
import 'package:careflix/layers/view/show_detail_screen/widget/content_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/enum.dart';

class ShowDetailScreen extends StatelessWidget {
  const ShowDetailScreen(
      {super.key,
      required this.show,
      required this.animation,
      required this.heroToken});

  final Show show;
  final Animation animation;
  final HeroTagsTypes heroToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        transform: Matrix4.translationValues(0.0, -30.0, 0.0),
        child: ListView(
          children: [
            HeroWidget(
              tag: HeroTag.image(show.imageUrl, token: heroToken),
              child: ContentHeader(show: show),
            ),
            CommonSizes.vSmallSpace,
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) => FadeTransition(
                opacity: CurvedAnimation(
                    parent: animation as Animation<double>,
                    curve: Interval(0.2, 1, curve: Curves.easeInExpo)),
                child: child,
              ),
              child: ContentBody(
                show: show,
                heroToken: heroToken,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
