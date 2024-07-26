import 'package:flutter/cupertino.dart';

import '../generated/l10n.dart';

enum HeroTagsTypes {
  FromAnimatedList,
  FromMoviesCard,
  FromMyList,
  FromMovies,
  FromSeries,
  FromAnime
}

String HeroTagsEnumToString(HeroTagsTypes type) {
  switch (type) {
    case HeroTagsTypes.FromAnimatedList:
      return "FromAnimatedList";
    case HeroTagsTypes.FromMoviesCard:
      return "FromMoviesCard";
    case HeroTagsTypes.FromMyList:
      return "FromMyList";
    case HeroTagsTypes.FromMovies:
      return "FromMovies";
    case HeroTagsTypes.FromSeries:
      return "FromSeries";
    case HeroTagsTypes.FromAnime:
      return "FromAnime";
  }
}

enum Gender { Male, Female }

Gender stringToGender(String gender) {
  switch (gender) {
    case "M":
      return Gender.Male;
    case "F":
      return Gender.Female;
    default:
      return Gender.Male;
  }
}

String genderToString(Gender gender) {
  switch (gender) {
    case Gender.Male:
      return "M";
    case Gender.Female:
      return "F";
    default:
      return "M";
  }
}

enum ShowType { TV_SHOW, MOVIE }

ShowType stringToShowType(String showType) {
  switch (showType) {
    case "series":
      return ShowType.TV_SHOW;
    case "movie":
      return ShowType.MOVIE;
    default:
      return ShowType.MOVIE;
  }
}

String showTypeToString(ShowType showType) {
  switch (showType) {
    case ShowType.TV_SHOW:
      return S.current.tvShow;
    case ShowType.MOVIE:
      return S.current.movie;
    default:
      return S.current.movie;
  }
}

enum ShowLan { ENGLISH, ARABIC, ANIME }

ShowLan stringToShowLan(String showLan) {
  switch (showLan) {
    case "en":
      return ShowLan.ENGLISH;
    case "ar":
      return ShowLan.ARABIC;
    case "anime":
      return ShowLan.ANIME;
    default:
      return ShowLan.ENGLISH;
  }
}

String showLanToStringData(ShowLan showLan) {
  switch (showLan) {
    case ShowLan.ENGLISH:
      return "en";
    case ShowLan.ARABIC:
      return "ar";
    case ShowLan.ANIME:
      return "anime";
    default:
      return "en";
  }
}

ShowLan stringToShowLanFilter(String showLan) {
  if (S.current.english == showLan) {
    return ShowLan.ENGLISH;
  } else if (S.current.arab == showLan) {
    return ShowLan.ARABIC;
  } else {
    return ShowLan.ANIME;
  }
}

String showLanToString(ShowLan showLan) {
  switch (showLan) {
    case ShowLan.ENGLISH:
      return S.current.english;
    case ShowLan.ARABIC:
      return S.current.arab;
    case ShowLan.ANIME:
      return S.current.anime;
    default:
      return S.current.english;
  }
}

enum WeekDay { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }

extension WeekDayExtension on WeekDay {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

WeekDay fromString(String day) {
  return WeekDay.values
      .firstWhere((e) => e.toShortString().toLowerCase() == day.toLowerCase());
}

List<WeekDay> getWeekDaysList() {
  return WeekDay.values.map((e) => e).toList();
}
