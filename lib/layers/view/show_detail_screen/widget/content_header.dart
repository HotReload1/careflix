import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:careflix/core/app/state/app_state.dart';
import 'package:careflix/core/constants.dart';
import 'package:careflix/core/enum.dart';
import 'package:careflix/core/routing/route_path.dart';
import 'package:careflix/core/utils.dart';
import 'package:careflix/layers/logic/show_video/show_video_cubit.dart';
import 'package:careflix/layers/view/show_detail_screen/widget/vertical_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/configuration/styles.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection_container.dart';
import '../../../data/model/rule.dart';
import '../../../data/model/show.dart';

class ContentHeader extends StatelessWidget {
  const ContentHeader({
    super.key,
    required this.show,
  });

  final Show show;

  void shareImage() async {
    final url = Uri.parse(show.imageUrl);
    final response = await get(url);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    Share.shareXFiles(
      [XFile(path)],
      text: 'I recommend you to watch ${show.title} on ${Constants.appName}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppState>(context, listen: false);
    final Rule? rule = provider.rule;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: SizeConfig.screenHeight * 0.55,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: show.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator(color: Colors.red)),
          ),
        ),
        Container(
          height: SizeConfig.screenHeight * 0.55 + 5,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
                iconSize: 30.0,
                color: Colors.white,
              ),
              OutlineGradientButton(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 25,
                      ),
                    ],
                  ),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.transparent,
                    Colors.transparent
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                strokeWidth: 1,
                padding: EdgeInsets.zero,
                radius: Radius.circular(26),
                onTap: () => Navigator.of(context)
                    .pushNamed(RoutePaths.VideoStreamingScreen),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 30,
          child: Row(
            children: [
              Expanded(
                  child: Consumer<AppState>(
                builder: (BuildContext context, AppState value,
                        Widget? child) =>
                    VerticalIconButton(
                        icon: value.userModel!.userListIds.contains(show.id)
                            ? Icons.remove
                            : Icons.add,
                        title: S.of(context).list,
                        onTap: () async {
                          if (value.userModel!.userListIds.contains(show.id)) {
                            context
                                .read<AppState>()
                                .removeShowFromList(show.id);
                          } else {
                            context.read<AppState>().addShowToUserList(show.id);
                          }
                        }),
              )),
              rule != null &&
                      (rule.blockedShowsId!.contains(show.title) ||
                          Utils.listsHaveCommonItem(
                              rule.blockedCategories!, show.category))
                  ? SizedBox()
                  : Visibility(
                      visible: show.type == ShowType.MOVIE,
                      child: _PlayButton(
                        show: show,
                        context: context,
                      ),
                    ),
              Expanded(
                child: VerticalIconButton(
                    icon: Icons.share,
                    title: S.of(context).share,
                    onTap: () => shareImage()),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _PlayButton extends StatefulWidget {
  final Show show;
  final BuildContext context;
  _PlayButton({required this.show, required this.context});

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> {
  final show_video_cubit = sl<ShowVideoCubit>();

  @override
  void initState() {
    super.initState();
    show_video_cubit.getShowVideo(widget.show);
  }

  @override
  void dispose() {
    super.dispose();
    show_video_cubit.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowVideoCubit, ShowVideoState>(
      bloc: show_video_cubit,
      builder: (context, state) {
        return TextButton.icon(
          icon: Icon(Icons.play_arrow, size: 30, color: Styles.colorTertiary),
          label: Text(S.of(context).play,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Styles.colorTertiary)),
          onPressed: () {
            if (state is ShowVideoLoaded) {
              Navigator.of(context).pushNamed(RoutePaths.VideoStreamingScreen,
                  arguments: {"episode": state.episodes.first});
            }
          },
          style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 10.0),
              backgroundColor:
                  !(state is ShowVideoLoaded) ? Colors.grey : Colors.white),
        );
      },
    );
  }
}
