part of 'show_lists_cubit.dart';

@immutable
abstract class ShowListsState extends Equatable {}

class ShowListsInitial extends ShowListsState {
  @override
  List<Object?> get props => [];
}

class ShowListsLoading extends ShowListsState {
  @override
  List<Object?> get props => [];
}

class ShowListsLoaded extends ShowListsState {
  final List<Show> topShows;
  final List<Show> trendingShows;
  final List<Show> englishShows;
  final List<Show> arabicShows;
  final List<Show> animeShows;
  final List<Show> userLists;

  ShowListsLoaded(
      {required this.topShows,
      required this.trendingShows,
      required this.englishShows,
      required this.arabicShows,
      required this.animeShows,
      required this.userLists});

  @override
  List<Object?> get props => [
        this.topShows,
        this.trendingShows,
        this.englishShows,
        this.arabicShows,
        this.animeShows,
        this.userLists
      ];

  ShowListsLoaded copyWith({
    List<Show>? topShows,
    List<Show>? trendingShows,
    List<Show>? englishShows,
    List<Show>? arabicShows,
    List<Show>? animeShows,
    List<Show>? userLists,
  }) {
    return ShowListsLoaded(
      topShows: topShows ?? this.topShows,
      trendingShows: trendingShows ?? this.trendingShows,
      englishShows: englishShows ?? this.englishShows,
      arabicShows: arabicShows ?? this.arabicShows,
      animeShows: animeShows ?? this.animeShows,
      userLists: userLists ?? this.userLists,
    );
  }
}

class ShowListsError extends ShowListsState {
  final String error;

  ShowListsError({required this.error});

  @override
  List<Object?> get props => [this.error];
}
