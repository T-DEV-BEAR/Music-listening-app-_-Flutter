import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/helpers/if_dark.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/artist_player/pages/artistview_screen.dart';
import 'package:spotify/presentation/bloc/get_artists_cubit.dart';
import 'package:spotify/presentation/bloc/get_artists_state.dart';

class NewsArtists extends StatelessWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const NewsArtists(
      {super.key,
      required this.songs,
      required this.currentIndex,
      required this.artists,
      required this.podcasts,
      required this.albums});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetArtistCubit()..getArtists(),
      child: SizedBox(
          height: 200,
          child: BlocBuilder<GetArtistCubit, GetArtistsState>(
            builder: (context, state) {
              if (state is GetArtistsLoading) {
                return Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator());
              }

              if (state is GetArtistsLoaded) {
                return _artists(state.artists);
              }
              return Container();
            },
          )),
    );
  }

  Widget _artists(List<ArtistEntity> artists) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ArtistviewScreen(
                  artist: artists[index],
                  songs: songs,
                  currentIndex: currentIndex,
                  artists: artists,
                  podcasts: podcasts,
                  albums: albums,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  '${AppURLs.artistFirestorage}${artists[index].name}.jpg?${AppURLs.mediaAlt}'))),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 40,
                          width: 40,
                          transform: Matrix4.translationValues(10, 10, 0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.isDarkmode
                                  ? AppColors.darkGreyText
                                  : const Color(0xffE6E6E6)),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: context.isDarkmode
                                ? const Color(0xff959595)
                                : const Color(0xff555555),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    artists[index].name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 14,
      ),
      itemCount: artists.length,
    );
  }
}
