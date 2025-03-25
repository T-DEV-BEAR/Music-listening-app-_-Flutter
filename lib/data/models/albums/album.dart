import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/song/song.dart';

class AlbumModel {
  String? title;
  bool? isFavoriteAlbum;
  String? albumId;
  Timestamp? releaseDate;
  num? year;
  String? artist;
  List<SongEntity> songs = []; // List to store multiple songs

  AlbumModel({
    this.title,
    this.isFavoriteAlbum,
    this.albumId,
    this.releaseDate,
    this.songs = const [],
    this.year,
    this.artist,
  });

  // Constructor from JSON with null checks
  AlbumModel.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? 'Unknown Title';
    releaseDate = json['releaseDate'];
    albumId = json['albumId'];
    isFavoriteAlbum = json['isFavoriteAlbum'] ?? false;
    year = json['year'];
    artist = json['artist'];
  }

  Future<void> loadSongs(String albumId) async {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  try {
    var songCollection = firebaseFirestore
        .collection('Albums')
        .doc(albumId)
        .collection('albumSongs');

    var songDocs = await songCollection.get();

    // Kiểm tra và in số lượng bài hát lấy được
    print("Số bài hát lấy được cho nghệ sĩ $albumId: ${songDocs.docs.length}");

    // Map từng tài liệu sang SongEntity
    songs = songDocs.docs.map((doc) {
      var data = doc.data();
      print("Dữ liệu bài hát: $data"); // In dữ liệu bài hát để debug
      return SongEntity(
        title: data['title'] ?? 'Unknown Title',
        artist: data['artist'] ?? 'Unknown Artist',
        songId: data['songId'] ?? '',
        duration: data['duration'] ?? 0,
        release: data['release'] ?? Timestamp.now(),
        isFavorite: data['isFavorite'] ?? false,
      );
    }).toList();
  } catch (e) {
    print("Error loading songs for artist $albumId: $e"); // In ra lỗi nếu có
  }
}

}

extension AlbumModelX on AlbumModel {
  AlbumEntity toEntity() {
    return AlbumEntity (
      title: title ?? 'Unknown Title',
      isFavoriteAlbum: isFavoriteAlbum ?? false,
      albumId: albumId ?? '',
      releaseDate: releaseDate ?? Timestamp.now(),
      songs: songs,
      year: year?? 0,
      artist: artist?? 'Unknown Artist',
    );
  }
}
