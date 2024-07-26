import 'package:careflix/core/enum.dart';
import 'package:careflix/layers/data/data_provider/coming_soon_provider.dart';

import '../model/show.dart';

class ComingSoonRepository {
  ComingSoonProvider _comingSoonProvider;

  ComingSoonRepository(this._comingSoonProvider);

  Future<List<Show>> getComingSoonShows(ShowLan? showLan) async {
    final res = await _comingSoonProvider.getComingSoonShows(showLan);
    final List<Show> shows = getShowListFromListMap(res.docs);
    return shows;
  }
}
