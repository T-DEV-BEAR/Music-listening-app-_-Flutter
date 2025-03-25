import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/presentation/authen/bloc/favorite_podcast_cubit.dart';

class PodcastAvatarWidget extends StatefulWidget {
  final PodcastEntity podcast;
  const PodcastAvatarWidget({super.key, required this.podcast});

  @override
  _PodcastAvatarWidgetState createState() => _PodcastAvatarWidgetState();
}

class _PodcastAvatarWidgetState extends State<PodcastAvatarWidget> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.podcast.isFavoritePodcast;
  }

  void _toggleFavorite() {
    context.read<FavoritePodcastCubit>().toggleFavoritePodcasts(widget.podcast);
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(
                      '${AppURLs.podcaseCoverFirestorage}${widget.podcast.podcast} - ${widget.podcast.title}.jpg?${AppURLs.mediaAlt}',
                ),
              ),
              if (isFavorite)
                Positioned(
                  left: -10,
                  top: -10,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.done,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.podcast.podcast,
            style: const TextStyle(
              fontFamily: "AB",
              fontSize: 12,
              color: AppColors.lightBg,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}