part of 'coming_soon_cubit.dart';

@immutable
abstract class ComingSoonState extends Equatable {}

class ComingSoonInitial extends ComingSoonState {
  @override
  List<Object?> get props => [];
}

class ComingSoonLoading extends ComingSoonState {
  @override
  List<Object?> get props => [];
}

class ComingSoonLoaded extends ComingSoonState {
  final List<Show> shows;

  ComingSoonLoaded({
    required this.shows,
  });

  @override
  List<Object?> get props => [
        this.shows,
      ];
}

class ComingSoonError extends ComingSoonState {
  final String error;

  ComingSoonError({required this.error});

  @override
  List<Object?> get props => [this.error];
}
