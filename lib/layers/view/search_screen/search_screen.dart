import 'package:careflix/core/configuration/assets.dart';
import 'package:careflix/core/configuration/styles.dart';
import 'package:careflix/core/enum.dart';
import 'package:careflix/core/routing/route_path.dart';
import 'package:careflix/core/ui/error_widget.dart';
import 'package:careflix/core/ui/waiting_widget.dart';
import 'package:careflix/core/utils.dart';
import 'package:careflix/l10n/local_provider.dart';
import 'package:careflix/layers/data/params/search_params.dart';
import 'package:careflix/layers/logic/search/search_cubit.dart';
import 'package:careflix/layers/view/lists_screen/widget/movie_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/debouncer.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../data/model/show.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCubit = sl<SearchCubit>();
  TextEditingController _titleController = TextEditingController();
  String lastSearch = '';
  final _searchDelayer = Debouncer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text = _searchCubit.searchParams.title!;
    if (!(_searchCubit.state is SearchLoaded)) {
      _searchCubit.searchShow();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonSizes.vBiggerSpace,
              Container(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        maxLines: 1,
                        textDirection:
                            Provider.of<LocaleProvider>(context, listen: false)
                                        .locale
                                        .languageCode !=
                                    'ar'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                        textAlign:
                            Provider.of<LocaleProvider>(context, listen: false)
                                        .locale
                                        .languageCode !=
                                    'ar'
                                ? TextAlign.left
                                : TextAlign.right,
                        decoration: InputDecoration(
                            hintText: S.of(context).search,
                            prefixIcon: Icon(Icons.search)),
                        onChanged: (value) {
                          if (value != lastSearch) {
                            lastSearch = value;
                            _searchDelayer.run(() {
                              setState(() {
                                _searchCubit.searchParams.title = value.trim();
                                _searchCubit.searchShow();
                              });
                            });
                          }
                        },
                      ),
                    ),
                    CommonSizes.hSmallSpace,
                    GestureDetector(
                      onTap: () async {
                        final res = await Navigator.of(context)
                            .pushNamed(RoutePaths.FilterSearch);
                        if (res != null && res is SearchParams) {
                          res.title = _titleController.text;
                          _searchCubit.searchParams = res;
                          _searchCubit.searchShow();
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Styles.colorPrimary)),
                        child: Center(
                          child: SvgPicture.asset(
                            AssetsLink.FILTER_IMAGE,
                            width: 25,
                            height: 25,
                            colorFilter: ColorFilter.mode(
                                Styles.colorPrimary, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              CommonSizes.vBiggerSpace,
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  bloc: _searchCubit,
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return WaitingWidget();
                    } else if (state is SearchError) {
                      return Center(
                        child: ErrorWidgetScreen(
                          message: state.error,
                          func: () {},
                        ),
                      );
                    } else if (state is SearchLoaded) {
                      return AnimationLimiter(
                        child: GridView.builder(
                            key: PageStorageKey("search"),
                            physics: const ScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 7,
                                    mainAxisSpacing: 7,
                                    mainAxisExtent: 300.0),
                            itemCount: state.shows.length,
                            itemBuilder: (context, index) {
                              Show show = state.shows[index];
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                columnCount: 2,
                                duration: Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  delay: Duration(milliseconds: 275),
                                  child: MovieCard(
                                    show: show,
                                    withShadow: false,
                                    withMargin: false,
                                    radius: 0,
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                    return SizedBox();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
