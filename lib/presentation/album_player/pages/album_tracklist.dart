import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/album_player/bloc/album_control_cubit.dart';
import 'package:spotify/presentation/album_player/bloc/album_control_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

class AlbumTrackList extends StatefulWidget {
  final String albumId;
  final int currentIndex;

  const AlbumTrackList({
    super.key,
    required this.albumId,
    required this.currentIndex,
  });

  @override
  _AlbumTrackListState createState() => _AlbumTrackListState();
}

class _AlbumTrackListState extends State<AlbumTrackList> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.currentIndex;
  }

  void _onSongSelected(int index, List<SongEntity> songs) {
    setState(() {
      selectedIndex = index; // Update selectedIndex
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SongPlayerPage(
          songs: songs, // Pass the list of songs here
          currentIndex: index,
        ),
      ),
    ).then((_) {
      // Update UI when returning from SongPlayerPage
      setState(() {
        selectedIndex = index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumControlCubit()..getSongsFromAlbum(widget.albumId),
      child: BlocBuilder<AlbumControlCubit, AlbumControlState>(
        builder: (context, state) {
          if (state is AlbumControlLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumControlLoadFailure) {
            return const Center(
              child: Text(
                "Failed to load songs",
                style: TextStyle(color: AppColors.lightGrey),
              ),
            );
          } else if (state is AlbumControlLoaded) {
            final album = state.albums[0];
            if (album.songs.isEmpty) {
              return const Text(
                "No songs available",
                style: TextStyle(color: AppColors.lightGrey),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
              itemCount: album.songs.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final song = album.songs[index];
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () => _onSongSelected(index, album.songs), // Pass songs list here
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey[850] : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 110,
                                  child: Text(
                                    song.title,
                                    style: TextStyle(
                                      fontFamily: "AM",
                                      fontSize: 16,
                                      color: isSelected ? Colors.green : AppColors.lightBg,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/icon_downloaded.png',
                                      height: 13,
                                      width: 13,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      song.artist,
                                      style: TextStyle(
                                        fontFamily: "AM",
                                        fontSize: 13,
                                        color: isSelected ? Colors.greenAccent : AppColors.lightGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            // Add functionality for the options button if needed
                          },
                          child: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
