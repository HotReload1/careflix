import 'package:bloc/bloc.dart';
import 'package:careflix/core/enum.dart';
import 'package:careflix/layers/data/repository/coming_soon_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../generated/l10n.dart';
import '../../../injection_container.dart';
import '../../data/model/show.dart';

part 'coming_soon_state.dart';

class ComingSoonCubit extends Cubit<ComingSoonState> {
  ComingSoonCubit() : super(ComingSoonInitial());

  final _comingSoonRepo = sl<ComingSoonRepository>();
  ShowLan? showLan;

  getComingSoonShows() async {
    emit(ComingSoonLoading());
    try {
      final res = await _comingSoonRepo.getComingSoonShows(showLan);
      emit(ComingSoonLoaded(shows: res));
    } catch (e) {
      emit(ComingSoonError(error: S.current.thereIsAnError));
    }
  }
}
