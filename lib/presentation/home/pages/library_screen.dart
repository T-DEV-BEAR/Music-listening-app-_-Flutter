import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/helpers/if_dark.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/authen/pages/choose_artist_screen.dart';
import 'package:spotify/presentation/authen/pages/choose_podcast_screen.dart';
import 'package:spotify/presentation/home/pages/library_album/library_albums.dart';
import 'package:spotify/presentation/home/pages/library_avatar/library_avatar.dart';
import 'package:spotify/presentation/home/pages/library_podcast/library_podcast.dart';
import 'package:spotify/presentation/home/pages/new_episoded/new_episodes.dart';
import 'package:spotify/presentation/home/widgets/bottom_player.dart';
import 'package:spotify/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:spotify/presentation/profile/bloc/profile_info_state.dart';
import 'package:spotify/presentation/profile/pages/profile.dart';
import 'package:spotify/presentation/home/pages/library_liked/library_liked.dart';

class LibraryScreen extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const LibraryScreen({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? selectedTabIndex;
  SongEntity? currentSong;
  PodcastEntity? currentPodcast;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                  songs: widget.songs,
                                  currentIndex: widget.currentIndex,
                                  artists: widget.artists,
                                  podcasts: widget.podcasts,
                                  albums: widget.albums,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(width: 10),
                              _profileInfo(context),
                              const SizedBox(width: 10),
                              const Text(
                                "Thư Viện",
                                style: TextStyle(
                                  fontFamily: "AB",
                                  fontSize: 24,
                                  color: AppColors.lightBg,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset("assets/images/icon_add.png"),
                        ),
                      ],
                    ),
                  ),
                ),
                // TabBar Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TabBar(
                              controller: _tabController,
                              isScrollable: true,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              indicator: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: context.isDarkmode
                                  ? Colors.white70
                                  : Colors.black54,
                              tabs: [
                                _buildTabItem('Home'),
                                _buildTabItem('Playlists'),
                                _buildTabItem('Nghệ sĩ'),
                                _buildTabItem('Albums'),
                                _buildTabItem('Podcasts'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/arrow_component_down.png",
                                  width: 10,
                                  height: 12,
                                ),
                                Image.asset(
                                  "assets/images/arrow_component_up.png",
                                  width: 10,
                                  height: 12,
                                ),
                              ],
                            ),
                            const SizedBox(width: 3),
                            const Text(
                              "Gần đây",
                              style: TextStyle(
                                fontFamily: "AM",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.lightBg,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset("assets/images/icon_category.png"),
                        ),
                      ],
                    ),
                  ),
                ),
                // TabBarView with content for each tab
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        200, // Điều chỉnh chiều cao linh hoạt
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                LikedSongsSection(
                                  songs: widget.songs,
                                  currentIndex: widget.currentIndex,
                                  artists: widget.artists,
                                  podcasts: widget.podcasts,
                                  albums: widget.albums,
                                ),
                                NewEpisodesSection(
                                  songs: widget.songs,
                                  currentIndex: widget.currentIndex,
                                  artists: widget.artists,
                                  podcasts: widget.podcasts,
                                  albums: widget.albums,
                                ),
                                LibraryAvatar(
                                  songs: widget.songs,
                                  currentIndex: widget.currentIndex,
                                  artists: widget.artists,
                                  podcasts: widget.podcasts,
                                  albums: widget.albums,
                                ),
                                LibraryAlbum(
                                  songs: widget.songs,
                                  currentIndex: widget.currentIndex,
                                  artists: widget.artists,
                                  podcasts: widget.podcasts,
                                  albums: widget.albums,
                                ),
                                LibraryPodcast(
                                  songs: widget.songs,
                                  currentIndex: widget.currentIndex,
                                  artists: widget.artists,
                                  podcasts: widget.podcasts,
                                  albums: widget.albums,
                                ),
                                AddOptionsSection(
                                  songs: widget.songs,
                                  currentIndex: widget.currentIndex,
                                  artists: widget.artists,
                                  podcasts: widget.podcasts,
                                  albums: widget.albums,
                                ),
                                const SizedBox(height: 40,)
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                LikedSongsSection(
                                  songs: widget.songs,
                                  currentIndex: widget.currentIndex,
                                  artists: widget.artists,
                                  podcasts: widget.podcasts,
                                  albums: widget.albums,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                LibraryAvatar(
                                  songs: widget.songs,
                                  currentIndex: widget.currentIndex,
                                  artists: widget.artists,
                                  podcasts: widget.podcasts,
                                  albums: widget.albums,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                LibraryAlbum(
                                  songs: widget.songs,
                                  currentIndex: widget.currentIndex,
                                  artists: widget.artists,
                                  podcasts: widget.podcasts,
                                  albums: widget.albums,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                LibraryPodcast(
                                  songs: widget.songs,
                                  currentIndex: widget.currentIndex,
                                  artists: widget.artists,
                                  podcasts: widget.podcasts,
                                  albums: widget.albums,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
    );
  }

  Widget _buildTabItem(String title) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
        builder: (context, state) {
          if (state is ProfileInfoLoading) {
            return const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              child: CircularProgressIndicator(
                color: AppColors.lightBg,
              ),
            );
          }
          if (state is ProfileInfoLoaded) {
            return CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(state.userEntity.imageURL!),
            );
          }
          if (state is ProfileInfoFailure) {
            return const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red,
              child: Icon(Icons.error, color: Colors.white),
            );
          }
          return const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          );
        },
      ),
    );
  }
}

class LibraryOptionsChip extends StatelessWidget {
  final int index;
  final TabController tabController;

  const LibraryOptionsChip({
    super.key,
    required this.index,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    List<String> chipTitle = ["Playlists", "Nghệ sĩ", "Albums", "Podcasts"];
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        height: 33,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.lightGrey,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: TabBar(
          controller: tabController,
          isScrollable: true,
          labelColor: context.isDarkmode ? Colors.white : Colors.black,
          indicatorColor: AppColors.primary,
          tabs: List.generate(
            chipTitle.length,
            (index) => Tab(
              child: Text(
                chipTitle[index],
                style: const TextStyle(
                  fontFamily: "AM",
                  fontSize: 12,
                  color: AppColors.lightBg,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OptionsList extends StatelessWidget {
  final TabController tabController;

  const OptionsList({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 33,
      child: LibraryOptionsChip(
        index: 0,
        tabController: tabController,
      ),
    );
  }
}


class AddOptionsSection extends StatelessWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const AddOptionsSection({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          _buildAddOption(
            context,
            "Thêm nghệ sĩ",
            Icons.person_add, 
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChooseArtistScreen(
                    songs: songs,
                    currentIndex: currentIndex,
                    artists: artists,
                    podcasts: podcasts,
                    albums: albums,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildAddOption(
            context,
            "Thêm podcast",
            Icons.podcasts,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChoosePodcastScreen(
                    songs: songs,
                    currentIndex: currentIndex,
                    artists: artists,
                    podcasts: podcasts,
                    albums: albums,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddOption(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon, // Sử dụng icon từ tham số
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "AM",
                  fontSize: 15,
                  color: AppColors.lightBg,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Thêm vào thư viện của bạn",
                style: TextStyle(
                  fontFamily: "AM",
                  color: AppColors.lightGrey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



