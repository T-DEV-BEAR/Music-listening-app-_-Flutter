import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/artist_player/bloc/artist_control_cubit.dart';
import 'package:spotify/presentation/artist_player/bloc/artist_control_state.dart';

class ArtistsControl extends StatelessWidget {
  final String artistId;

  const ArtistsControl({super.key, required this.artistId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArtistControlCubit()..getSongsFromArtist(artistId),
      child: BlocBuilder<ArtistControlCubit, ArtistControlState>(
        builder: (context, state) {
          if (state is ArtistControlLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ArtistControlLoadFailure) {
            return const Center(
              child: Text(
                "Không tải được thông tin nghệ sĩ",
                style: TextStyle(color: AppColors.lightGrey),
              ),
            );
          } else if (state is ArtistControlLoaded) {
            final artist = state.artists[0];
            final totalSongs = artist.songs.length;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artist.name,
                      style: const TextStyle(
                        fontFamily: "AM",
                        fontSize: 25,
                        color: AppColors.lightBg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(
                            '${AppURLs.artistFirestorage}${artist.name}.jpg?${AppURLs.mediaAlt}',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${artist.name} - $totalSongs bài hát",
                          style: const TextStyle(
                            fontFamily: "AM",
                            fontSize: 14,
                            color: AppColors.lightBg,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Phổ biến",
                      style: TextStyle(
                        fontFamily: "AM",
                        fontSize: 13,
                        color: Color.fromARGB(255, 165, 165, 165),
                      ),
                    ),
                    SizedBox(
                      width:
                          80, // Điều chỉnh độ rộng để đủ không gian cho hai icon
                      height: 45,
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.start, // Căn từ trái sang phải
                        children: [
                          Image.asset(
                            'assets/images/icon_downloaded.png',
                            width: 35,
                            height: 35,
                          ),
                          const SizedBox(
                              width: 10), // Khoảng cách giữa hai icon
                          GestureDetector(
                            onTap: () {
                              
                            },
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
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
