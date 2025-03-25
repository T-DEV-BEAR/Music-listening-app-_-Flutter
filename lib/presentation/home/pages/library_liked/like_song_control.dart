import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_state.dart';

class LikeSongControl extends StatelessWidget {
  const LikeSongControl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
      builder: (context, state) {
        if (state is FavoriteSongsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoriteSongsFailure) {
          return const Center(
            child: Text(
              "Không tải được thông tin nghệ sĩ",
              style: TextStyle(color: AppColors.lightGrey),
            ),
          );
        } else if (state is FavoriteSongsLoaded) {
          final totalSongs = state.favoriteSongs.length;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bài hát ưa thích",
                    style: TextStyle(
                      fontFamily: "AM",
                      fontSize: 25,
                      color: AppColors.lightBg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        "$totalSongs bài hát",
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
                  SizedBox(
                    width: 80,
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/icon_downloaded.png',
                          width: 35,
                          height: 35,
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {},
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
    );
  }
}
