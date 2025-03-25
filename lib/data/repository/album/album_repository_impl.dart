import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/album/album_firebase_service.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/repository/album/album.dart';
import 'package:spotify/service_locator.dart';

class AlbumRepositoryImpl extends AlbumRepository {
  @override
  Future<Either> getAlbums() async {
    return await sl<AlbumFirebaseService>().getAlbums();
  }

  @override
  Future<bool> isFavoriteAlbums(String albumId) async {
    return await sl<AlbumFirebaseService>().isFavoriteAlbums(albumId);
  }

  @override
  Future<Either> addOrRemoveFavoriteAlbums(String albumId) async {
    return await sl<AlbumFirebaseService>().addOrRemoveFavoriteAlbums(albumId);
  }

  @override
  Future<Either> getUserFavoriteAlbums() async {
    return await sl<AlbumFirebaseService>().getUserFavoriteAlbums();
  }

  @override
  Future<AlbumEntity> getAlbumWithSongs(String albumId) async {
    return await sl<AlbumFirebaseService>().getAlbumWithSongs(albumId);
  }
}
