import 'package:flutter/material.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/home/pages/home.dart';
import 'package:spotify/presentation/home/pages/library_screen.dart';
import 'package:spotify/presentation/home/pages/search_category_screen.dart';

class DashBoardScreen extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const DashBoardScreen({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int dashBoardIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: dashBoardIndex,
              children: [
                HomePage(
                  songs: widget.songs,
                  currentIndex: widget.currentIndex,
                  artists: widget.artists,
                  podcasts: widget.podcasts,
                  albums: widget.albums,
                ),
                SearchCategoryScreen(
                  songs: widget.songs,
                  currentIndex: widget.currentIndex,
                  artists: widget.artists,
                  podcasts: widget.podcasts,
                  albums: widget.albums,
                ),
                LibraryScreen(
                  songs: widget.songs,
                  currentIndex: widget.currentIndex,
                  artists: widget.artists,
                  podcasts: widget.podcasts,
                  albums: widget.albums,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 64,
        width: MediaQuery.of(context).size.width,
        color: AppColors.darkBg.withOpacity(0.95),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedLabelStyle: const TextStyle(fontFamily: "AM", fontSize: 13),
            selectedItemColor: const Color(0xffE5E5E5),
            unselectedItemColor: AppColors.lightGrey,
            type: BottomNavigationBarType.fixed,
            currentIndex: dashBoardIndex,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: (value) {
              setState(() {
                dashBoardIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/icon_home.png'),
                activeIcon: Image.asset('assets/images/icon_home_active.png'),
                label: "Trang Chủ",
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/icon_search_bottomnav.png'),
                activeIcon: Image.asset('assets/images/icon_search_active.png'),
                label: "Tìm Kiếm",
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/icon_library.png'),
                activeIcon:
                    Image.asset('assets/images/icon_library_active.png'),
                label: "Thư Viện",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
