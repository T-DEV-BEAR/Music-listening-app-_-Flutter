import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:spotify/domain/usecases/song/get_favorite_songs.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:spotify/service_locator.dart';

enum SortOption { recent, recentlyAdded, alphabetical }

class FavoriteSongsCubit extends Cubit<FavoriteSongsState> {
  FavoriteSongsCubit() : super(FavoriteSongsLoading());
  List<SongEntity> favoriteSongs = [];

  Future<void> getFavoriteSongs() async {
    emit(FavoriteSongsLoading());

    var result = await sl<GetFavoriteSongsUseCase>().call();

    result.fold(
      (failure) {
        emit(FavoriteSongsFailure());
      },
      (songs) {
        favoriteSongs = songs;
        emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
      },
    );
  }

  Future<void> toggleFavoriteSong(SongEntity song) async {
    var result = await sl<AddOrRemoveFavoriteSongUseCase>().call(params: song.songId);

    result.fold(
      (failure) {
        emit(FavoriteSongsFailure());
      },
      (isFavorite) {
        if (isFavorite) {
          if (!favoriteSongs.contains(song)) {
            favoriteSongs.add(song);
          }
        } else {
          favoriteSongs.removeWhere((s) => s.songId == song.songId);
        }

        emit(FavoriteSongsLoaded(favoriteSongs: List.from(favoriteSongs)));
      },
    );
  }

  void addSong(SongEntity song) {
    if (!favoriteSongs.contains(song)) {
      favoriteSongs.add(song);
      emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
    }
  }

  void removeSong(SongEntity song) {
    favoriteSongs.removeWhere((s) => s.songId == song.songId);
    emit(FavoriteSongsLoaded(favoriteSongs: List.from(favoriteSongs)));
  }

  void removeSongAtIndex(int index) {
    if (index >= 0 && index < favoriteSongs.length) {
      favoriteSongs.removeAt(index);
      emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
    }
  }

  bool isFavorite(SongEntity song) {
    return favoriteSongs.any((s) => s.songId == song.songId);
  }

  void sortSongs(SortOption option) {

  // Thay đổi trực tiếp danh sách favoriteSongs
  switch (option) {
    case SortOption.recent:
      favoriteSongs.sort((a, b) => b.duration.compareTo(a.duration));
      break;
    case SortOption.recentlyAdded:
      favoriteSongs.sort((a, b) => b.release.compareTo(a.release));
      break;
    case SortOption.alphabetical:
      favoriteSongs.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      break;
  }
  // Phát hành danh sách đã sắp xếp trực tiếp để BlocBuilder cập nhật
    emit(FavoriteSongsLoaded(favoriteSongs: List.from(favoriteSongs)));
}

}
