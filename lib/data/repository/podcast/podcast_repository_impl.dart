import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/podcast/podcast_firebase_service.dart';
import 'package:spotify/domain/repository/podcast/podcast.dart';
import 'package:spotify/service_locator.dart';

class PodcastRepositoryImpl extends PodcastRepository {
  @override
  Future<Either> getPodcasts() async {
    return await sl<PodcastFirebaseService>().getPodcasts();
  }

  @override
  Future<bool> isFavoritePodcasts(String podcastId) async {
    return await sl<PodcastFirebaseService>().isFavoritePodcasts(podcastId);
  }

  @override
  Future<Either> addOrRemoveFavoritePodcasts(String podcastId) async {
    return await sl<PodcastFirebaseService>().addOrRemoveFavoritePodcasts(podcastId);
  }

  @override
  Future<Either> getUserFavoritePodcasts() async {
    return await sl<PodcastFirebaseService>().getUserFavoritePodcasts();
  }
}