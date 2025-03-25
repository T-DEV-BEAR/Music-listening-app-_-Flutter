import 'package:dartz/dartz.dart';
import 'package:spotify/domain/entities/album/album.dart';
abstract class AlbumRepository{
  Future<Either> getAlbums();
  Future<bool> isFavoriteAlbums(String albumId);
  Future<Either> addOrRemoveFavoriteAlbums(String albumId);
  Future<Either> getUserFavoriteAlbums();
  Future<AlbumEntity> getAlbumWithSongs(String albumId);
}
