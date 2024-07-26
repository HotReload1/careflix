import 'package:bloc/bloc.dart';
import 'package:careflix/core/enum.dart';
import 'package:careflix/layers/data/model/episode.dart';
import 'package:careflix/layers/data/repository/show_video_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../data/model/show.dart';
part 'show_video_state.dart';

class ShowVideoCubit extends Cubit<ShowVideoState> {
  ShowVideoCubit() : super(ShowVideoInitial());

  final _showVideoRepo = sl<ShowVideoRepository>();

  getShowVideo(Show show) async {
    emit(ShowVideoLoading());
    try {
      final res = await _showVideoRepo.getShowVideos(show.id);
      if (res.isEmpty) {
        if (show.type == ShowType.MOVIE) {
          res.add(Episode(
              id: "",
              number: "1",
              videoUrl: "https://ok.ru/videoembed/3407261207132"));
        } else if (show.type == ShowType.TV_SHOW) {
          for (int i = 1; i <= show.episodeNum!; i++) {
            res.add(Episode(
                id: i.toString(),
                number: i.toString(),
                videoUrl: "https://ok.ru/videoembed/3407261207132"));
          }
        }
      }
      emit(ShowVideoLoaded(episodes: res));
    } catch (e) {
      emit(ShowVideoError(error: S.current.thereIsAnError));
    }
  }

  dispose() {
    emit(ShowVideoInitial());
  }
}
