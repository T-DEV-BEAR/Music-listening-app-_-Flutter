import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/presentation/album_player/bloc/album_control_cubit.dart';
import 'package:spotify/presentation/album_player/bloc/album_control_state.dart';
import 'package:spotify/presentation/authen/bloc/favorite_album_cubit.dart';
import 'package:spotify/presentation/home/pages/share_song_screen.dart';

class AlbumControl extends StatefulWidget {
  final String albumId;
  final AlbumEntity album;

  const AlbumControl({super.key, required this.albumId, required this.album});

  @override
  _AlbumControlState createState() => _AlbumControlState();
}

class _AlbumControlState extends State<AlbumControl> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.album.isFavoriteAlbum;
  }

  void _toggleFavorite() {
    context.read<FavoriteAlbumCubit>().toggleFavoriteAlbums(widget.album);
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AlbumControlCubit()..getSongsFromAlbum(widget.albumId),
      child: BlocBuilder<AlbumControlCubit, AlbumControlState>(
        builder: (context, state) {
          if (state is AlbumControlLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumControlLoadFailure) {
            return const Center(
              child: Text(
                "Không tải được thông tin nghệ sĩ",
                style: TextStyle(color: AppColors.lightGrey),
              ),
            );
          } else if (state is AlbumControlLoaded) {
            final album = state.albums[0];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        album.title,
                        style: const TextStyle(
                          fontFamily: "AM",
                          fontSize: 25,
                          color: AppColors.lightBg,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              '${AppURLs.artistFirestorage}${album.artist}.jpg?${AppURLs.mediaAlt}',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            // Thêm Expanded để tránh tràn
                            child: Text(
                              album.artist,
                              style: const TextStyle(
                                fontFamily: "AM",
                                fontSize: 18,
                                color: AppColors.lightBg,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                        height: 10,
                      ),
                      Text(
                        "Album - ${album.year}",
                        style: const TextStyle(
                          fontFamily: "AM",
                          fontSize: 16,
                          color: AppColors.lightBg,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        width: 80,
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: _toggleFavorite,
                              child: Image.asset(
                                'assets/images/icon_downloaded.png',
                                width: 35,
                                height: 35,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShareSongScreen(
                                albumId: widget.albumId,
                              ),
                            ),
                          );                              },
                              child: Image.asset(
                                'assets/images/icon_more.png',
                                width: 35,
                                height: 35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
