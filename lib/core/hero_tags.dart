import 'package:careflix/layers/data/model/show.dart';

import 'enum.dart' as Enums;

class HeroTag {
  static String image(String urlImage, {required Enums.HeroTagsTypes token}) {
    return urlImage + Enums.HeroTagsEnumToString(token);
  }

  static String title(Show show, {required Enums.HeroTagsTypes token}) {
    return show.title + show.imageUrl + Enums.HeroTagsEnumToString(token);
  }

  static String season(Show show, {required Enums.HeroTagsTypes token}) {
    return show.season != null && show.season!.isNotEmpty
        ? (show.season! + show.imageUrl + Enums.HeroTagsEnumToString(token))
        : (show.releaseDate +
            show.imageUrl +
            Enums.HeroTagsEnumToString(token));
  }

  static String star(Show show,
      {int? index, required Enums.HeroTagsTypes token}) {
    return show.title +
        show.releaseDate +
        show.imageUrl +
        Enums.HeroTagsEnumToString(token) +
        (index != null ? index.toString() : "");
  }
}

class HeroTagTokens {
  /// show list tags
  static const animatedWidget = Enums.HeroTagsTypes.FromAnimatedList;
  static const movieCard = Enums.HeroTagsTypes.FromMoviesCard;
  static const myList = Enums.HeroTagsTypes.FromMyList;
  static const movies = Enums.HeroTagsTypes.FromMovies;
  static const series = Enums.HeroTagsTypes.FromSeries;
  static const anime = Enums.HeroTagsTypes.FromAnime;
}
