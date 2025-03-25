import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/domain/entities/song/song.dart';

class AlbumEntity {
  final String title;
  final bool isFavoriteAlbum;
  final String albumId;
  final num year;
  final String artist;
  final Timestamp releaseDate;
  final List<SongEntity> songs;

  AlbumEntity({
    required this.title,
    required this.isFavoriteAlbum,
    required this.albumId,
    required this.releaseDate,
    required this.songs,
    required this.year,
    required this.artist,
  });

  // Copy method to update specific properties while keeping others intact
  AlbumEntity copyWith({
    String? title,
    bool? isFavoriteAlbum,
    String? albumId,
    Timestamp? releaseDate,
    List<SongEntity>? songs,
    num? year,
    String? artist,
  }) {
    return AlbumEntity(
      title: title ?? this.title,
      isFavoriteAlbum: isFavoriteAlbum ?? this.isFavoriteAlbum,
      albumId: albumId ?? this.albumId,
      releaseDate: releaseDate ?? this.releaseDate,
      songs: songs ?? this.songs,
      year: year?? this.year,
      artist: artist?? this.artist,
    );
  }
}
