import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:careflix/core/configuration/assets.dart';
import 'package:careflix/core/configuration/styles.dart';
import 'package:careflix/core/enum.dart';
import 'package:careflix/core/routing/route_path.dart';
import 'package:careflix/core/ui/hero_widget.dart';
import 'package:careflix/core/utils.dart';
import 'package:careflix/l10n/local_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../core/hero_tags.dart';
import '../../../../core/ui/waiting_widget.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../generated/l10n.dart';
import '../../../data/model/show.dart';

class MovieCard extends StatelessWidget {
  MovieCard(
      {super.key,
      required this.show,
      this.radius = 40,
      this.withMargin = true,
      this.withShadow = true});
  final Show show;
  final double radius;
  final bool withShadow;
  final bool withMargin;

  @override
  Widget build(BuildContext context) {
    final lanProvider = Provider.of<LocaleProvider>(context, listen: false);
    return GestureDetector(
      onTap: () => pushToDetailScreen(context),
      child: Container(
          margin: withMargin
              ? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7)
              : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            boxShadow: withShadow
                ? [
                    BoxShadow(
                      color: Styles.colorPrimary.withOpacity(0.2),
                      offset: Offset(0.0, 2.0),
                      blurRadius: 8.0,
                    ),
                  ]
                : [],
          ),
          child: Center(
              child: Stack(
            children: [
              _buildImage(),
              Positioned(
                bottom: -1,
                left: 0,
                right: 0,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    blurEffect(context),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: gradientBar(lanProvider),
                    ),
                    Positioned.directional(
                        textDirection: Directionality.of(context),
                        top: -15,
                        end: 15,
                        child: ratingWidget())
                  ],
                ),
              )
            ],
          ))),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        Utils.clipWidget(
            Image.asset(
              AssetsLink.LOADING_IMAGE,
              height: SizeConfig.screenHeight * 0.42,
              width: SizeConfig.screenWidth * 0.49,
              fit: BoxFit.cover,
            ),
            radius: radius),
        HeroWidget(
          tag: HeroTag.image(show.imageUrl, token: HeroTagTokens.movieCard),
          child: Utils.clipWidget(
              CachedNetworkImage(
                imageUrl: show.imageUrl,
                height: SizeConfig.screenHeight * 0.42,
                width: SizeConfig.screenWidth * 0.49,
                fit: BoxFit.cover,
              ),
              radius: radius),
        ),
      ],
    );
  }

  ClipRRect blurEffect(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius)),
      child: SizedBox(
        height: 90,
        width: SizeConfig.screenWidth * 0.49,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: _blurBody(context),
          ),
        ),
      ),
    );
  }

  Column _blurBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
        SizedBox(
          width: SizeConfig.screenWidth * 0.35,
          child: HeroWidget(
            tag: HeroTag.title(show, token: HeroTagTokens.movieCard),
            child: Text(
              show.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700, height: 0, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        SizedBox(
          height: 3,
        ),
        HeroWidget(
          tag: HeroTag.season(show, token: HeroTagTokens.movieCard),
          child: Text(
              show.type == ShowType.TV_SHOW
                  ? "${S.of(context).season}: ${show.season!}"
                  : "${show.duration.toString()} ${S.of(context).minutes}",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white)),
        )
      ],
    );
  }

  Container gradientBar(LocaleProvider localeProvider) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.transparent, Color(0XFF8a969a).withOpacity(0.8)],
        begin: localeProvider.locale.languageCode != 'ar'
            ? Alignment.centerLeft
            : Alignment.centerRight,
        end: localeProvider.locale.languageCode != 'ar'
            ? Alignment.centerRight
            : Alignment.centerLeft,
      )),
    );
  }

  Stack ratingWidget() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: -1.2,
          child: RotationTransition(
            turns: AlwaysStoppedAnimation(45 / 360),
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(9)),
            ),
          ),
        ),
        RotationTransition(
          turns: AlwaysStoppedAnimation(45 / 360),
          child: Container(
            alignment: Alignment.center,
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                color: Color(0XFF8a969a),
                borderRadius: BorderRadius.circular(9)),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-45 / 360),
              child: Text(
                show.rating.toString(),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
        Positioned(
          top: -20,
          child: HeroWidget(
            tag: HeroTag.star(show, token: HeroTagTokens.movieCard, index: 2),
            child: Icon(
              Icons.star,
              color: Colors.amber,
              size: 35,
            ),
          ),
        )
      ],
    );
  }

  pushToDetailScreen(BuildContext context) {
    Navigator.of(context).pushNamed(RoutePaths.ShowDetail,
        arguments: {"show": show, "heroToken": HeroTagTokens.movieCard});
  }
}
