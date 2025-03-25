import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/presentation/authen/bloc/favorite_artist_cubit.dart';

class ArtistAvatar extends StatefulWidget {
  final ArtistEntity artist;

  const ArtistAvatar({
    super.key,
    required this.artist,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ArtistAvatarState createState() => _ArtistAvatarState();
}

class _ArtistAvatarState extends State<ArtistAvatar> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.artist.isFavoriteArtist;
  }

  void _toggleFavorite() {
    context.read<FavoriteArtistCubit>().toggleFavoriteArtists(widget.artist);
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
                  '${AppURLs.artistFirestorage}${widget.artist.name}.jpg?${AppURLs.mediaAlt}',
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
            widget.artist.name,
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

