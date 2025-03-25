import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/usecases/artist/add_or_remove_favorite_artists.dart';
import 'package:spotify/domain/usecases/artist/get_favorite_artists.dart';
import 'package:spotify/presentation/authen/bloc/favorite_artist_state.dart';
import 'package:spotify/service_locator.dart';

class FavoriteArtistCubit extends Cubit<FavoriteArtistsState> {
  FavoriteArtistCubit() : super(FavoriteArtistsLoading());

  List<ArtistEntity> favoriteArtists = [];

  Future<void> getFavoriteArtists() async {
    // Emit loading state when fetching favorite artists
    emit(FavoriteArtistsLoading());

    var result = await sl<GetFavoriteArtistsUseCase>().call();

    result.fold(
      (failure) {
        emit(FavoriteArtistsFailure());
      },
      (artists) {
        favoriteArtists = artists;
        emit(FavoriteArtistsLoaded(favoriteArtists: favoriteArtists));
      },
    );
  }

  Future<void> toggleFavoriteArtists(ArtistEntity artist) async {
    // Call use case to add or remove the artist from Firebase
    var result = await sl<AddOrRemoveFavoriteArtistsUseCase>().call(params: artist.artistId);

    result.fold(
      (failure) {
        emit(FavoriteArtistsFailure());
      },
      (isFavoriteArtist) {
        if (isFavoriteArtist) {
          // If the artist was added to the favorites
          if (!favoriteArtists.any((a) => a.artistId == artist.artistId)) {
            favoriteArtists.add(artist);
          }
        } else {
          // If the artist was removed from the favorites
          favoriteArtists.removeWhere((a) => a.artistId == artist.artistId);
        }

        // Emit the updated state with the new favorite list
        emit(FavoriteArtistsLoaded(favoriteArtists: List.from(favoriteArtists)));
      },
    );
  }

  // Method to add an artist to the favorites list
  void addArtists(ArtistEntity artist) {
    if (!favoriteArtists.any((a) => a.artistId == artist.artistId)) {
      favoriteArtists.add(artist);
      emit(FavoriteArtistsLoaded(favoriteArtists: List.from(favoriteArtists)));
    }
  }

  // Method to remove an artist from the favorites list
  void removeArtists(ArtistEntity artist) {
    favoriteArtists.removeWhere((a) => a.artistId == artist.artistId);
    emit(FavoriteArtistsLoaded(favoriteArtists: List.from(favoriteArtists)));
  }

  // Method to check if an artist is in the favorites list
  bool isFavorite(ArtistEntity artist) {
    return favoriteArtists.any((a) => a.artistId == artist.artistId);
  }
}
