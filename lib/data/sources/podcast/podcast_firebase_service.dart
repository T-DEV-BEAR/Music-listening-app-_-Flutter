import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/data/models/podcast/podcast.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/usecases/podcast/is_favorite_podcast.dart';
import 'package:spotify/service_locator.dart';

abstract class PodcastFirebaseService {
  Future<Either> getPodcasts();
  Future<Either> addOrRemoveFavoritePodcasts(String podcastId);
  Future<bool> isFavoritePodcasts(String podcastId);
  Future<Either> getUserFavoritePodcasts();
}

class PodcastFirebaseServiceImpl extends PodcastFirebaseService {
  @override
  Future<Either> getPodcasts() async {
    try {
      List<PodcastEntity> podcasts = [];
      var data = await FirebaseFirestore.instance
          .collection("Podcasts")
          .orderBy("release", descending: true)
          .get();
      
      for (var element in data.docs) {
        var podcastData = element.data();
        var podcastModel = PodcastModel.fromJson(podcastData);
        
        bool isFavoritePodcast = await sl<IsFavoritePodCastUseCase>().call(
          params: element.reference.id,
        );
        
        podcastModel.isFavoritePodcast = isFavoritePodcast;
        podcastModel.podcastId = element.reference.id;
        podcasts.add(podcastModel.toEntity());
      }
      return Right(podcasts);

    } catch (e) {
      print('Error in getPodcasts: $e');
      return Left(Exception('An error occurred while fetching Podcasts: $e'));
    }
  }

  @override
  Future<bool> isFavoritePodcasts(String podcastId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      QuerySnapshot favoritePodcasts = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('FavoritesPodcasts')
          .where('podcastId', isEqualTo: podcastId)
          .get();

      return favoritePodcasts.docs.isNotEmpty;
    } catch (e) {
      print('Error in isFavoritePodcasts: $e');
      return false;
    }
  }

  @override
  Future<Either> addOrRemoveFavoritePodcasts(String podcastId) async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      late bool isFavoritePodcast;
      var user = firebaseAuth.currentUser;
      String uId = user!.uid;

      QuerySnapshot favoritePodcast = await firebaseFirestore
          .collection('Users')
          .doc(uId)
          .collection('FavoritesPodcasts')
          .where('podcastId', isEqualTo: podcastId)
          .get();

      if (favoritePodcast.docs.isNotEmpty) {
        await favoritePodcast.docs.first.reference.delete();
        isFavoritePodcast = false;
      } else {
        await firebaseFirestore
            .collection('Users')
            .doc(uId)
            .collection('FavoritesPodcasts')
            .add({'podcastId': podcastId, 'addedDate': Timestamp.now()});
        isFavoritePodcast = true;
      }

      return Right(isFavoritePodcast);
    } catch (e) {
      print('Error in addOrRemoveFavoritePodcasts: $e');
      return Left(Exception('An error occurred'));
    }
  }

  @override
  Future<Either> getUserFavoritePodcasts() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = firebaseAuth.currentUser;

      List<PodcastEntity> favoritePodcasts = [];
      String uId = user!.uid;
      QuerySnapshot favoritesPodcastsSnapshot = await firebaseFirestore.collection(
        'Users'
      ).doc(uId)
      .collection('FavoritesPodcasts')
      .get();

      for (var element in favoritesPodcastsSnapshot.docs) { 
        String podcastId = element['podcastId'];
        var podcast = await firebaseFirestore.collection('Podcasts').doc(podcastId).get();
        PodcastModel podcastModel = PodcastModel.fromJson(podcast.data()!);
        podcastModel.isFavoritePodcast = true;
        podcastModel.podcastId = podcastId;
        favoritePodcasts.add(
          podcastModel.toEntity()
        );
      }
      return Right(favoritePodcasts);

    } catch (e) {
      print('Error in getUserFavoritePodcasts: $e');
      return Left(Exception('An error occurred'));
    }
  }
}
