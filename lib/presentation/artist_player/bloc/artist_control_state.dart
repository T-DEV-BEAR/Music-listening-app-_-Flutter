import 'package:spotify/domain/entities/artist/artist.dart';

abstract class ArtistControlState {}

class ArtistControlLoading extends ArtistControlState {}

class ArtistControlLoaded extends ArtistControlState {
  final List<ArtistEntity> artists;
  ArtistControlLoaded({required this.artists});
}

class ArtistControlLoadFailure extends ArtistControlState {}