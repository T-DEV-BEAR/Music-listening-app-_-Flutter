import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/data/models/albums/album.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/usecases/album/is_favorite_album.dart';
import 'package:spotify/service_locator.dart';

abstract class AlbumFirebaseService { 
  Future<Either> getAlbums();
  Future<Either> addOrRemoveFavoriteAlbums(String albumId);
  Future<bool> isFavoriteAlbums(String albumId);
  Future<Either> getUserFavoriteAlbums();
  Future<AlbumEntity> getAlbumWithSongs(String albumId);
}

class AlbumFirebaseServiceImpl extends AlbumFirebaseService {
  @override
  Future<Either> getAlbums() async {
    try {
      List<AlbumEntity> albums = [];
      var data = await FirebaseFirestore.instance
          .collection("Albums")
          .orderBy("releaseDate", descending: true)
          .get();
      // ignore: avoid_print
      print('Fetched ${data.docs.length} documents from Albums collection');

      for (var element in data.docs) {
        var albumData = element.data();
        // ignore: avoid_print
        print('Data for album: $albumData');
        // ignore: avoid_print
        print('Processing document: ${element.id} with data: $albumData');


        var albumModel = AlbumModel.fromJson(albumData);
        bool isFavoriteAlbum = await sl<IsFavoriteAlbumUseCase>().call(
          params: element.reference.id,
        );
        albumModel.isFavoriteAlbum = isFavoriteAlbum;
        albumModel.albumId = element.reference.id;
        albums.add(albumModel.toEntity());
      }
          // ignore: avoid_print
          print('Albums list length: ${albums.length}');

      return Right(albums);

    } catch (e) {
      // ignore: avoid_print
      print(e);
      // ignore: avoid_print
      print('Error in Albums: $e');
      return Left(Exception('An error occurred while fetching Albums: $e'));
    }
  }

  @override
  Future<bool> isFavoriteAlbums(String albumId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteAlbums = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('FavoritesAlbums')
          .where('albumId', isEqualTo: albumId)
          .get();

      return favoriteAlbums.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteAlbums(String albumId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavoriteAlbums;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteAlbums = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('FavoritesAlbums')
          .where('albumId', isEqualTo: albumId)
          .get();

      if (favoriteAlbums.docs.isNotEmpty) {
        await favoriteAlbums.docs.first.reference.delete();
        isFavoriteAlbums = false;
      } else {
        await firebaseFirestore
            .collection('Users')
            .doc(uId)
            .collection('FavoritesAlbums')
            .add({'albumId': albumId, 'addedDate': Timestamp.now()});
        isFavoriteAlbums = true;
      }

      return Right(isFavoriteAlbums);
    } catch (e) {
      return const Left('An error occurred');
    }
  }

  @override
  Future < Either > getUserFavoriteAlbums() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;
      List<AlbumEntity> favoriteAlbums = [];
      String uId = user!.uid;
      QuerySnapshot favoritesAlbumsSnapshot = await firebaseFirestore.collection(
        'Users'
      ).doc(uId)
      .collection('FavoritesAlbums')
      .get();
      
      for (var element in favoritesAlbumsSnapshot.docs) { 
        String albumId = element['albumId'];
        var album = await firebaseFirestore.collection('Albums').doc(albumId).get();
        AlbumModel albumModel = AlbumModel.fromJson(album.data()!);
        albumModel.isFavoriteAlbum = true;
        albumModel.albumId = albumId;
        favoriteAlbums.add(
          albumModel.toEntity()
        );
      }
      
      return Right(favoriteAlbums);

    } catch (e) {
      // ignore: avoid_print
      print(e);
      return const Left(
        'An error occurred'
      );
    }
  }

@override
Future<AlbumEntity> getAlbumWithSongs(String albumId) async {
  try {
    // Lấy dữ liệu của nghệ sĩ từ Firestore
    var albumsDoc = await FirebaseFirestore.instance
        .collection('Albums')
        .doc(albumId)
        .get();

    var albumsData = albumsDoc.data();
    if (albumsData != null) {
      var albumModel = AlbumModel.fromJson(albumsData);
      albumModel.albumId = albumId;

      // Chờ cho loadSongs hoàn thành
      await albumModel.loadSongs(albumId);

      // Chuyển đổi sang dạng Entity để sử dụng ở tầng domain
      return albumModel.toEntity();
    } else {
      throw Exception("Albums not found");
    }
  } catch (e) {
    print("Error getting Albums with songs: $e"); // Thêm debug log cho lỗi
    throw Exception("Error getting Albums with songs: $e");
  }
}

}
