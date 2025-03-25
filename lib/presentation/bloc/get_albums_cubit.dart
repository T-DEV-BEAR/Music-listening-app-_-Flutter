import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/album/get_albums.dart';
import 'package:spotify/presentation/bloc/get_albums_state.dart';

import '../../../service_locator.dart';

class GetAlbumsCubit extends Cubit<GetAlbumsState> {

  GetAlbumsCubit() : super(GetAlbumsLoading());

  Future<void> getAlbums() async {
  var returnedAlbums = await sl<GetAlbumsUseCase>().call();
  returnedAlbums.fold(
    (l) {
      // ignore: avoid_print
      print('Failed to load artists: $l');
      emit(GetAlbumsLoadFailure());
    },
    (data) {
      // ignore: avoid_print
      print('Artists loaded: ${data.length}');
      emit(GetAlbumsLoaded(albums: data));
    }
  );
  }
}