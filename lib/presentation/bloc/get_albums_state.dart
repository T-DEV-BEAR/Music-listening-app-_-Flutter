import 'package:spotify/domain/entities/album/album.dart';

abstract class GetAlbumsState {}

class GetAlbumsLoading extends GetAlbumsState {}

class GetAlbumsLoaded extends GetAlbumsState {
  final List<AlbumEntity> albums;
  GetAlbumsLoaded({required this.albums});
}

class GetAlbumsLoadFailure extends GetAlbumsState {}