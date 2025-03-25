import 'package:spotify/domain/entities/album/album.dart';

abstract class AlbumControlState {}

class AlbumControlLoading extends AlbumControlState {}

class AlbumControlLoaded extends AlbumControlState {
  final List<AlbumEntity> albums;

  AlbumControlLoaded({required this.albums});
}

class AlbumControlLoadFailure extends AlbumControlState {}