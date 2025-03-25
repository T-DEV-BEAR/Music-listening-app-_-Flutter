import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/domain/entities/song/song.dart';

class ArtistModel {
  String? name;
  bool? isFavoriteArtist;
  String? artistId;
  Timestamp? releaseDate;
  List<SongEntity> songs = []; // List to store multiple songs

  ArtistModel({
    this.name,
    this.isFavoriteArtist,
    this.artistId,
    this.releaseDate,
    this.songs = const [],
  });

  // Constructor from JSON with null checks
  ArtistModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? 'Unknown Artist';
    releaseDate = json['releaseDate'];
    artistId = json['artistId'];
    isFavoriteArtist = json['isFavoriteArtist'] ?? false;
  }

  Future<void> loadSongs(String artistId) async {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  try {
    // Truy cập collection artistSongs
    var songCollection = firebaseFirestore
        .collection('Artists')
        .doc(artistId)
        .collection('artistSongs');

    var songDocs = await songCollection.get();

    // Kiểm tra và in số lượng bài hát lấy được
    print("Số bài hát lấy được cho nghệ sĩ $artistId: ${songDocs.docs.length}");

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
    print("Error loading songs for artist $artistId: $e"); // In ra lỗi nếu có
  }
}

}

extension ArtistModelX on ArtistModel {
  ArtistEntity toEntity() {
    return ArtistEntity(
      name: name ?? 'Unknown Artist',
      isFavoriteArtist: isFavoriteArtist ?? false,
      artistId: artistId ?? '',
      releaseDate: releaseDate ?? Timestamp.now(),
      songs: songs,
    );
  }
}
