import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/usecases/podcast/add_or_remove_favorite_podcasts.dart';
import 'package:spotify/domain/usecases/podcast/get_favorite_podcasts.dart';
import 'package:spotify/presentation/authen/bloc/favorite_podcast_state.dart';
import 'package:spotify/service_locator.dart';

class FavoritePodcastCubit extends Cubit<FavoritePodcastsState> {
  FavoritePodcastCubit() : super(FavoritePodcastsLoading());

  List<PodcastEntity> favoritePodcasts = [];

  Future<void> getFavoritePodcasts() async {
    // Emit loading state when fetching favorite Podcasts
    emit(FavoritePodcastsLoading());

    var result = await sl<GetFavoritePodcastsUseCase>().call();

    result.fold(
      (failure) {
        emit(FavoritePodcastsFailure());
      },
      (podcasts) {
        favoritePodcasts = podcasts;
        emit(FavoritePodcastsLoaded(favoritePodcasts: favoritePodcasts));
      },
    );
  }

  Future<void> toggleFavoritePodcasts(PodcastEntity podcast) async {
    // Call use case to add or remove the Podcast from Firebase
    var result = await sl<AddOrRemoveFavoritePodcastsUseCase>().call(params: podcast.podcastId);

    result.fold(
      (failure) {
        emit(FavoritePodcastsFailure());
      },
      (isFavoritePodcast) {
        if (isFavoritePodcast) {
          // If the Podcast was added to the favorites
          if (!favoritePodcasts.any((p) => p.podcastId == podcast.podcastId)) {
            favoritePodcasts.add(podcast);
          }
        } else {
          // If the Podcast was removed from the favorites
          favoritePodcasts.removeWhere((p) => p.podcastId == podcast.podcastId);
        }

        // Emit the updated state with the new favorite list
        emit(FavoritePodcastsLoaded(favoritePodcasts: List.from(favoritePodcasts)));
      },
    );
  }

  // Method to add an Podcast to the favorites list
  void addPodcasts(PodcastEntity podcast) {
    if (!favoritePodcasts.any((p) => p.podcastId == podcast.podcastId)) {
      favoritePodcasts.add(podcast);
      emit(FavoritePodcastsLoaded(favoritePodcasts: List.from(favoritePodcasts)));
    }
  }

  // Method to remove an Podcast from the favorites list
  void removePodcasts(PodcastEntity podcast) {
    favoritePodcasts.removeWhere((p) => p.podcastId == podcast.podcastId);
    emit(FavoritePodcastsLoaded(favoritePodcasts: List.from(favoritePodcasts)));
  }

  // Method to check if an Podcast is in the favorites list
  bool isFavorite(PodcastEntity podcast) {
    return favoritePodcasts.any((p) => p.podcastId == podcast.podcastId);
  }
}
