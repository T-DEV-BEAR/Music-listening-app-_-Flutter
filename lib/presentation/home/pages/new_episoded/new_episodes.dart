import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/home/bloc/news_episoded_cubit.dart';
import 'package:spotify/presentation/home/bloc/news_episoded_state.dart';
import 'package:spotify/presentation/home/pages/new_episoded/new_episoded_screen.dart';

class NewEpisodesSection extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const NewEpisodesSection({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  _NewEpisodesSectionState createState() => _NewEpisodesSectionState();
}

class _NewEpisodesSectionState extends State<NewEpisodesSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsEpisodedCubit, NewsEpisodedState>(
      builder: (context, state) {
        int totalSongs = 0;
        if (state is NewsEpisodedLoaded) {
          totalSongs = state.songs.length;
        }
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewEpisodedScreen(
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
                    Image.asset("assets/images/new_episods.png"),
                    Image.asset("assets/images/icon_bell_fill.png"),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Các Bài Hát Mới Cập Nhật",
                      style: TextStyle(
                        fontFamily: "AM",
                        fontSize: 15,
                        color: AppColors.lightBg,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Image.asset("assets/images/icon_pin.png"),
                        const SizedBox(width: 5),
                        Text(
                          "Updated - $totalSongs bài hát" ,
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