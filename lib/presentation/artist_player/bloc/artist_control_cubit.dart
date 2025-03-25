import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/artist/get_artists.dart';
import 'package:spotify/domain/usecases/artist/get_songs_from_artist.dart';
import 'package:spotify/presentation/artist_player/bloc/artist_control_state.dart';
import '../../../service_locator.dart';

// Cubit to manage artist control state
class ArtistControlCubit extends Cubit<ArtistControlState> {

  ArtistControlCubit() : super(ArtistControlLoading());

  // Method to get a list of artists
  Future<void> getArtists() async {
    var returnedArtistControl = await sl<GetArtistsUseCase>().call();
    returnedArtistControl.fold(
      (l) {
        print('Failed to load artists: $l');
        emit(ArtistControlLoadFailure());
      },
      (data) {
        print('Artists loaded: ${data.length}');
        emit(ArtistControlLoaded(artists: data));
      }
    );
  }

  // Method to get songs from a specific artist by artistId
  Future<void> getSongsFromArtist(String artistId) async {
    var returnedSongs = await sl<GetSongsFromArtistUseCase>().call(params: artistId);
    returnedSongs.fold(
      (l) {
        print('Failed to load songs for artist $artistId: $l');
        emit(ArtistControlLoadFailure());
      },
      (artistWithSongs) {
        if (artistWithSongs.songs.isNotEmpty) {
          print('Songs loaded for artist $artistId: ${artistWithSongs.songs.length} songs');
        } else {
          print('Artist $artistId has no songs');
        }
        emit(ArtistControlLoaded(artists: [artistWithSongs])); 
      }
    );
  }
}

