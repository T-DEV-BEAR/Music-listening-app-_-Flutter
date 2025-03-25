import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;
  bool isRepeating = false;
  bool isLoading = false; // Thêm cờ kiểm tra
  bool isRandom = false;
  List<SongEntity> songs = [];
  int currentIndex = 0;
  bool _isDisposed = false;
  String? currentSongUrl; // Store the current song URL
  Function? onSongComplete; // Callback to notify when a song completes
  List<int> playedIndices = []; // List of songs already played

  SongPlayerCubit() : super(SongPlayerLoading()) {
    _initializeAudioPlayer();
  }

  void _initializeAudioPlayer() {
    audioPlayer.positionStream.listen(
      (position) {
        if (!_isDisposed) {
          songPosition = position;
          emitUpdatedState();
        }
      },
      onError: (error) {
        // ignore: avoid_print
        print('Error in position stream: $error');
      },
    );

    audioPlayer.durationStream.listen(
      (duration) {
        if (!_isDisposed && duration != null) {
          songDuration = duration;
          emitUpdatedState();
        }
      },
    );

    audioPlayer.playerStateStream.listen(
      (playerState) {
        if (!_isDisposed &&
            playerState.processingState == ProcessingState.completed) {
          _handleCompletion();
        }
      },
      onError: (error) {
        // ignore: avoid_print
        print('Error in player state stream: $error');
      },
    );
  }

 void setSongQueue(List<SongEntity> queue, int startIndex, Function onComplete) {
    if (_isDisposed) return;
    songs = queue;
    currentIndex = startIndex;
    playedIndices = [currentIndex];
    onSongComplete = onComplete;

    // Chỉ gọi loadSong một lần khi cài đặt hàng đợi
    String url = '${AppURLs.songFirestorage}${songs[currentIndex].artist} - ${songs[currentIndex].title}.mp3?${AppURLs.mediaAlt}';
    loadSong(url, autoPlay: true);
  }
  
  void emitUpdatedState() {
    if (!_isDisposed) {
      emit(SongPlayerLoaded(
        position: songPosition,
        duration: songDuration,
        isRepeating: isRepeating,
        isRandom: isRandom,
        songs: songs,
        currentIndex: currentIndex,
      ));
    }
  }

  void seekTo(Duration position) {
    if (!_isDisposed) {
      audioPlayer.seek(position);
    }
  }

    Future<void> loadSong(String url, {bool autoPlay = true}) async {
    if (_isDisposed || isLoading) return; // Ngăn gọi lại khi đang tải
    isLoading = true;

    try {
      currentSongUrl = url;
      await audioPlayer.setUrl(url);
      if (autoPlay) {
        audioPlayer.play();
      }
      emitUpdatedState();
    } catch (e) {
      if (!_isDisposed) {
        emit(SongPlayerFailure());
      }
    } finally {
      isLoading = false; // Đặt lại cờ sau khi hoàn tất
    }
  }

  void playOrPauseSong() {
    if (_isDisposed) return;
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    emitUpdatedState();
  }

  void playNextSong() {
    if (songs.isNotEmpty) {
      if (isRandom) {
        int randomIndex;
        do {
          randomIndex = Random().nextInt(songs.length);
        } while (playedIndices.contains(randomIndex) && playedIndices.length < songs.length);

        currentIndex = randomIndex;
        playedIndices.add(currentIndex);

        if (playedIndices.length == songs.length) {
          playedIndices.clear();
        }
      } else {
        currentIndex = (currentIndex + 1) % songs.length;
      }

      // Load the next song
      loadSong(
        '${AppURLs.songFirestorage}${songs[currentIndex].artist} - ${songs[currentIndex].title}.mp3?${AppURLs.mediaAlt}',
      );

      // Trigger the onSongComplete callback
      onSongComplete?.call(currentIndex);
    }
  }


  void playPreviousSong() {
    if (songs.isNotEmpty) {
      currentIndex = (currentIndex - 1 + songs.length) % songs.length;
      loadSong(songs[currentIndex].songId);
    }
  }

  void toggleRepeat() {
    if (!_isDisposed) {
      isRepeating = !isRepeating;
      emitUpdatedState();
    }
  }

  void toggleRandom() {
    if (!_isDisposed) {
      isRandom = !isRandom;
      emitUpdatedState();
    }
  }

  void _handleCompletion() {
    if (isRepeating) {
      audioPlayer.seek(Duration.zero);
      audioPlayer.play();
    } else if (isRandom) {
      playNextSong();
    } else {
      playNextSong();
    }

    onSongComplete?.call();
  }

  @override
  Future<void> close() async {
    _isDisposed = true;
    await audioPlayer.dispose();
    return super.close();
  }
}
