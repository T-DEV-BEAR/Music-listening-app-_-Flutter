import 'package:spotify/domain/entities/song/song.dart';

abstract class SongPlayerState {}

class SongPlayerLoading extends SongPlayerState {}

class SongPlayerLoaded extends SongPlayerState {
  final Duration position;
  final Duration duration;
  final bool isRepeating;  // Indicates if repeat is enabled
  final bool isRandom;     // Indicates if random play is enabled
  final List<SongEntity> songs;
  final int currentIndex;  // Store current index

  SongPlayerLoaded({
    required this.position,
    required this.duration,
    this.isRepeating = false,
    this.isRandom = false,
    required this.songs,
    required this.currentIndex,
  });
}

class SongPlayerFailure extends SongPlayerState {
  final String message; // Thêm thuộc tính để chứa thông điệp lỗi

  SongPlayerFailure({this.message = 'An unknown error occurred.'});
}

class SongPlayerCompleted extends SongPlayerState {
  final int completedIndex; // Thêm thuộc tính để chỉ số bài hát đã hoàn thành

  SongPlayerCompleted(this.completedIndex);
}
