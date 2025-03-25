import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/presentation/authen/bloc/favorite_podcast_cubit.dart';
import 'package:spotify/presentation/authen/bloc/favorite_podcast_state.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_state.dart';
import '../../../core/configs/theme/app_colors.dart';

class FavoritePodcastButton extends StatelessWidget {
  final PodcastEntity podcastEntity;
  final Function? function;

  const FavoritePodcastButton({
    required this.podcastEntity,
    this.function,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritePodcastCubit, FavoritePodcastsState>(
      builder: (context, state) {
        if (state is FavoritePodcastsLoading) {
          return const CircularProgressIndicator();
        }

        if (state is FavoritePodcastsLoaded) {
          final isFavorite = context.read<FavoritePodcastCubit>().isFavorite(podcastEntity);

          return IconButton(
            onPressed: () async {
              final cubit = context.read<FavoritePodcastCubit>();

              // Thêm hoặc xóa bài hát khỏi danh sách yêu thích và đồng bộ với Firebase
              await cubit.toggleFavoritePodcasts(podcastEntity);

              // Nếu có function được truyền vào, gọi nó
              if (function != null) {
                function!();
              }
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_outline_outlined,
              size: 25,
              color: isFavorite ? AppColors.primary : AppColors.darkGreyText,
            ),
          );
        }

        if (state is FavoriteSongsFailure) {
          // Trường hợp có lỗi xảy ra
          return const Icon(
            Icons.error,
            color: Colors.red,
          );
        }

        // Nếu chưa có trạng thái hoặc trạng thái không khớp, trả về container trống
        return Container();
      },
    );
  }
}
