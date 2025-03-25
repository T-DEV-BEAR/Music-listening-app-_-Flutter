import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/artist_player/pages/artistview_screen.dart';
import 'package:spotify/presentation/authen/bloc/favorite_artist_cubit.dart';
import 'package:spotify/presentation/authen/bloc/favorite_artist_state.dart';
import 'package:spotify/presentation/bloc/get_artists_state.dart';

class LibraryAvatar extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const LibraryAvatar({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  _LibraryAvatarState createState() => _LibraryAvatarState();
}

class _LibraryAvatarState extends State<LibraryAvatar> {
  List<ArtistEntity> _artists = [];

  @override
  void initState() {
    super.initState();
    _artists = widget.artists;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteArtistCubit, FavoriteArtistsState>(
      builder: (context, state) {
        if (state is FavoriteArtistsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoriteArtistsLoaded) {
          _artists = state.favoriteArtists;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _artists.map((artist) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: LibraryArtistAvatar(
                  artist: artist,
                  songs: widget.songs,
                  currentIndex: widget.currentIndex,
                  artists: widget.artists,
                  podcasts: widget.podcasts,
                  albums: widget.albums,
                ), // Sử dụng LibraryArtistAvatar cho mỗi nghệ sĩ
              );
            }).toList(),
          );
        } else if (state is GetArtistsLoadFailure) {
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

// Widget con để hiển thị từng nghệ sĩ
class LibraryArtistAvatar extends StatelessWidget {
  final ArtistEntity artist;
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const LibraryArtistAvatar({
    super.key,
    required this.artist,
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
            builder: (BuildContext context) => ArtistviewScreen(
              artist: artist,
              songs: songs,
              currentIndex: currentIndex,
              artists: artists,
              podcasts: podcasts,
              albums: albums,
            ),
          ),
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 30, // Điều chỉnh kích thước hình tròn
            backgroundImage: NetworkImage(
              '${AppURLs.artistFirestorage}${artist.name}.jpg?${AppURLs.mediaAlt}',
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                artist.name,
                style: const TextStyle(
                  fontFamily: "AB",
                  fontSize: 14,
                  color: AppColors.lightBg,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Nghệ sĩ",
                style: TextStyle(
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
