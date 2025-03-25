import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/artist/get_artists.dart';
import 'package:spotify/presentation/bloc/get_artists_state.dart';

import '../../../service_locator.dart';

class GetArtistCubit extends Cubit<GetArtistsState> {

  GetArtistCubit() : super(GetArtistsLoading());

  Future<void> getArtists() async {
  var returnedArtists = await sl<GetArtistsUseCase>().call();
  returnedArtists.fold(
    (l) {
      // ignore: avoid_print
      print('Failed to load artists: $l');
      emit(GetArtistsLoadFailure());
    },
    (data) {
      // ignore: avoid_print
      print('Artists loaded: ${data.length}');
      emit(GetArtistsLoaded(artists: data));
    }
  );
  }
}