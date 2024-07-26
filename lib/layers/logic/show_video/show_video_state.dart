part of 'show_video_cubit.dart';

@immutable
abstract class ShowVideoState extends Equatable {}

class ShowVideoInitial extends ShowVideoState {
  @override
  List<Object?> get props => [];
}

class ShowVideoLoading extends ShowVideoState {
  @override
  List<Object?> get props => [];
}

class ShowVideoLoaded extends ShowVideoState {
  final List<Episode> episodes;

  ShowVideoLoaded({required this.episodes});

  @override
  List<Object?> get props => [this.episodes];
}

class ShowVideoError extends ShowVideoState {
  final String error;

  ShowVideoError({required this.error});

  @override
  List<Object?> get props => [this.error];
}
