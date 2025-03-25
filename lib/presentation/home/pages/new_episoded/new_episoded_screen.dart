import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_song_button.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/home/bloc/news_episoded_cubit.dart';
import 'package:spotify/presentation/home/bloc/news_episoded_state.dart';
import 'package:spotify/presentation/home/pages/new_episoded/new_episoded_control.dart';
import 'package:spotify/presentation/home/pages/new_episoded/new_episoded_search_screen.dart';
import 'package:spotify/presentation/home/widgets/bottom_player.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

class NewEpisodedScreen extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<PodcastEntity> podcasts;
  final List<ArtistEntity> artists;
  final List<AlbumEntity> albums;

  const NewEpisodedScreen({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.podcasts,
    required this.artists,
    required this.albums,
  });

  @override
  State<NewEpisodedScreen> createState() => _NewEpisodedScreenState();
}

class _NewEpisodedScreenState extends State<NewEpisodedScreen> {
  ScrollController? _scrollController;
  bool showTopBar = false;
  double topBarOpacity = 0.0;
  List<Color> colorPallete = [
    AppColors.darkBg,
    const Color.fromARGB(255, 25, 118, 194)
  ];
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
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.offset > 150) {
          setState(() {
            showTopBar = true;
            topBarOpacity = 1.0;
          });
        } else {
          setState(() {
            showTopBar = false;
            topBarOpacity = 0.0;
          });
        }
      });

  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsEpisodedCubit()..getNewsEpisodedSongs(),
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 300,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF5B86E5),
                              Color(0xFF000000),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  flex:
                                      3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NewEpisodedSearchScreen(),
                                          ),
                                        );
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(Icons.search,
                                              color: Colors.white70),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              "Tìm trong mục Bài hát đã tải...",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Flexible(
                                  flex: 1,
                                  child: SortMenuButton(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 25),
                                child: NewEpisodedControl(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: GestureDetector(
                          onTap: () {
                            final songepisodedState = context.read<NewsEpisodedCubit>().state;
                            final SongEntity? currentPlayingSong = currentSong;

                            if (songepisodedState is NewsEpisodedLoaded) {
                              List<SongEntity> episodedSong = songepisodedState.songs;

                              if (episodedSong.isNotEmpty) {
                                if (currentPlayingSong != null && episodedSong.contains(currentPlayingSong)) {
                                  int currentIndex = episodedSong.indexOf(currentPlayingSong);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SongPlayerPage(
                                        songs: episodedSong,
                                        currentIndex: currentIndex,
                                      ),
                                    ),
                                  );
                                } else {
                                  onSongSelected(episodedSong[0]);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SongPlayerPage(
                                        songs: episodedSong,
                                        currentIndex: 0,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Danh sách yêu thích trống")),
                                );
                              }
                            }
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<NewsEpisodedCubit, NewsEpisodedState>(
                    builder: (context, state) {
                      if (state is NewsEpisodedLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is NewsEpisodedFailure) {
                        return const Center(
                          child: Text(
                            "Failed to load songs",
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      } else if (state is NewsEpisodedLoaded) {
                        List<SongEntity> episodedSong = state.songs;
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 20, bottom: 65),
                          itemBuilder: (context, index) {
                            return _songTile(
                              song: episodedSong[index],
                              songepisoded: episodedSong,
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 20),
                          itemCount: episodedSong.length,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  )
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: topBarOpacity,
                duration: const Duration(milliseconds: 300),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 80,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF5B86E5), // Màu xanh nhạt ở trên
                            Color(0xFF000000), // Màu đen ở dưới
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Text(
                            "Bài Hát Mới Cập Nhật",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 50),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: -30,
                      child: GestureDetector(
                        onTap: () {
                          final songepisodedState =
                              context.read<NewsEpisodedCubit>().state;
                          final SongEntity? currentPlayingSong = currentSong;

                          if (songepisodedState is NewsEpisodedLoaded) {
                            List<SongEntity> songepisoded =
                                songepisodedState.songs;

                            if (songepisoded.isNotEmpty) {
                              if (currentPlayingSong != null &&
                                  songepisoded.contains(currentPlayingSong)) {
                                int currentIndex =
                                    songepisoded.indexOf(currentPlayingSong);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SongPlayerPage(
                                      songs: songepisoded,
                                      currentIndex: currentIndex,
                                    ),
                                  ),
                                );
                              } else {
                                onSongSelected(songepisoded[0]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SongPlayerPage(
                                      songs: songepisoded,
                                      currentIndex: 0,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              // Không có bài nào trong danh sách yêu thích
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Danh sách yêu thích trống")),
                              );
                            }
                          }
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomPlayer(
                songs: widget.songs,
                currentIndex: widget.currentIndex,
                podcasts: widget.podcasts,
                currentSong: currentSong,
                artists: widget.artists,
                currentPodcast: currentPodcast,
                albums: widget.albums,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _songTile(
      {required SongEntity song, required List<SongEntity> songepisoded}) {
    bool isCurrentSong = song == currentSong;

    return GestureDetector(
      onTap: () {
        if (songepisoded.isNotEmpty && songepisoded.contains(song)) {
          onSongSelected(song);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SongPlayerPage(
                songs: songepisoded,
                currentIndex: songepisoded.indexOf(song),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Song not found in favorites.")),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentSong ? Colors.grey[850] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(
                        '${AppURLs.coverFirestorage}${song.artist} - ${song.title}.jpg?${AppURLs.mediaAlt}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMarqueeText(
                      text: song.title,
                      maxLength: 20,
                      width: 195,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isCurrentSong ? Colors.green : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildMarqueeText(
                      text: song.artist,
                      maxLength: 20,
                      width: 150,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        color:
                            isCurrentSong ? Colors.greenAccent : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  song.duration.toString().replaceAll('.', ':'),
                  style: TextStyle(
                    fontSize: 14,
                    color: isCurrentSong ? Colors.green : Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                FavoriteButton(
                  songEntity: song,
                  key: UniqueKey(),
                  function: () {
                    context.read<FavoriteSongsCubit>().removeSong(song);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarqueeText({
    required String text,
    required int maxLength,
    required double width,
    required TextStyle style,
  }) {
    return SizedBox(
      height: 20,
      width: width,
      child: text.length > maxLength
          ? Marquee(
              text: text,
              style: style,
              scrollAxis: Axis.horizontal,
              blankSpace: 20.0,
              velocity: 30.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10.0,
              accelerationDuration: const Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: const Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            )
          : Text(
              text,
              style: style,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
    );
  }
}

class SortMenuButton extends StatelessWidget {
  const SortMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showSortMenu(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          "Sắp xếp",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showSortMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.grey[900],
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.sort, color: Colors.green),
            title: const Text("Thời Lượng",
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              context.read<NewsEpisodedCubit>().sortSongs(SortNewsEpisodedOption.recent);
            },
          ),
          ListTile(
            leading: const Icon(Icons.new_releases, color: Colors.green),
            title: const Text("Mới thêm gần đây",
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              context.read<NewsEpisodedCubit>().sortSongs(SortNewsEpisodedOption.recentlyAdded);
            },
          ),
          ListTile(
            leading: const Icon(Icons.sort_by_alpha, color: Colors.green),
            title: const Text("Thứ tự chữ cái",
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              context.read<NewsEpisodedCubit>().sortSongs(SortNewsEpisodedOption.alphabetical);
            },
          ),
        ],
      );
    },
  );
}
}
