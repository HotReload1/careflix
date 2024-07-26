import 'package:cached_network_image/cached_network_image.dart';
import 'package:careflix/core/configuration/assets.dart';
import 'package:careflix/core/configuration/styles.dart';
import 'package:careflix/core/hero_tags.dart';
import 'package:careflix/core/routing/route_path.dart';
import 'package:careflix/core/ui/hero_widget.dart';
import 'package:careflix/core/utils.dart';
import 'package:careflix/layers/data/model/show.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../core/enum.dart';
import '../../../../core/ui/waiting_widget.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../generated/l10n.dart';

class AnimatedListItem extends StatefulWidget {
  const AnimatedListItem({super.key, required this.show});

  final Show show;

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          bottom: isExpanded ? 10 : 55,
          width: isExpanded
              ? SizeConfig.screenWidth * 0.78
              : SizeConfig.screenWidth * 0.69,
          height: isExpanded
              ? SizeConfig.screenHeight * 0.4
              : SizeConfig.screenHeight * 0.3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroWidget(
                  tag: HeroTag.title(widget.show,
                      token: HeroTagTokens.animatedWidget),
                  child: Text(
                    widget.show.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: HeroWidget(
                      tag: HeroTag.season(widget.show,
                          token: HeroTagTokens.animatedWidget),
                      child: Text(
                        widget.show.type == ShowType.TV_SHOW
                            ? "${S.of(context).season}: ${widget.show.season!}"
                            : "${widget.show.duration.toString()} ${S.of(context).minutes}",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                    RatingBar.builder(
                      tag: HeroTag.star(widget.show,
                          token: HeroTagTokens.animatedWidget),
                      initialRating: widget.show.rating / 2,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      ignoreGestures: true,
                      unratedColor: Colors.red.shade100,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          bottom: isExpanded ? 70 : 40,
          child: GestureDetector(
            onVerticalDragUpdate: onPanUpdate,
            onTap: () => pushToDetailScreen(),
            child: _buildImage(),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        Utils.clipWidget(Image.asset(
          AssetsLink.LOADING_IMAGE,
          height: SizeConfig.screenHeight * 0.4,
          width: SizeConfig.screenWidth * 0.7,
          fit: BoxFit.cover,
        )),
        HeroWidget(
          tag: HeroTag.image(widget.show.imageUrl,
              token: HeroTagTokens.animatedWidget),
          child: Utils.clipWidget(CachedNetworkImage(
            imageUrl: widget.show.imageUrl,
            height: SizeConfig.screenHeight * 0.4,
            width: SizeConfig.screenWidth * 0.7,
            fit: BoxFit.cover,
          )),
        ),
      ],
    );
  }

  pushToDetailScreen() {
    if (!isExpanded) {
      setState(() {
        isExpanded = !isExpanded;
      });
      return;
    }
    Navigator.of(context).pushNamed(RoutePaths.ShowDetail, arguments: {
      "show": widget.show,
      "heroToken": HeroTagTokens.animatedWidget
    });
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (details.delta.dy < 0) {
      setState(() {
        isExpanded = true;
      });
    } else if (details.delta.dy > 0) {
      setState(() {
        isExpanded = false;
      });
    }
  }
}
