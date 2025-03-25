abstract class FavoriteButtonState {}

class FavoriteButtonInitial extends FavoriteButtonState {}

class FavoriteButtonLoading extends FavoriteButtonState {}

class FavoriteButtonUpdated extends FavoriteButtonState {
  final bool isFavorite;

  FavoriteButtonUpdated({required this.isFavorite});
}

class FavoriteButtonFailure extends FavoriteButtonState {
  final String error;

  FavoriteButtonFailure({required this.error});
}
