import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/album_player/bloc/album_control_cubit.dart';
import 'package:spotify/presentation/album_player/bloc/album_control_state.dart';

class ShareSongScreen extends StatelessWidget {
  final String albumId;

  const ShareSongScreen({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              decoration: const BoxDecoration(
                gradient:  LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue,
                    AppColors.darkBg,
                  ],
                ),
              ),
              child: _SongInfo(albumId: albumId),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: AppColors.darkBg,
              child: Image.asset("assets/images/social_links.png"),
            ),
          ),
        ],
      ),
    );
  }
}

class _SongInfo extends StatelessWidget {
  final String albumId;

  const _SongInfo({required this.albumId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumControlCubit()..getSongsFromAlbum(albumId),
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          "assets/images/icon_back.png",
                          height: 15,
                          width: 15,
                        ),
                      ),
                      const Text(
                        "Chia sẻ",
                        style: TextStyle(
                          fontFamily: "AM",
                          fontSize: 18,
                          color: AppColors.lightBg,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 15), // Placeholder to balance layout
                    ],
                  ),
                  const SizedBox(height: 60),
                  Image.network(
                    '${AppURLs.artistFirestorage}${album.artist}.jpg?${AppURLs.mediaAlt}',
                    height: 220,
                    width: 220,
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: SizedBox(
                      width: 235,
                      child: Text(
                        album.title,
                        style: const TextStyle(
                          fontFamily: "AM",
                          color: AppColors.lightBg,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      album.artist,
                      style: const TextStyle(
                        fontFamily: "AM",
                        fontSize: 16,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
