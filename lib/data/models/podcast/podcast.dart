import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';

class PodcastModel {
  String? title;
  String? podcast;
  bool? isFavoritePodcast;
  String? podcastId;
  Timestamp? release;

  PodcastModel({
    this.title,
    this.podcast,
    this.isFavoritePodcast,
    this.podcastId,
    this.release,
  });

  // Constructor from Json with null checks
  PodcastModel.fromJson(Map<String, dynamic> pod) {
    title = pod['title'];
    podcast = pod['podcast'];
    isFavoritePodcast = pod['isFavoritePodcast'];
    podcastId = pod['podcastId'];
    release = pod['release'];
  }
}

extension PodcastModelX on PodcastModel {
  PodcastEntity toEntity() {
    return PodcastEntity(
      title: title ?? 'Unknown Title',
      podcast: podcast ?? 'Unknown Podcast',
      isFavoritePodcast: isFavoritePodcast ?? false,
      podcastId: podcastId ?? '',
      release: release ?? Timestamp.now(), // Or handle it appropriately
    );
  }
}
