import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/data/models/song/song.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/song/is_favorite_song.dart';
import 'package:spotify/service_locator.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();
  Future<Either> getPlayList();
  Future<Either> addOrRemoveFavoriteSongs(String songId);
  Future<bool> isFavoriteSong(String songId);
  Future<Either> getUserFavoriteSongs();
  Future<Either> getNewsEpisoded();
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<Either> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('release', descending: true)
          .get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());
        bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
          params: element.reference.id 
        );
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return const Left('An error occurred, Please try again.');
    }
  }

  @override
  Future<Either> getPlayList() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('release', descending: true)
          .get();

      for (var element in data.docs) {
        var songModel = SongModel.fromJson(element.data());
        bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
          params: element.reference.id 
        );
        songModel.isFavorite = isFavorite;
        songModel.songId = element.reference.id;
        songs.add(songModel.toEntity());
      }

      return Right(songs);
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return const Left('An error occurred, Please try again.');
    }
  }

  @override
  Future<Either> addOrRemoveFavoriteSongs(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavorite;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSongs = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favoriteSongs.docs.isNotEmpty) {
        await favoriteSongs.docs.first.reference.delete();
        isFavorite = false;
      } else {
        await firebaseFirestore
            .collection('Users')
            .doc(uId)
            .collection('Favorites')
            .add({'songId': songId, 'addedDate': Timestamp.now()});
        isFavorite = true;
      }

      return Right(isFavorite);
    } catch (e) {
      return const Left('An error occurred');
    }
  }
  
  @override
  Future<bool> isFavoriteSong(String songId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoriteSongs = await  firebaseFirestore.collection('Users')
      .doc(uId)
      .collection('Favorites')
      .where(
        'songId',isEqualTo: songId
      ).get();

      if(favoriteSongs.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch(e){
      return false;
    }
  }

@override
  Future < Either > getUserFavoriteSongs() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;
      List<SongEntity> favoriteSongs = [];
      String uId = user!.uid;
      QuerySnapshot favoritesSnapshot = await firebaseFirestore.collection(
        'Users'
      ).doc(uId)
      .collection('Favorites')
      .get();
      
      for (var element in favoritesSnapshot.docs) { 
        String songId = element['songId'];
        var song = await firebaseFirestore.collection('Songs').doc(songId).get();
        SongModel songModel = SongModel.fromJson(song.data()!);
        songModel.isFavorite = true;
        songModel.songId = songId;
        favoriteSongs.add(
          songModel.toEntity()
        );
      }
      
      return Right(favoriteSongs);

    } catch (e) {
      // ignore: avoid_print
      print(e);
      return const Left(
        'An error occurred'
      );
    }
  }

  @override
Future<Either> getNewsEpisoded() async {
  try {
    List<SongEntity> songepisoded = [];
    DateTime today = DateTime.now();
    DateTime sevenDaysAgo = today.subtract(const Duration(days: 7));

    var data = await FirebaseFirestore.instance
        .collection('Songs')
        .where('release', isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
        .where('release', isLessThanOrEqualTo: Timestamp.fromDate(today))
        .orderBy('release', descending: true)
        .get();

    for (var element in data.docs) {
      var songModel = SongModel.fromJson(element.data());
      bool isFavorite = await sl<IsFavoriteSongUseCase>().call(
        params: element.reference.id,
      );
      songModel.isFavorite = isFavorite;
      songModel.songId = element.reference.id;
      songepisoded.add(songModel.toEntity());
    }

    return Right(songepisoded);
  } catch (e) {
    // ignore: avoid_print
    print(e);
    return const Left('An error occurred, Please try again.');
  }
}
}
