import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/domain/entities/song/song.dart';

class SongModel{
  String ? title;
  String ? artist;
  num ? duration;
  Timestamp ? release;
  bool ? isFavorite;
  String ? songId;

  SongModel({
    required this.title,
    required this.artist,
    required this.duration,
    required this.release,
    required this.isFavorite,
    required this.songId,
  });

SongModel.fromJson(Map<String, dynamic> data) {
  title = data['title'] ?? 'Unknown Title';
  artist = data['artist'] ?? 'Unknown Artist';
  duration = data['duration'] ?? 0;
  release = data['release'] ?? Timestamp.now();
  isFavorite = data['isFavorite'] ?? false;
  songId = data['songId'] ?? '';
}
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      title: title ?? 'Unknown Title',
      artist: artist ?? 'Unknown Artist',
      duration: duration ?? 0,
      release: release ?? Timestamp.now(),
      isFavorite: isFavorite ?? false,
      songId: songId ?? '',
    );
  }
}
