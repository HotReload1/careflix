import 'package:careflix/core/enum.dart';
import 'package:equatable/equatable.dart';

class ShowFilterState extends Equatable {
  final int? dateYear;
  final ShowLan? showLan;
  final List<String> selectedCategories;

  const ShowFilterState(
      {this.dateYear, this.showLan, this.selectedCategories = const []});

  ShowFilterState copyWith({
    int? dateYear,
    ShowLan? showType,
    List<String>? selectedCategories,
  }) {
    return ShowFilterState(
      dateYear: dateYear ?? this.dateYear,
      showLan: showType ?? this.showLan,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }

  ShowFilterState copyWithNull({
    int? dateYear,
    ShowLan? showType,
    List<String>? selectedCategories,
  }) {
    return ShowFilterState(
      dateYear: dateYear,
      showLan: showType,
      selectedCategories: [],
    );
  }

  @override
  List<Object?> get props =>
      [this.dateYear, this.showLan, this.selectedCategories];
}
