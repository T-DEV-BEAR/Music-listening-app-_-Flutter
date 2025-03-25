import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/presentation/authen/bloc/favorite_artist_cubit.dart';
import 'package:spotify/presentation/authen/bloc/favorite_artist_state.dart';
import '../../../core/configs/theme/app_colors.dart';

class FavoriteArtistButton extends StatelessWidget {
  final ArtistEntity artistEntity;
  final Function? function;

  const FavoriteArtistButton({
    required this.artistEntity,
    this.function,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteArtistCubit, FavoriteArtistsState>(
      builder: (context, state) {
        if (state is FavoriteArtistsLoading) {
          return const CircularProgressIndicator();
        }

        if (state is FavoriteArtistsLoaded) {
          final isFavorite = context.read<FavoriteArtistCubit>().isFavorite(artistEntity);

          return IconButton(
            onPressed: () async {
              final cubit = context.read<FavoriteArtistCubit>();

              // Thêm hoặc xóa bài hát khỏi danh sách yêu thích và đồng bộ với Firebase
              await cubit.toggleFavoriteArtists(artistEntity);

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

        if (state is FavoriteArtistsFailure) {
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
