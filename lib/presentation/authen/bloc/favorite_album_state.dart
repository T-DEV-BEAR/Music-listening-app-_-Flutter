import 'package:spotify/domain/entities/album/album.dart';

abstract class FavoriteAlbumsState {}

class FavoriteAlbumsLoading extends FavoriteAlbumsState {}

class FavoriteAlbumsLoaded extends FavoriteAlbumsState {
  final List<AlbumEntity> favoriteAlbums;
  FavoriteAlbumsLoaded({required this.favoriteAlbums});
}

class FavoriteAlbumsFailure extends FavoriteAlbumsState {}