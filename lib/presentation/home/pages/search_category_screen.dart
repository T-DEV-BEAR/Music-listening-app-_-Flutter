import 'package:flutter/material.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/home/widgets/bottom_player.dart';
import 'package:spotify/presentation/home/pages/search_screen.dart';

class SearchCategoryScreen extends StatefulWidget {
  final List<SongEntity> songs; // Danh sách bài hát
  final int currentIndex; // Chỉ số hiện tại
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const SearchCategoryScreen({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  State<SearchCategoryScreen> createState() => _SearchCategoryScreenState();
}

class _SearchCategoryScreenState extends State<SearchCategoryScreen> {
  String? scanResault;
  SongEntity? currentSong;
  PodcastEntity? currentPodcast;

  void onSongSelected(SongEntity song) {
    setState(() {
      currentSong = song;
      currentPodcast = null;
    });
  }

  void onPodcastSelected(PodcastEntity podcast) {
    setState(() {
      currentPodcast = podcast;
      currentSong = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tìm Kiếm",
                            style: TextStyle(
                              fontFamily: "AB",
                              fontSize: 25,
                              color: AppColors.lightBg,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset("assets/images/icon_camera.png"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const _SearchBox(),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 45,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: BottomPlayer(
                  songs: widget.songs,
                  artists: widget.artists,
                  podcasts: widget.podcasts,
                  currentIndex: widget.currentIndex,
                  currentSong: currentSong,
                  currentPodcast: currentPodcast,
                  albums: widget.albums,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 46,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.lightBg,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
            child: Row(
              children: [
                Image.asset("assets/images/icon_search_black.png"),
                const SizedBox(width: 15),
                const Text(
                  "Bạn Muốn Nghe GÌ?",
                  style: TextStyle(
                    fontFamily: "AB",
                    color: AppColors.darkGreyText,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
