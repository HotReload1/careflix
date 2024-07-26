import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:careflix/core/enum.dart';
import 'package:careflix/core/routing/route_path.dart';
import 'package:careflix/core/ui/waiting_widget.dart';
import 'package:careflix/core/utils.dart';
import 'package:careflix/layers/data/model/episode.dart';
import 'package:careflix/layers/logic/show_video/show_video_cubit.dart';
import 'package:careflix/layers/view/lists_screen/widget/heading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';
import '../../../../core/app/state/app_state.dart';
import '../../../../core/configuration/styles.dart';
import '../../../../core/hero_tags.dart';
import '../../../../core/ui/gradient_widget.dart';
import '../../../../core/ui/hero_widget.dart';
import '../../../../core/ui/responsive_text.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection_container.dart';
import '../../../data/model/rule.dart';
import '../../../data/model/show.dart';

class ContentBody extends StatefulWidget {
  const ContentBody({super.key, required this.show, required this.heroToken});

  final Show show;
  final HeroTagsTypes heroToken;

  @override
  State<ContentBody> createState() => _ContentBodyState();
}

class _ContentBodyState extends State<ContentBody> {
  bool isTopAndBottomStarsAnimated = false;
  final _showVideoCubit = sl<ShowVideoCubit>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.show.type == ShowType.TV_SHOW) {
      _showVideoCubit.getShowVideo(widget.show);
    }
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        isTopAndBottomStarsAnimated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppState>(context, listen: false);
    final Rule? rule = provider.rule;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeroWidget(
                          tag: HeroTag.title(widget.show,
                              token: widget.heroToken),
                          child: ResponsiveText(
                            textWidget: Text(
                              widget.show.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                      fontFamily: "Rubik",
                                      fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        CommonSizes.vSmallerSpace,
                        Visibility(
                          visible: widget.show.season != null &&
                              widget.show.season!.isNotEmpty,
                          child: HeroWidget(
                            tag: HeroTag.season(widget.show,
                                token: widget.heroToken),
                            child: ResponsiveText(
                              textWidget: Text(
                                widget.show.type == ShowType.TV_SHOW
                                    ? "${S.of(context).season}: ${widget.show.season!}"
                                    : "${widget.show.duration.toString()} ${S.of(context).minutes}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.color
                                            ?.withOpacity(0.8)),
                              ),
                            ),
                          ),
                        ),
                        CommonSizes.vSmallerSpace,
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(widget.show.category.length,
                              (index) {
                            final title = widget.show.category[index];
                            return Chip(
                              backgroundColor: Styles.categoryColors[Random()
                                  .nextInt(Styles.categoryColors.length)],
                              label: Text(title),
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                  _buildRatingWidget(context),
                ],
              ),
              CommonSizes.vSmallSpace,
              HeadingWidget(
                  padding: 0,
                  title: S.of(context).introduction,
                  child: Text(
                    widget.show.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: "Rubik",
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7)),
                  )),
            ],
          ),
        ),
        CommonSizes.vSmallSpace,
        rule != null &&
                (rule.blockedShowsId!.contains(widget.show.title) ||
                    Utils.listsHaveCommonItem(
                        rule.blockedCategories!, widget.show.category))
            ? Center(
                child: Text(
                  S.of(context).blockedShow,
                  style: TextStyle(fontSize: 20),
                ),
              )
            : Visibility(
                visible: widget.show.type == ShowType.TV_SHOW,
                child: HeadingWidget(
                  padding: 20,
                  title:
                      S.of(context).episodes + " (${widget.show.episodeNum})",
                  child: BlocBuilder<ShowVideoCubit, ShowVideoState>(
                    bloc: _showVideoCubit,
                    builder: (context, state) {
                      if (state is ShowVideoLoaded) {
                        return Container(
                          height: 150,
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.episodes.length,
                            itemBuilder: (BuildContext context, int index) {
                              Episode episode = state.episodes[index];
                              return GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    RoutePaths.VideoStreamingScreen,
                                    arguments: {"episode": episode}),
                                child: Utils.clipWidget(Stack(
                                  children: [
                                    CachedNetworkImage(
                                        imageUrl: widget.show.imageUrl),
                                    Positioned.fill(
                                      child: Container(
                                        color: Colors.black.withOpacity(0.4),
                                        child: Center(
                                          child: Text(
                                            episode.number,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                width: 15,
                              );
                            },
                          ),
                        );
                      } else if (state is ShowVideoLoading) {
                        return Container(
                          height: 150,
                          child: Center(
                            child: WaitingWidget(),
                          ),
                        );
                      } else if (state is ShowVideoError) {
                        return Container(
                          height: 150,
                          child: Center(
                            child: Text(state.error),
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ),
              ),
      ],
    );
  }

  Stack _buildRatingWidget(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        OutlineGradientButton(
          child: SizedBox(
            width: 70,
            height: 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 1500),
                  builder: (context, animatedValue, child) {
                    if (animatedValue == 1) {
                      return _opacityAnimatedText(context);
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
          gradient: LinearGradient(
            colors: [
              Styles.colorPrimary,
              Colors.transparent,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          strokeWidth: 1.5,
          padding: EdgeInsets.zero,
          radius: Radius.circular(40),
        ),
        _chooseAnimatedStarWidget()
      ],
    );
  }

  TweenAnimationBuilder<double> _opacityAnimatedText(BuildContext context) {
    return TweenAnimationBuilder(
      child: Text(
        widget.show.rating.toStringAsFixed(1),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      duration: Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
    );
  }

  _chooseAnimatedStarWidget() {
    if (widget.heroToken == HeroTagsTypes.FromAnimatedList) {
      return _zeroAnimateWidget();
    } else if (widget.heroToken == HeroTagsTypes.FromMoviesCard) {
      return _animateTwoStars(_centeredStar());
    } else {
      return _animateTwoStars(_animateOneStar());
    }
  }

  _zeroAnimateWidget() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 70,
          width: 70,
        ),
        Positioned(
          top: -5,
          right: -1,
          child: _buildHeroAnimationForTheStars(1),
        ),
        _centeredStar(),
        Positioned(
          bottom: -5,
          right: -1,
          child: _buildHeroAnimationForTheStars(3),
        ),
      ],
    );
  }

  _animateTwoStars(Widget middleStar) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 70,
          width: 70,
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          top: !isTopAndBottomStarsAnimated ? -11 : -5,
          right: !isTopAndBottomStarsAnimated ? 35 : -1,
          child: _buildHeroAnimationForTheStars(1),
        ),
        middleStar,
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          bottom: !isTopAndBottomStarsAnimated ? -11 : -5,
          right: !isTopAndBottomStarsAnimated ? 35 : -1,
          child: _buildHeroAnimationForTheStars(3),
        ),
      ],
    );
  }

  _animateOneStar() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      right: !isTopAndBottomStarsAnimated ? 20 : -10,
      child: _buildHeroAnimationForTheStars(2),
    );
  }

  _centeredStar() {
    return Positioned(
      right: -10,
      child: _buildHeroAnimationForTheStars(2),
    );
  }

  _buildStar() {
    return GradientWidget(
      Icon(
        Icons.star,
        color: Colors.amber,
        size: 25,
      ),
      gradient: LinearGradient(
          colors: [Colors.amber, Colors.amber.shade800],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter),
    );
  }

  _buildHeroAnimationForTheStars(int index) {
    return HeroWidget(
      child: _buildStar(),
      tag: HeroTag.star(widget.show, index: index, token: widget.heroToken),
    );
  }
}
