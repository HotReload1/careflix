import 'package:careflix/layers/data/data_provider/search_provider.dart';
import 'package:careflix/layers/data/params/search_params.dart';

import '../model/show.dart';

class SearchRepository {
  SearchProvider _searchProvider;

  SearchRepository(this._searchProvider);

  Future<List<Show>> searchShow(SearchParams searchParams) async {
    final res = await _searchProvider.searchShow(searchParams);
    final List<Show> resShows = getShowListFromListMap(res.docs);

    List<Show> shows = [];
    shows = List.from(resShows.where((element) {
      bool value = true;
      if (searchParams.categories!.isEmpty || searchParams.showLan == null) {
        value = element.title
                .toUpperCase()
                .contains(searchParams.title!.toUpperCase()) &&
            element.releaseDate.contains(searchParams.year!);
        if (!value) {
          return false;
        }
      }
      if (searchParams.categories!.isNotEmpty) {
        value = containsItemFromSecondList(
            element.category, searchParams.categories!);
        if (!value) {
          return false;
        }
      }
      if (searchParams.showLan != null) {
        value = element.showLan == searchParams.showLan;
      }
      return value;
    }));
    return shows;
  }

  bool containsItemFromSecondList(List list1, List list2) {
    for (var item in list2) {
      if (list1.contains(item)) {
        return true;
      }
    }
    return false;
  }
}
