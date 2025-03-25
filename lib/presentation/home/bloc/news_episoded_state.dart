import 'package:spotify/domain/entities/song/song.dart';

abstract class NewsEpisodedState {}

class NewsEpisodedLoading extends NewsEpisodedState {}

class NewsEpisodedLoaded extends NewsEpisodedState {
  final List<SongEntity> songs;
  NewsEpisodedLoaded({required this.songs});
}

class NewsEpisodedFailure extends NewsEpisodedState {}