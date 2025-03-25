import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/artist/artist_firebase_service.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/repository/artist/artist.dart';
import 'package:spotify/service_locator.dart';

class ArtistRepositoryImpl extends ArtistRepository {
  @override
  Future<Either> getArtists() async {
    return await sl<ArtistFirebaseService>().getArtists();
  }

  @override
  Future<bool> isFavoriteArtists(String artistId) async {
    return await sl<ArtistFirebaseService>().isFavoriteArtists(artistId);
  }

  @override
  Future<Either> addOrRemoveFavoriteArtists(String artistId) async {
    return await sl<ArtistFirebaseService>().addOrRemoveFavoriteArtists(artistId);
  }

  @override
  Future<Either> getUserFavoriteArtists() async {
    return await sl<ArtistFirebaseService>().getUserFavoriteArtists();
  }

  @override
  Future<ArtistEntity> getArtistWithSongs(String artistId) async {
    return await sl<ArtistFirebaseService>().getArtistWithSongs(artistId);
  }
}
