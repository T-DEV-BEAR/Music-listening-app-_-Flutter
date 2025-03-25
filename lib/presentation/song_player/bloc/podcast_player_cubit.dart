import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/presentation/song_player/bloc/podcast_player_state.dart';

class PodcastPlayerCubit extends Cubit<PodcastPlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration podcastDuration = Duration.zero;
  Duration podcastPosition = Duration.zero;
  bool isRepeating = false;
  bool isRandom = false;
  List<PodcastEntity> podcasts = [];
  int currentIndex = 0;
  bool _isDisposed = false;
  String? _currentPodcastUrl;
  Function? onPodcastComplete; // Callback to notify when a song completes
  List<int> playedIndices = []; // List of podcast already played

  PodcastPlayerCubit() : super(PodcastPlayerLoading()) {
    _initializeAudioPlayer();
  }

  void _initializeAudioPlayer() {
    audioPlayer.positionStream.listen(
      (position) {
        if (!_isDisposed) {
          podcastPosition = position;
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
          podcastDuration = duration;
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

  void setSongQueue(List<PodcastEntity> queue, int startIndex, Function onComplete) {
    if (_isDisposed) return;
    podcasts = queue;
    currentIndex = startIndex;
    playedIndices = [currentIndex]; // Initialize with the first song
    onPodcastComplete = onComplete; // Set the callback
    loadSong(podcasts[currentIndex].podcastId, autoPlay: false); // Load the first song without auto-playing
  }

  void emitUpdatedState() {
    if (!_isDisposed) {
      emit(PodcastPlayerLoaded(
        position: podcastPosition,
        duration: podcastPosition,
        isRepeating: isRepeating,
        isRandom: isRandom,
        podcasts: podcasts,
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
    if (_isDisposed) return;

    // Avoid reloading if the song URL is the same as the current one
    if (_currentPodcastUrl == url) {
      emitUpdatedState();
      return;
    }

    try {
      _currentPodcastUrl = url; // Update the current song URL
      await audioPlayer.setUrl(url);
      if (autoPlay) {
        audioPlayer.play(); // Automatically play the song after loading if autoPlay is true
      }
      emitUpdatedState();
    } catch (e) {
      if (!_isDisposed) {
        emit(PodcastPlayerFailure());
      }
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
    if (podcasts.isNotEmpty) {
      if (isRandom) {
        int randomIndex;
        do {
          randomIndex = Random().nextInt(podcasts.length);
        } while (playedIndices.contains(randomIndex) && playedIndices.length < podcasts.length);

        currentIndex = randomIndex;
        playedIndices.add(currentIndex);

        if (playedIndices.length == podcasts.length) {
          playedIndices.clear();
        }
      } else {
        currentIndex = (currentIndex + 1) % podcasts.length;
      }

      loadSong(
        '${AppURLs.podcastFirestorage}${podcasts[currentIndex].podcast} - ${podcasts[currentIndex].title}.mp3?${AppURLs.mediaAlt}',
      );
    }
  }

  void playPreviousSong() {
    if (podcasts.isNotEmpty) {
      currentIndex = (currentIndex - 1 + podcasts.length) % podcasts.length;
      loadSong(podcasts[currentIndex].podcastId);
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

    onPodcastComplete?.call();
  }

  @override
  Future<void> close() async {
    _isDisposed = true;
    await audioPlayer.dispose();
    return super.close();
  }
}
