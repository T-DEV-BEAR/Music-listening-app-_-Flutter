import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_podcast_button.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/presentation/song_player/bloc/podcast_player_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/podcast_player_state.dart';
import 'package:marquee/marquee.dart';

class PodcastPlayer extends StatefulWidget {
  final List<PodcastEntity> podcasts; // List of songs
  final int currentIndex; // Current index

  const PodcastPlayer({
    required this.podcasts,
    required this.currentIndex,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PodcastPlayerPageState createState() => _PodcastPlayerPageState();
}

class _PodcastPlayerPageState extends State<PodcastPlayer> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;

    final cubit = context.read<PodcastPlayerCubit>();

    if (cubit.podcasts.isNotEmpty && cubit.currentIndex == currentIndex) {
      return;
    }

    // Set the song queue
    cubit.setSongQueue(widget.podcasts, currentIndex, (newIndex) {
      setState(() {
        currentIndex = newIndex; // Update currentIndex
      });
    });

    cubit.loadSong(
      '${AppURLs.podcastFirestorage}${widget.podcasts[currentIndex].podcast} - ${widget.podcasts[currentIndex].title}.mp3?${AppURLs.mediaAlt}',
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: BasicAppbar(
      title: const Text(
        'NHẠC ĐANG PHÁT',
        style: TextStyle(fontSize: 18),
      ),
      action: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert_rounded),
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: BlocBuilder<PodcastPlayerCubit, PodcastPlayerState>(
        builder: (context, state) {
          if (state is PodcastPlayerLoading) {
            // Hiển thị vòng tròn xoay khi đang tải nhạc
            return const Center(child: CircularProgressIndicator());
          } else if (state is PodcastPlayerLoaded && state.podcasts.isNotEmpty) {
            // Hiển thị các thành phần khác khi đã tải nhạc
            return Column(
              children: [
                _podcastCover(state),
                const SizedBox(height: 20),
                _podcastDetail(state),
                const SizedBox(height: 30),
                _podcastPlayer(context),
                const SizedBox(height: 30), // Khoảng cách giữa các thành phần
                _podcastLyrics(),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    ),
  );
}


  Widget _podcastCover(PodcastPlayerLoaded state) {
    if (state.podcasts.isEmpty || state.currentIndex >= state.podcasts.length) {
      return const SizedBox(); // Return an empty widget if there's no song
    }

    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            '${AppURLs.podcaseCoverFirestorage}${state.podcasts[state.currentIndex].podcast} - ${state.podcasts[state.currentIndex].title}.jpg?${AppURLs.mediaAlt}',
          ),
        ),
      ),
    );
  }

  Widget _podcastDetail(PodcastPlayerLoaded state) {
    if (state.podcasts.isEmpty || state.currentIndex >= state.podcasts.length) {
      return const SizedBox(); // Return an empty widget if there's no song
    }

    const int maxTitleLength = 20; // Limit for title
    const int maxArtistLength = 30; // Limit for artist name

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMarqueeText(
              text: state.podcasts[state.currentIndex].title,
              maxLength: maxTitleLength,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            _buildMarqueeText(
              text: state.podcasts[state.currentIndex].podcast,
              maxLength: maxArtistLength,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
        FavoritePodcastButton(
          podcastEntity: state.podcasts[state.currentIndex],
        ),
      ],
    );
  }

  Widget _buildMarqueeText(
      {required String text,
      required int maxLength,
      required TextStyle style}) {
    return text.length > maxLength
        ? SizedBox(
            height: 30,
            width: 300,
            child: Marquee(
              text: text,
              style: style,
              scrollAxis: Axis.horizontal,
              blankSpace: 20.0,
              velocity: 30.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10.0,
              accelerationDuration: const Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: const Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            ),
          )
        : Text(
            text,
            style: style,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          );
  }

  Widget _podcastPlayer(BuildContext context) {
  final cubit = context.read<PodcastPlayerCubit>();
  return BlocBuilder<PodcastPlayerCubit, PodcastPlayerState>(
    builder: (context, state) {
      if (state is PodcastPlayerLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is PodcastPlayerLoaded && state.podcasts.isNotEmpty) {
        return Column(
          children: [
            Slider(
              value: cubit.podcastPosition.inSeconds.toDouble(),
              min: 0.0,
              max: cubit.podcastDuration.inSeconds.toDouble(),
              onChanged: (value) {
                final newPosition = Duration(seconds: value.toInt());
                cubit.seekTo(newPosition);
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatDuration(cubit.podcastPosition)),
                Text(formatDuration(cubit.podcastDuration)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {
                    cubit.playPreviousSong();
                  },
                ),
                GestureDetector(
                  onTap: () => cubit.playOrPauseSong(),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Icon(cubit.audioPlayer.playing
                        ? Icons.pause
                        : Icons.play_arrow),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {
                    cubit.playNextSong();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                      cubit.isRepeating ? Icons.repeat_one : Icons.repeat),
                  onPressed: () => cubit.toggleRepeat(),
                ),
                IconButton(
                  icon: Icon(cubit.isRandom
                      ? Icons.shuffle_on_outlined
                      : Icons.shuffle_outlined),
                  onPressed: () => cubit.toggleRandom(),
                ),
              ],
            ),
          ],
        );
      }
      return const SizedBox();
    },
  );
}


  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _podcastLyrics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lyrics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
