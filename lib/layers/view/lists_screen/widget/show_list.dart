import 'package:cached_network_image/cached_network_image.dart';
import 'package:careflix/core/configuration/assets.dart';
import 'package:careflix/core/enum.dart';
import 'package:careflix/core/hero_tags.dart';
import 'package:careflix/core/ui/hero_widget.dart';
import 'package:careflix/core/ui/waiting_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/routing/route_path.dart';
import '../../../data/model/show.dart';

class ShowList extends StatelessWidget {
  const ShowList(
      {super.key,
      required this.shows,
      this.isOriginals = false,
      required this.token});
  final List<Show> shows;
  final bool isOriginals;
  final HeroTagsTypes token;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isOriginals ? 330 : 200,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: shows.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final Show content = shows[index];
          return GestureDetector(
            onTap: () => pushToDetailScreen(context, content),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              height: isOriginals ? 350 : 200,
              width: isOriginals ? 230 : 130,
              child: Stack(
                children: [
                  Image.asset(
                    height: isOriginals ? 350 : 200,
                    width: isOriginals ? 230 : 130,
                    AssetsLink.LOADING_IMAGE,
                    fit: BoxFit.cover,
                  ),
                  HeroWidget(
                    tag: HeroTag.image(content.imageUrl, token: token),
                    child: CachedNetworkImage(
                      height: isOriginals ? 350 : 200,
                      width: isOriginals ? 230 : 130,
                      imageUrl: content.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  pushToDetailScreen(BuildContext context, Show show) {
    Navigator.of(context).pushNamed(RoutePaths.ShowDetail,
        arguments: {"show": show, "heroToken": token});
  }
}
