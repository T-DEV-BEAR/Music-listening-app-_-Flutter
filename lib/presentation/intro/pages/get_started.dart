import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/widgets/button/basic_app_button.dart';
import 'package:spotify/core/configs/assets/app_images.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/choose_mode/pages/choose_mode.dart';

class GetStartedPage extends StatelessWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const GetStartedPage({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      AppImages.introBG,
                    ))),
          ),
          Container(
            color: Colors.black.withOpacity(0.15),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(AppVectors.logo),
                ),
                const Spacer(),
                const Text(
                  "Chào Mừng Đến Với Thế Giới Âm Nhạc Của Riêng Bạn",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 21,
                ),
                const Text(
                  "Thưởng Thức Âm Nhạc Bạn Muốn Nghe",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyText,
                      fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 21,
                ),
                const Text(
                  "Cảm Ơn Bạn Đã Lựa Chọn Chúng Tôi.",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyText,
                      fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                BasicAppButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ChooseModePage(
                            songs: songs,
                            currentIndex: currentIndex,
                            artists: artists,
                            podcasts: podcasts,
                            albums: albums,
                          ),
                        ),
                      );
                    },
                    title: 'Bắt Đầu')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
