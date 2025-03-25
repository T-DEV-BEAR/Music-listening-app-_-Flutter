import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/home/bloc/news_episoded_cubit.dart';
import 'package:spotify/presentation/home/bloc/news_episoded_state.dart';

class NewEpisodedControl extends StatelessWidget {
  const NewEpisodedControl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsEpisodedCubit, NewsEpisodedState>(
      builder: (context, state) {
        if (state is NewsEpisodedLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NewsEpisodedFailure) {
          return const Center(
            child: Text(
              "Không tải được thông tin nghệ sĩ",
              style: TextStyle(color: AppColors.lightGrey),
            ),
          );
        } else if (state is NewsEpisodedLoaded) {
          final totalSongs = state.songs.length;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bài hát mới cập nhật",
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
