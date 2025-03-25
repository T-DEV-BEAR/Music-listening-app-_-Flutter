import 'package:cloud_firestore/cloud_firestore.dart';

class PodcastEntity {
  final String title;
  final String podcast;
  final bool isFavoritePodcast;
  final String podcastId;
  final Timestamp release;
  
  PodcastEntity({
    required this.title,
    required this.podcast,
    required this.isFavoritePodcast,
    required this.podcastId,
    required this.release,
  });

  //Chỉ đổi các thuộc tính muốn đổi
  PodcastEntity copyWith({
    String? title,
    String? podcast,
    bool? isFavoritePodcast,
    String? podcastId,
    Timestamp? release,
  }) {
    return PodcastEntity(
      title: title?? this.title,
      podcast: podcast?? this.podcast,
      isFavoritePodcast: isFavoritePodcast?? this.isFavoritePodcast,
      podcastId: podcastId?? this.podcastId,
      release: release?? this.release,
    );
  }
}
