import 'package:careflix/core/enum.dart';
import 'package:careflix/layers/view/search_screen/filters/show_filter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowFilterCubit extends Cubit<ShowFilterState> {
  ShowFilterCubit() : super(const ShowFilterState());

  onChangeFilterData(
      {int? dateYear, ShowLan? showType, List<String>? selectedCategories}) {
    emit(state.copyWith(
      dateYear: dateYear,
      showType: showType,
      selectedCategories: selectedCategories,
    ));
  }

  resetFilterData() {
    emit(ShowFilterState());
  }

  addCategory(String category) {
    List<String> categories = List.from(state.selectedCategories);
    if (!categories.contains(category)) {
      categories.add(category);
      emit(state.copyWith(
        selectedCategories: categories,
      ));
    }
  }

  removeCategory(String category) {
    List<String> categories = List.from(state.selectedCategories);
    if (categories.contains(category)) {
      categories.remove(category);
      emit(state.copyWith(
        selectedCategories: categories,
      ));
    }
  }
}
