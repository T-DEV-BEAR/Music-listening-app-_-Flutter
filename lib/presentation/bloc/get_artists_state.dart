import 'package:spotify/domain/entities/artist/artist.dart';

abstract class GetArtistsState {}

class GetArtistsLoading extends GetArtistsState {}

class GetArtistsLoaded extends GetArtistsState {
  final List<ArtistEntity> artists;
  GetArtistsLoaded({required this.artists});
}

class GetArtistsLoadFailure extends GetArtistsState {}