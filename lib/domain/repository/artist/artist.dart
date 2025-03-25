import 'package:dartz/dartz.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
abstract class ArtistRepository{
  Future<Either> getArtists();
  Future<bool> isFavoriteArtists(String artistId);
  Future<Either> addOrRemoveFavoriteArtists(String artistId);
  Future<Either> getUserFavoriteArtists();
  Future<ArtistEntity> getArtistWithSongs(String artistId);
}
