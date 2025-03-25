import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/home/pages/library_liked/like_songs_screen.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_state.dart';

class LikedSongsSection extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const LikedSongsSection({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  _LikedSongsSectionState createState() => _LikedSongsSectionState();
}

class _LikedSongsSectionState extends State<LikedSongsSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
      builder: (context, state) {
        int totalSongs = 0;
        if (state is FavoriteSongsLoaded) {
          totalSongs = state.favoriteSongs.length;
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LikeSongsScreen(
                  songs: widget.songs,
                  currentIndex: widget.currentIndex,
                  artists: widget.artists,
                  podcasts: widget.podcasts,
                  albums: widget.albums,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Image.asset("assets/images/liked_songs.png"),
                    Image.asset("assets/images/icon_heart_white.png"),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bài hát ưa thích",
                      style: TextStyle(
                        fontFamily: "AM",
                        fontSize: 15,
                        color: AppColors.lightBg,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Image.asset("assets/images/icon_pin.png"),
                        const SizedBox(width: 5),
                        Text(
                          "Playlist . $totalSongs bài hát",
                          style: const TextStyle(
                            fontFamily: "AM",
                            color: AppColors.lightGrey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

