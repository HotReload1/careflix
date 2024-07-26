import 'package:careflix/layers/data/data_provider/show_video_provider.dart';
import 'package:careflix/layers/data/model/episode.dart';

class ShowVideoRepository {
  ShowVideoProvider _showVideoProvider;

  ShowVideoRepository(this._showVideoProvider);

  Future<List<Episode>> getShowVideos(String showId) async {
    final res = await _showVideoProvider.getShowVideos(showId);
    final List<Episode> episodes = getShowVideoListFromListMap(res.docs);
    return episodes;
  }
}
