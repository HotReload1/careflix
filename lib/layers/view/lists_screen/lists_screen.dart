import 'package:careflix/core/configuration/styles.dart';
import 'package:careflix/core/constants.dart';
import 'package:careflix/core/hero_tags.dart';
import 'package:careflix/core/ui/gradient_text.dart';
import 'package:careflix/core/ui/waiting_widget.dart';
import 'package:careflix/core/utils/size_config.dart';
import 'package:careflix/layers/logic/show_lists/show_lists_cubit.dart';
import 'package:careflix/layers/view/lists_screen/widget/animated_list_view.dart';
import 'package:careflix/layers/view/lists_screen/widget/heading_widget.dart';
import 'package:careflix/layers/view/lists_screen/widget/movie_card.dart';
import 'package:careflix/layers/view/lists_screen/widget/show_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/ui/gradient_bg.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../data/model/show.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  late PageController _topMoviesPageController;
  late PageController _trendingPageController;
  ScrollController _listViewController = ScrollController();

  final _showListsCubit = sl<ShowListsCubit>();

  _selectedTrendingPage(int index, Show show) {
    return AnimatedBuilder(
      animation: _trendingPageController,
      builder: (context, widget) {
        double value = 1;
        if (_trendingPageController.position.haveDimensions) {
          value = (_trendingPageController.page! - index);
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) *
                SizeConfig.screenHeight *
                0.42,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },
      child: MovieCard(
        show: show,
        radius: 40,
      ),
    );
  }

  loadData() {
    _showListsCubit.getShowLists(context);
  }

  @override
  void initState() {
    if (!(_showListsCubit.state is ShowListsLoaded)) {
      loadData();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
          ),
          GradientBackground(),
          BlocBuilder<ShowListsCubit, ShowListsState>(
            bloc: _showListsCubit,
            builder: (context, state) {
              if (state is ShowListsLoading) {
                return Center(
                  child: WaitingWidget(),
                );
              } else if (state is ShowListsError) {
                return Center(
                  child: Text(state.error),
                );
              } else if (state is ShowListsLoaded) {
                _topMoviesPageController = PageController(
                    initialPage: (state.topShows.length / 2).floor(),
                    viewportFraction: 0.8,
                    keepPage: true);
                _trendingPageController = PageController(
                    initialPage: (state.trendingShows.length / 2).floor(),
                    viewportFraction: 0.55,
                    keepPage: true);
                return Positioned.fill(
                    child: ListView(
                  shrinkWrap: true,
                  controller: _listViewController,
                  children: [
                    Center(
                      child: GradientText(Constants.appName,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                          gradient: LinearGradient(colors: [
                            Styles.ColorGradient1,
                            Styles.ColorGradient2
                          ])),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.5,
                      child: PageView.builder(
                        controller: _topMoviesPageController,
                        itemCount: state.topShows.length,
                        itemBuilder: (context, index) {
                          final show = state.topShows[index];
                          return AnimatedListItem(show: show);
                        },
                      ),
                    ),
                    HeadingWidget(
                      title: S.of(context).trending,
                      child: SizedBox(
                        height: SizeConfig.screenHeight * 0.43,
                        width: SizeConfig.screenWidth,
                        child: PageView.builder(
                          controller: _trendingPageController,
                          itemCount: state.trendingShows.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final show = state.trendingShows[index];
                            return _selectedTrendingPage(index, show);
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: state.userLists.isNotEmpty,
                      child: HeadingWidget(
                          title: S.of(context).myList,
                          child: ShowList(
                            shows: state.userLists,
                            isOriginals: true,
                            token: HeroTagTokens.myList,
                          )),
                    ),
                    CommonSizes.vBiggerSpace,
                    HeadingWidget(
                        title: S.of(context).english,
                        child: ShowList(
                          shows: state.englishShows,
                          token: HeroTagTokens.movies,
                        )),
                    CommonSizes.vBiggerSpace,
                    HeadingWidget(
                        title: S.of(context).arab,
                        child: ShowList(
                          shows: state.arabicShows,
                          token: HeroTagTokens.series,
                        )),
                    CommonSizes.vBiggerSpace,
                    HeadingWidget(
                        title: S.of(context).anime,
                        child: ShowList(
                          shows: state.animeShows,
                          token: HeroTagTokens.series,
                        )),
                  ],
                ));
              }
              return SizedBox();
            },
          )
        ],
      ),
    );
  }
}
