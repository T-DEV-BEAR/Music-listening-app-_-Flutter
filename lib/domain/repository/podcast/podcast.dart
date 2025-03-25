import 'package:dartz/dartz.dart';
abstract class PodcastRepository{
  Future<Either> getPodcasts();
  Future<bool> isFavoritePodcasts(String podcastId);
  Future<Either> addOrRemoveFavoritePodcasts(String podcastId);
  Future<Either> getUserFavoritePodcasts();
}
