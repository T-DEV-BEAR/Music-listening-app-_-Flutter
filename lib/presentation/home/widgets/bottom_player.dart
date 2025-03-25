import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_podcast_button.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/presentation/song_player/bloc/podcast_player_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/podcast_player_state.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';
import 'package:spotify/presentation/song_player/pages/podcast_player.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:marquee/marquee.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_song_button.dart';

class BottomPlayer extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;
  final SongEntity? currentSong;
  final PodcastEntity? currentPodcast;

  const BottomPlayer({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.currentSong,
    required this.currentPodcast,
    required this.albums,
  });

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  bool get isPlayingSong => widget.currentSong != null;
  bool get isPlayingPodcast => widget.currentPodcast != null;
  @override
  Widget build(BuildContext context) {
    return isPlayingPodcast && widget.currentPodcast != null
        ? BlocBuilder<PodcastPlayerCubit, PodcastPlayerState>(
            builder: (context, state) {
              final cubit = context.read<PodcastPlayerCubit>();

              if (state is PodcastPlayerLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PodcastPlayerLoaded) {
                if (state.podcasts.isEmpty ||
                    state.currentIndex >= state.podcasts.length) {
                  return const SizedBox();
                }

                final currentPodcast = state.podcasts[state.currentIndex];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: cubit,
                          child: PodcastPlayer(
                            podcasts: state.podcasts,
                            currentIndex: state.currentIndex,
                          ),
                        ),
                      ),
                    );
                  },
                  child: _buildBottomPlayerContainer(
                    imageUrl:
                        '${AppURLs.podcaseCoverFirestorage}${currentPodcast.podcast} - ${currentPodcast.title}.jpg?${AppURLs.mediaAlt}',
                    title: currentPodcast.title,
                    subtitle: currentPodcast.podcast,
                    favoriteButton: FavoritePodcastButton(
                      podcastEntity: currentPodcast,
                    ),
                    playOrPause: () {
                      cubit.playOrPauseSong();
                    },
                    isPlaying: cubit.audioPlayer.playing,
                    sliderValue: cubit.podcastPosition.inSeconds.toDouble(),
                    maxSliderValue: cubit.podcastDuration.inSeconds.toDouble(),
                    onSliderChanged: (value) {
                      final newPosition = Duration(seconds: value.toInt());
                      cubit.seekTo(newPosition);
                    },
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          )
        : BlocBuilder<SongPlayerCubit, SongPlayerState>(
  builder: (context, state) {
    final cubit = context.read<SongPlayerCubit>();

    if (state is SongPlayerLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is SongPlayerLoaded) {
      if (state.songs.isEmpty || state.currentIndex >= state.songs.length) {
        return const SizedBox();
      }

      final currentSong = state.songs[state.currentIndex];

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: cubit,
                child: SongPlayerPage(
                  songs: state.songs,
                  currentIndex: state.currentIndex,
                ),
              ),
            ),
          );
        },
        child: _buildBottomPlayerContainer(
          imageUrl:
              '${AppURLs.coverFirestorage}${currentSong.artist} - ${currentSong.title}.jpg?${AppURLs.mediaAlt}',
          title: currentSong.title,
          subtitle: currentSong.artist,
          favoriteButton: FavoriteButton(
            songEntity: currentSong,
          ),
          playOrPause: () {
            cubit.playOrPauseSong();
          },
          isPlaying: cubit.audioPlayer.playing,
          sliderValue: cubit.songPosition.inSeconds.toDouble(),
          maxSliderValue: cubit.songDuration.inSeconds.toDouble(),
          onSliderChanged: (value) {
            final newPosition = Duration(seconds: value.toInt());
            cubit.seekTo(newPosition);
          },
        ),
      );
    } else {
      return const SizedBox();
    }
  },
);

  }

  Widget _buildBottomPlayerContainer({
    required String imageUrl,
    required String title,
    required String subtitle,
    required Widget favoriteButton,
    required VoidCallback playOrPause,
    required bool isPlaying,
    required double sliderValue,
    required double maxSliderValue,
    required ValueChanged<double> onSliderChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        height: 65, // Tăng chiều cao để chứa thêm Slider
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 83, 83, 83),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 37,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 190,
                              height: 20,
                              child: _buildMarqueeText(
                                text: title,
                                maxLength: 30,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "AM",
                                  color: AppColors.lightBg,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                            _buildMarqueeText(
                              text: subtitle,
                              maxLength: 30,
                              style: const TextStyle(
                                fontFamily: "AM",
                                fontSize: 12,
                                color: AppColors.lightBg,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        favoriteButton,
                        IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppColors.lightBg,
                            size: 28,
                          ),
                          onPressed: playOrPause,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Slider cho vị trí phát
              SliderTheme(
                data: SliderThemeData(
                  overlayShape: SliderComponentShape.noOverlay,
                  thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 5), // Thêm thumb để dễ kéo
                  trackShape: const RectangularSliderTrackShape(),
                  trackHeight: 3,
                ),
                child: Slider(
                  activeColor: const Color.fromARGB(255, 230, 229, 229),
                  inactiveColor: AppColors.lightGrey,
                  value: sliderValue.clamp(
                      0.0, maxSliderValue), // Đảm bảo value không vượt quá max
                  min: 0.0,
                  max: maxSliderValue > 0
                      ? maxSliderValue
                      : 1.0, // Tránh maxSliderValue là 0
                  onChanged: (value) {
                    final newPosition = Duration(seconds: value.toInt());
                    onSliderChanged(newPosition.inSeconds
                        .toDouble()); // Cập nhật vị trí phát
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarqueeText({
    required String text,
    required int maxLength,
    required TextStyle style,
  }) {
    return text.length > maxLength
        ? SizedBox(
            height: 20,
            width: MediaQuery.of(context).size.width - 190,
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
}
