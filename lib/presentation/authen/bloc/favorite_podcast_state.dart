import 'package:spotify/domain/entities/podcast/podcast.dart';

abstract class FavoritePodcastsState {}

class FavoritePodcastsLoading extends FavoritePodcastsState {}

class FavoritePodcastsLoaded extends FavoritePodcastsState {
  final List<PodcastEntity> favoritePodcasts;
  FavoritePodcastsLoaded({required this.favoritePodcasts});
}

class FavoritePodcastsFailure extends FavoritePodcastsState {}