import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/domain/entities/song/song.dart';

class ArtistEntity {
  final String name;
  final bool isFavoriteArtist;
  final String artistId;
  final Timestamp releaseDate;
  final List<SongEntity> songs;

  ArtistEntity({
    required this.name,
    required this.isFavoriteArtist,
    required this.artistId,
    required this.releaseDate,
    required this.songs,
  });

  // Copy method to update specific properties while keeping others intact
  ArtistEntity copyWith({
    String? name,
    bool? isFavoriteArtist,
    String? artistId,
    Timestamp? releaseDate,
    List<SongEntity>? songs,
  }) {
    return ArtistEntity(
      name: name ?? this.name,
      isFavoriteArtist: isFavoriteArtist ?? this.isFavoriteArtist,
      artistId: artistId ?? this.artistId,
      releaseDate: releaseDate ?? this.releaseDate,
      songs: songs ?? this.songs,
    );
  }
}
