import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/usecases/album/add_or_remove_favorite_albums.dart';
import 'package:spotify/domain/usecases/album/get_favorite_albums.dart';
import 'package:spotify/presentation/authen/bloc/favorite_album_state.dart';
import 'package:spotify/service_locator.dart';

class FavoriteAlbumCubit extends Cubit<FavoriteAlbumsState> {
  FavoriteAlbumCubit() : super(FavoriteAlbumsLoading());

  List<AlbumEntity> favoriteAlbums = [];

  Future<void> getFavoriteAlbums() async {
    // Emit loading state when fetching favorite artists
    emit(FavoriteAlbumsLoading());

    var result = await sl<GetFavoriteAlbumsUseCase>().call();

    result.fold(
      (failure) {
        emit(FavoriteAlbumsFailure());
      },
      (albums) {
        favoriteAlbums = albums;
        emit(FavoriteAlbumsLoaded(favoriteAlbums: favoriteAlbums));
      },
    );
  }

  Future<void> toggleFavoriteAlbums(AlbumEntity album) async {
    var result = await sl<AddOrRemoveFavoriteAlbumsUseCase>().call(params: album.albumId);

    result.fold(
      (failure) {
        emit(FavoriteAlbumsFailure());
      },
      (isFavoriteAlbum) {
        if (isFavoriteAlbum) {
          // If the artist was added to the favorites
          if (!favoriteAlbums.any((al) => al.albumId == album.albumId)) {
            favoriteAlbums.add(album);
          }
        } else {
          // If the artist was removed from the favorites
          favoriteAlbums.removeWhere((al) => al.albumId == album.albumId);
        }

        // Emit the updated state with the new favorite list
        emit(FavoriteAlbumsLoaded(favoriteAlbums: List.from(favoriteAlbums)));
      },
    );
  }

  // Method to add an artist to the favorites list
  void addAlbums(AlbumEntity album) {
    if (!favoriteAlbums.any((al) => al.albumId == album.albumId)) {
      favoriteAlbums.add(album);
      emit(FavoriteAlbumsLoaded(favoriteAlbums: List.from(favoriteAlbums)));
    }
  }

  // Method to remove an artist from the favorites list
  void removeAlbums(AlbumEntity album) {
    favoriteAlbums.removeWhere((al) => al.albumId == album.albumId);
    emit(FavoriteAlbumsLoaded(favoriteAlbums: List.from(favoriteAlbums)));
  }

  // Method to check if an artist is in the favorites list
  bool isFavorite(AlbumEntity album) {
    return favoriteAlbums.any((al) => al.albumId == album.albumId);
  }
}
