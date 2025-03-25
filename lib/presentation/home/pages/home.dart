import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify/common/helpers/if_dark.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/assets/app_images.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/home/widgets/bottom_player.dart';
import 'package:spotify/presentation/home/widgets/news_album.dart';
import 'package:spotify/presentation/home/widgets/news_artists.dart';
import 'package:spotify/presentation/home/widgets/news_podcasts.dart';
import 'package:spotify/presentation/home/widgets/news_songs.dart';
import 'package:spotify/presentation/home/widgets/play_list.dart';
import 'package:spotify/presentation/profile/pages/profile.dart';

class HomePage extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const HomePage({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

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
      appBar: BasicAppbar(
        hideBack: true,
        action: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ProfilePage(
                  songs: widget.songs,
                  currentIndex: widget.currentIndex,
                  artists: widget.artists,
                  podcasts: widget.podcasts,
                  albums: widget.albums,
                ),
              ),
            );
          },
          icon: const Icon(Icons.person),
        ),
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _homeTopCard(),
                const SizedBox(height: 10),
                _tabs(),
                SizedBox(
                  height: 260,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      NewsSongs(
                        onSongSelected: onSongSelected,
                      ),
                      NewsArtists(
                        songs: widget.songs,
                        currentIndex: widget.currentIndex,
                        artists: widget.artists,
                        podcasts: widget.podcasts,
                        albums: widget.albums,
                      ),
                      NewsAlbum(
                        songs: widget.songs,
                        currentIndex: widget.currentIndex,
                        artists: widget.artists,
                        podcasts: widget.podcasts,
                        albums: widget.albums,
                      ),
                      NewsPodcasts(
                        onPodcastSelected: onPodcastSelected,
                      ),
                    ],
                  ),
                ),
                const PlayList(),
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
                albums: widget.albums,
                currentIndex: widget.currentIndex,
                currentSong: currentSong,
                currentPodcast: currentPodcast,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _homeTopCard() {
    return Center(
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(AppVectors.homeTopCard),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: Image.asset(AppImages.homeArtist),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: context.isDarkmode ? Colors.white : Colors.black,
          indicatorColor: AppColors.primary,
          tabs: const [
            Text(
              'Bài Hát',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            Text(
              'Nghệ Sĩ',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            Text(
              'Albums',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            Text(
              'Podcasts',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
