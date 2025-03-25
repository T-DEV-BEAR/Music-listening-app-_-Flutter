import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_song_button.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:marquee/marquee.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerPage extends StatefulWidget {
  final List<SongEntity> songs; // List of songs
  final int currentIndex; // Current index

  const SongPlayerPage({
    required this.songs,
    required this.currentIndex,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SongPlayerPageState createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;

    final cubit = context.read<SongPlayerCubit>();

    if (cubit.songs.isNotEmpty && cubit.currentIndex == currentIndex) {
      return;
    }

    // Set the song queue with onSongComplete callback
    cubit.setSongQueue(widget.songs, currentIndex, (newIndex) {
      setState(() {
        currentIndex = newIndex; // Cập nhật currentIndex
      });
    });

    // Load the first song
    cubit.loadSong(
      '${AppURLs.songFirestorage}${widget.songs[currentIndex].artist} - ${widget.songs[currentIndex].title}.mp3?${AppURLs.mediaAlt}',
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
        child: BlocBuilder<SongPlayerCubit, SongPlayerState>(
          builder: (context, state) {
            if (state is SongPlayerLoading) {
              // Hiển thị vòng tròn xoay khi đang tải nhạc
              return const Center(child: CircularProgressIndicator());
            } else if (state is SongPlayerLoaded && state.songs.isNotEmpty) {
              // Hiển thị các thành phần khác khi đã tải nhạc
              return Column(
                children: [
                  _songCover(state),
                  const SizedBox(height: 20),
                  _songDetail(state),
                  const SizedBox(height: 30),
                  _songPlayer(context),
                  const SizedBox(height: 30), // Khoảng cách giữa các thành phần
                  _songLyrics(),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _songCover(SongPlayerLoaded state) {
    if (state.songs.isEmpty || state.currentIndex >= state.songs.length) {
      return const SizedBox(); // Return an empty widget if there's no song
    }

    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            '${AppURLs.coverFirestorage}${state.songs[state.currentIndex].artist} - ${state.songs[state.currentIndex].title}.jpg?${AppURLs.mediaAlt}',
          ),
        ),
      ),
    );
  }

  Widget _songDetail(SongPlayerLoaded state) {
    if (state.songs.isEmpty || state.currentIndex >= state.songs.length) {
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
              text: state.songs[state.currentIndex].title,
              maxLength: maxTitleLength,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            _buildMarqueeText(
              text: state.songs[state.currentIndex].artist,
              maxLength: maxArtistLength,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
        FavoriteButton(
          songEntity: state.songs[state.currentIndex],
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

  Widget _songPlayer(BuildContext context) {
    final cubit = context.read<SongPlayerCubit>();
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SongPlayerLoaded && state.songs.isNotEmpty) {
          return Column(
            children: [
              Slider(
                value: cubit.songPosition.inSeconds.toDouble(),
                min: 0.0,
                max: cubit.songDuration.inSeconds.toDouble(),
                onChanged: (value) {
                  final newPosition = Duration(seconds: value.toInt());
                  cubit.seekTo(newPosition);
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(cubit.songPosition)),
                  Text(formatDuration(cubit.songDuration)),
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

  Widget _songLyrics() {
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
          // Text(
          //   'Here are the lyrics of the song...\nLine 2 of lyrics...\nLine 3 of lyrics...',
          //   style: TextStyle(fontSize: 16, color: Colors.white),
          // ),
        ],
      ),
    );
  }
}
