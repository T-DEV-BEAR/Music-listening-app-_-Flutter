import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/favorite_button/favorite_button_state.dart';
import 'package:spotify/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:spotify/service_locator.dart';

class FavoriteButtonCubit extends Cubit<FavoriteButtonState> {
  FavoriteButtonCubit() : super(FavoriteButtonInitial());

  Future<void> toggleFavoriteStatus(String songId) async {
    emit(FavoriteButtonLoading());

    var result = await sl<AddOrRemoveFavoriteSongUseCase>().call(
      params: songId,
    );
    result.fold(
      (failure) {
        emit(FavoriteButtonFailure(error: failure.toString()));
      },
      (isFavorite) {
        emit(FavoriteButtonUpdated(isFavorite: isFavorite));
      },
    );
  }
}
