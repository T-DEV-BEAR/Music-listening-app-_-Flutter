import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/album_player/bloc/album_control_cubit.dart';
import 'package:spotify/presentation/album_player/bloc/album_control_state.dart';
import 'package:spotify/presentation/album_player/pages/album_control.dart';
import 'package:spotify/presentation/album_player/pages/album_tracklist.dart';
import 'package:spotify/presentation/home/widgets/bottom_player.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

class AlbumviewScreen extends StatefulWidget {
  final AlbumEntity album;
  final List<SongEntity> songs;
  final int currentIndex;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;
  final List<ArtistEntity> artists;

  const AlbumviewScreen({
    super.key,
    required this.album,
    required this.songs,
    required this.currentIndex,
    required this.podcasts,
    required this.albums,
    required this.artists,
  });

  @override
  State<AlbumviewScreen> createState() => _AlbumviewScreenState();
}

class _AlbumviewScreenState extends State<AlbumviewScreen> {
  ScrollController? _scrollController;
  bool showTopBar = false;
  double topBarOpacity = 0.0;
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
      create: (_) =>
          AlbumControlCubit()..getSongsFromAlbum(widget.album.albumId ?? ''),
      child: Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Album cover and gradient background
                  Container(
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: SizedBox(
                                  height: 250,
                                  width: 300,
                                  child: Image.network(
                                    '${AppURLs.albumFirestorage}${widget.album.title}.jpg?${AppURLs.mediaAlt}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    AlbumControl(
                                        albumId: widget.album.albumId ?? '',
                                        album: widget.album,),
                                  ],
                                ),
                              ),
                              // Thêm Align để căn chỉnh nút Play thấp hơn
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 120),
                                  child: BlocBuilder<AlbumControlCubit,
                                      AlbumControlState>(
                                    builder: (context, state) {
                                      if (state is AlbumControlLoaded) {
                                        List<SongEntity> albumSongs =
                                            state.albums[0].songs;

                                        return GestureDetector(
                                          onTap: () {
                                            context
                                                .read<SongPlayerCubit>()
                                                .setSongQueue(
                                              albumSongs,
                                              0, // Bắt đầu từ bài hát đầu tiên
                                              () {
                                                // Gọi lại khi bài hát hoàn thành
                                                print("Song completed");
                                              },
                                            );
                                            if (albumSongs.isNotEmpty) {
                                              onSongSelected(albumSongs[0]);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SongPlayerPage(
                                                    songs: albumSongs,
                                                    currentIndex:
                                                        0, // Phát từ bài hát đầu tiên
                                                  ),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Artist has no songs")),
                                              );
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
                                        );
                                      } else if (state
                                          is AlbumControlLoading) {
                                        return const CircularProgressIndicator();
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  BlocBuilder<AlbumControlCubit, AlbumControlState>(
                    builder: (context, state) {
                      if (state is AlbumControlLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AlbumControlLoadFailure) {
                        return const Center(
                          child: Text("Failed to load songs",
                              style: TextStyle(color: Colors.white70)),
                        );
                      } else if (state is AlbumControlLoaded) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: AlbumTrackList(
                              albumId: widget.album.albumId ?? '',
                              currentIndex: widget.currentIndex,),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(
                    height: 230,
                  ),
                ],
              ),
            ),
            // Top bar with opacity that appears on scroll
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: topBarOpacity,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  height: 80,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded (
                        child: Text(
                          widget.album.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom player
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
}
