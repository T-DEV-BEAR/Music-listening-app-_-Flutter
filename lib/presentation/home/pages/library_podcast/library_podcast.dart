import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/authen/bloc/favorite_podcast_cubit.dart';
import 'package:spotify/presentation/authen/bloc/favorite_podcast_state.dart';
import 'package:spotify/presentation/song_player/pages/podcast_player.dart';

class LibraryPodcast extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const LibraryPodcast({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  _LibraryPodcastState createState() => _LibraryPodcastState();
}

class _LibraryPodcastState extends State<LibraryPodcast> {
  List<PodcastEntity> _podcasts = [];

  @override
  void initState() {
    super.initState();
    _podcasts = widget.podcasts;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritePodcastCubit, FavoritePodcastsState>(
      builder: (context, state) {
        if (state is FavoritePodcastsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoritePodcastsLoaded) {
          _podcasts = state.favoritePodcasts;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _podcasts.map((podcast) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: LibraryPodcastSection(
                  podcast: podcast,
                  songs: widget.songs,
                  currentIndex: widget.currentIndex,
                  artists: widget.artists,
                  podcasts: widget.podcasts,
                  albums: widget.albums,
                ),
              );
            }).toList(),
          );
        } else if (state is FavoritePodcastsFailure) {
          return const Center(
            child: Text(
              "Không thể tải danh sách nghệ sĩ",
              style: TextStyle(
                fontFamily: "AB",
                fontSize: 18,
                color: AppColors.lightBg,
              ),
            ),
          );
        } else {
          return const Center(
            child: Text(
              "Trạng thái không xác định",
              style: TextStyle(
                fontFamily: "AB",
                fontSize: 18,
                color: AppColors.lightBg,
              ),
            ),
          );
        }
      },
    );
  }
}

class LibraryPodcastSection extends StatelessWidget {
  final PodcastEntity podcast;
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const LibraryPodcastSection({
    super.key,
    required this.podcast,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => PodcastPlayer(
              currentIndex: currentIndex,
              podcasts: podcasts,
            ),
          ),
        );
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
                8), // Đặt giá trị thành 0 để không có góc bo tròn
            child: Image.network(
            '${AppURLs.podcaseCoverFirestorage}${podcast.podcast} - ${podcast.title}.jpg?${AppURLs.mediaAlt}',
              width: 60, // Kích thước chiều rộng và chiều cao của hình vuông
              height: 60,
              fit: BoxFit.cover, // Đảm bảo ảnh phủ đầy khuôn hình
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                podcast.title,
                style: const TextStyle(
                  fontFamily: "AB",
                  fontSize: 14,
                  color: AppColors.lightBg,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Podcast - ${podcast.podcast}",
                style: const TextStyle(
                  fontFamily: "AM",
                  color: AppColors.lightGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
