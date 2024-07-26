import 'package:careflix/layers/data/data_provider/lists_provider.dart';
import 'package:careflix/layers/data/model/show.dart';
import 'package:dartz/dartz.dart';

import '../../../core/exception/app_exceptions.dart';

class ListsRepository {
  ListsProvider _listsProvider;

  ListsRepository(this._listsProvider);

  Future<List<Show>> getTopShows() async {
    final res = await _listsProvider.getTopShows();
    final List<Show> shows = getShowListFromListMap(res.docs);
    return shows;
  }

  Future<List<Show>> getTrendingShows() async {
    final res = await _listsProvider.getTrendingShows();
    final List<Show> shows = getShowListFromListMap(res.docs);
    return shows;
  }

  Future<List<Show>> getEnglishShows() async {
    final res = await _listsProvider.getEnglishShows();
    final List<Show> shows = getShowListFromListMap(res.docs);
    return shows;
  }

  Future<List<Show>> getArabicShows() async {
    final res = await _listsProvider.getArabicShows();
    final List<Show> shows = getShowListFromListMap(res.docs);
    return shows;
  }

  Future<List<Show>> getAnimeShows() async {
    final res = await _listsProvider.getAnimeShows();
    final List<Show> shows = getShowListFromListMap(res.docs);
    return shows;
  }

  Future<List<Show>> getUserList(List<String> ids) async {
    if (ids.isNotEmpty) {
      final res = await _listsProvider.getUserLists(ids);
      final List<Show> shows = getShowListFromListMap(res.docs);
      return shows.reversed.toList();
    }
    return [];
  }
}
