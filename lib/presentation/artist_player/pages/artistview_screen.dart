import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/artist_player/bloc/artist_control_cubit.dart';
import 'package:spotify/presentation/artist_player/bloc/artist_control_state.dart';
import 'package:spotify/presentation/artist_player/pages/artist_control.dart';
import 'package:spotify/presentation/artist_player/pages/artist_tracklist.dart';
import 'package:spotify/presentation/home/widgets/bottom_player.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

class ArtistviewScreen extends StatefulWidget {
  final ArtistEntity artist;
  final List<SongEntity> songs;
  final int currentIndex;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;
  final List<ArtistEntity> artists;

  const ArtistviewScreen({
    super.key,
    required this.artist,
    required this.songs,
    required this.currentIndex,
    required this.podcasts,
    required this.albums,
    required this.artists,
  });

  @override
  State<ArtistviewScreen> createState() => _ArtistviewScreenState();
}

class _ArtistviewScreenState extends State<ArtistviewScreen> {
  ScrollController? _scrollController;
  bool showTopBar = false;
  double topBarOpacity = 0.0;
  SongEntity? currentSong;
  PodcastEntity? currentPodcast;
  int? selectedIndex; // Khai báo biến selectedIndex

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
      create: (_) => ArtistControlCubit()
        ..getSongsFromArtist(widget.artist.artistId ?? ''),
      child: Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 7, 227, 7),
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
                                    '${AppURLs.artistFirestorage}${widget.artist.name}.jpg?${AppURLs.mediaAlt}',
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
                                    ArtistsControl(
                                        artistId: widget.artist.artistId ?? ''),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 120),
                                  child: BlocBuilder<ArtistControlCubit, ArtistControlState>(
                                    builder: (context, state) {
                                      if (state is ArtistControlLoaded) {
                                        List<SongEntity> artistSongs = state.artists[0].songs;

                                        return GestureDetector(
                                          onTap: () {
                                            if (artistSongs.isNotEmpty) {
                                              setState(() {
                                                selectedIndex = 0;
                                              });
                                              context.read<SongPlayerCubit>().setSongQueue(
                                                artistSongs,
                                                0,
                                                () {
                                                  print("Song completed");
                                                },
                                              );
                                              onSongSelected(artistSongs[0]);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => SongPlayerPage(
                                                    songs: artistSongs,
                                                    currentIndex: 0,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Artist has no songs")),
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
                                      } else if (state is ArtistControlLoading) {
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
                  BlocBuilder<ArtistControlCubit, ArtistControlState>(
                    builder: (context, state) {
                      if (state is ArtistControlLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ArtistControlLoadFailure) {
                        return const Center(
                          child: Text("Failed to load songs",
                              style: TextStyle(color: Colors.white70)),
                        );
                      } else if (state is ArtistControlLoaded) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ArtistTrackList(
                              artistId: widget.artist.artistId ?? '',
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 230),
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
                child: Container(
                  height: 80,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 7, 227, 7),
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
                      Text(
                        widget.artist.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
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
}