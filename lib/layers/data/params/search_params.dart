import '../../../core/enum.dart';

class SearchParams {
  String? title;
  final String? year;
  final ShowLan? showLan;
  final List<String>? categories;

  SearchParams(
      {this.title = "",
      this.year = "",
      this.showLan,
      this.categories = const []});

  @override
  String toString() {
    return 'SearchParams{title: $title, year: $year, showLan: $showLan, categories: $categories}';
  }
}
