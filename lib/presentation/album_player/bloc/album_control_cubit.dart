import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/album/get_albums.dart';
import 'package:spotify/domain/usecases/album/get_songs_from_album.dart';
import 'package:spotify/presentation/album_player/bloc/album_control_state.dart';
import '../../../service_locator.dart';

// Cubit to manage artist control state
class AlbumControlCubit extends Cubit<AlbumControlState> {
  AlbumControlCubit() : super(AlbumControlLoading());

  Future<void> getAlbums() async {
    var returnedAlbumControl = await sl<GetAlbumsUseCase>().call();
    returnedAlbumControl.fold(
      (l) {
        print('Failed to load artists: $l');
        emit(AlbumControlLoadFailure());
      },
      (data) {
        print('Artists loaded: ${data.length}');
        emit(AlbumControlLoaded(albums: data,));
      }
    );
  }

  Future<void> getSongsFromAlbum(String albumId) async {
    var returnedSongs = await sl<GetSongsFromAlbumUseCase>().call(params: albumId);
    returnedSongs.fold(
      (l) {
        print('Failed to load songs for artist $albumId: $l');
        emit(AlbumControlLoadFailure());
      },
      (albumWithSongs) {
        if (albumWithSongs.songs.isNotEmpty) {
          print('Songs loaded for artist $albumId: ${albumWithSongs.songs.length} songs');
        } else {
          print('Artist $albumId has no songs');
        }
        emit(AlbumControlLoaded(albums: [albumWithSongs])); 
      }
    );
  }
}

