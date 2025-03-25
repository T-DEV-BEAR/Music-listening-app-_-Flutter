import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_state.dart';
import '../../../core/configs/theme/app_colors.dart';

class FavoriteButton extends StatelessWidget {
  final SongEntity songEntity;
  final Function? function;

  const FavoriteButton({
    required this.songEntity,
    this.function,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
      builder: (context, state) {
        if (state is FavoriteSongsLoading) {
          return const CircularProgressIndicator();
        }

        if (state is FavoriteSongsLoaded) {
          final isFavorite = context.read<FavoriteSongsCubit>().isFavorite(songEntity);

          return IconButton(
            onPressed: () async {
              final cubit = context.read<FavoriteSongsCubit>();

              await cubit.toggleFavoriteSong(songEntity);

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
          return const Icon(
            Icons.error,
            color: Colors.red,
          );
        }

        return Container();
      },
    );
  }
}
