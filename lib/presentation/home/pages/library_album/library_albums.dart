import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/album_player/pages/albumview_screen.dart';
import 'package:spotify/presentation/authen/bloc/favorite_album_cubit.dart';
import 'package:spotify/presentation/authen/bloc/favorite_album_state.dart';

class LibraryAlbum extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const LibraryAlbum({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  _LibraryAlbumState createState() => _LibraryAlbumState();
}

class _LibraryAlbumState extends State<LibraryAlbum> {
  List<AlbumEntity> _albums = [];

  @override
  void initState() {
    super.initState();
    _albums = widget.albums;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteAlbumCubit, FavoriteAlbumsState>(
      builder: (context, state) {
        if (state is FavoriteAlbumsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoriteAlbumsLoaded) {
          _albums = state.favoriteAlbums;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _albums.map((album) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: LibraryAlbumSection(
                  album: album,
                  songs: widget.songs,
                  currentIndex: widget.currentIndex,
                  artists: widget.artists,
                  podcasts: widget.podcasts,
                  albums: widget.albums,
                ),
              );
            }).toList(),
          );
        } else if (state is FavoriteAlbumsFailure) {
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

class LibraryAlbumSection extends StatelessWidget {
  final AlbumEntity album;
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const LibraryAlbumSection({
    super.key,
    required this.album,
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
            builder: (BuildContext context) => AlbumviewScreen(
              album: album,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(
                8), // Đặt giá trị thành 0 để không có góc bo tròn
            child: Image.network(
              '${AppURLs.albumFirestorage}${album.title}.jpg?${AppURLs.mediaAlt}',
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
                album.title,
                style: const TextStyle(
                  fontFamily: "AB",
                  fontSize: 14,
                  color: AppColors.lightBg,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Album - ${album.artist}",
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
