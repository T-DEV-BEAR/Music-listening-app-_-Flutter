import 'package:spotify/domain/entities/podcast/podcast.dart';

abstract class PodcastPlayerState {}

class PodcastPlayerLoading extends PodcastPlayerState {}

class PodcastPlayerLoaded extends PodcastPlayerState {
  final Duration position;
  final Duration duration;
  final bool isRepeating;  // Indicates if repeat is enabled
  final bool isRandom;     // Indicates if random play is enabled
  final List<PodcastEntity> podcasts;
  final int currentIndex;  // Store current index

  PodcastPlayerLoaded({
    required this.position,
    required this.duration,
    this.isRepeating = false,
    this.isRandom = false,
    required this.podcasts,
    required this.currentIndex,
  });
}

class PodcastPlayerFailure extends PodcastPlayerState {
  final String message; // Thêm thuộc tính để chứa thông điệp lỗi

  PodcastPlayerFailure({this.message = 'An unknown error occurred.'});
}

class PodcastPlayerCompleted extends PodcastPlayerState {
  final int completedIndex; // Thêm thuộc tính để chỉ số bài hát đã hoàn thành

  PodcastPlayerCompleted(this.completedIndex);
}
