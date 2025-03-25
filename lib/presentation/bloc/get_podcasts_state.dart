import 'package:spotify/domain/entities/podcast/podcast.dart';

abstract class GetPodcastsState {}

class GetPodcastsLoading extends GetPodcastsState {}

class GetPodcastsLoaded extends GetPodcastsState {
  final List<PodcastEntity> podcasts;
  GetPodcastsLoaded({required this.podcasts});
}

class GetPodcastsLoadFailure extends GetPodcastsState {}
