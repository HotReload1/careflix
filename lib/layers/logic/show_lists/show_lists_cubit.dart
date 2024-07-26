import 'package:bloc/bloc.dart';
import 'package:careflix/core/app/state/app_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';
import '../../data/model/show.dart';
import '../../data/repository/lists_repository.dart';

part 'show_lists_state.dart';

class ShowListsCubit extends Cubit<ShowListsState> {
  ShowListsCubit() : super(ShowListsInitial());

  final _listsRepo = sl<ListsRepository>();

  getShowLists(BuildContext context) async {
    emit(ShowListsLoading());

    List<String> userListIds =
        Provider.of<AppState>(context, listen: false).userModel!.userListIds ??
            [];

    try {
      List responses = await Future.wait([
        _listsRepo.getTopShows(),
        _listsRepo.getTrendingShows(),
        _listsRepo.getEnglishShows(),
        _listsRepo.getArabicShows(),
        _listsRepo.getAnimeShows(),
        _listsRepo.getUserList(userListIds)
      ]);
      emit(ShowListsLoaded(
        topShows: responses[0],
        trendingShows: responses[1],
        englishShows: responses[2],
        arabicShows: responses[3],
        animeShows: responses[4],
        userLists: responses[5],
      ));
    } catch (e) {
      emit(ShowListsError(error: "Error"));
    }
  }

  changeUserLists(List<String> ids) async {
    if (state is ShowListsLoaded) {
      try {
        final res = await _listsRepo.getUserList(ids);
        emit((state as ShowListsLoaded).copyWith(userLists: res));
      } catch (e) {
        emit(ShowListsError(error: "Error"));
      }
    }
  }
}
