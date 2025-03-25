import 'package:spotify/domain/entities/artist/artist.dart';

abstract class FavoriteArtistsState {}

class FavoriteArtistsLoading extends FavoriteArtistsState {}

class FavoriteArtistsLoaded extends FavoriteArtistsState {
  final List<ArtistEntity> favoriteArtists;
  FavoriteArtistsLoaded({required this.favoriteArtists});
}

class FavoriteArtistsFailure extends FavoriteArtistsState {}