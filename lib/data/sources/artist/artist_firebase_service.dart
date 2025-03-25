import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/data/models/artists/artist.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/usecases/artist/is_favorite_artist.dart';
import 'package:spotify/service_locator.dart';

abstract class ArtistFirebaseService {
  Future<Either> getArtists();
  Future<Either> addOrRemoveFavoriteArtists(String artistId);
  Future<bool> isFavoriteArtists(String artistId);
  Future<Either> getUserFavoriteArtists();
  Future<ArtistEntity> getArtistWithSongs(String artistId);

}

class ArtistFirebaseServiceImpl extends ArtistFirebaseService {
  @override
  Future<Either> getArtists() async {
    try {
      List<ArtistEntity> artists = [];
      var data = await FirebaseFirestore.instance
          .collection("Artists")
          .orderBy("releaseDate", descending: true)
          .get();
      // ignore: avoid_print
      print('Fetched ${data.docs.length} documents from Artists collection');

      for (var element in data.docs) {
        var artistData = element.data();
        // ignore: avoid_print
        print('Data for artist: $artistData');
        // ignore: avoid_print
        print('Processing document: ${element.id} with data: $artistData');


        var artistModel = ArtistModel.fromJson(artistData);
        bool isFavoriteArtist = await sl<IsFavoriteArtistUseCase>().call(
          params: element.reference.id,
        );
        artistModel.isFavoriteArtist = isFavoriteArtist;
        artistModel.artistId = element.reference.id;
        artists.add(artistModel.toEntity());
      }
          // ignore: avoid_print
          print('Artists list length: ${artists.length}');

      return Right(artists);

    } catch (e) {
      // ignore: avoid_print
      print(e);
      // ignore: avoid_print
      print('Error in getArtists: $e');
      return Left(Exception('An error occurred while fetching artists: $e'));
    }
  }

  @override
  Future<bool> isFavoriteArtists(String artistId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteArtists = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('FavoritesArtists')
          .where('artistId', isEqualTo: artistId)
          .get();

      return favoriteArtists.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteArtists(String artistId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavoriteArtist;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteArtists = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('FavoritesArtists')
          .where('artistId', isEqualTo: artistId)
          .get();

      if (favoriteArtists.docs.isNotEmpty) {
        await favoriteArtists.docs.first.reference.delete();
        isFavoriteArtist = false;
      } else {
        await firebaseFirestore
            .collection('Users')
            .doc(uId)
            .collection('FavoritesArtists')
            .add({'artistId': artistId, 'addedDate': Timestamp.now()});
        isFavoriteArtist = true;
      }

      return Right(isFavoriteArtist);
    } catch (e) {
      return const Left('An error occurred');
    }
  }
  @override
  Future < Either > getUserFavoriteArtists() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;
      List<ArtistEntity> favoriteArtists = [];
      String uId = user!.uid;
      QuerySnapshot favoritesArtistsSnapshot = await firebaseFirestore.collection(
        'Users'
      ).doc(uId)
      .collection('FavoritesArtists')
      .get();
      
      for (var element in favoritesArtistsSnapshot.docs) { 
        String artistId = element['artistId'];
        var artist = await firebaseFirestore.collection('Artists').doc(artistId).get();
        ArtistModel artistModel = ArtistModel.fromJson(artist.data()!);
        artistModel.isFavoriteArtist = true;
        artistModel.artistId = artistId;
        favoriteArtists.add(
          artistModel.toEntity()
        );
      }
      
      return Right(favoriteArtists);

    } catch (e) {
      // ignore: avoid_print
      print(e);
      return const Left(
        'An error occurred'
      );
    }
  }

@override
Future<ArtistEntity> getArtistWithSongs(String artistId) async {
  try {
    // Lấy dữ liệu của nghệ sĩ từ Firestore
    var artistDoc = await FirebaseFirestore.instance
        .collection('Artists')
        .doc(artistId)
        .get();

    var artistData = artistDoc.data();
    if (artistData != null) {
      // Tạo một ArtistModel từ dữ liệu của nghệ sĩ
      var artistModel = ArtistModel.fromJson(artistData);
      artistModel.artistId = artistId;

      // Chờ cho loadSongs hoàn thành
      await artistModel.loadSongs(artistId);

      // Chuyển đổi sang dạng Entity để sử dụng ở tầng domain
      return artistModel.toEntity();
    } else {
      throw Exception("Artist not found");
    }
  } catch (e) {
    print("Error getting artist with songs: $e"); // Thêm debug log cho lỗi
    throw Exception("Error getting artist with songs: $e");
  }
}

}
