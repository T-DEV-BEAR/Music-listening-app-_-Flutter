import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/artist_player/bloc/artist_control_cubit.dart';
import 'package:spotify/presentation/artist_player/bloc/artist_control_state.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

class ArtistTrackList extends StatefulWidget {
  final String artistId;
  
  const ArtistTrackList({super.key, required this.artistId});

  @override
  _ArtistTrackListState createState() => _ArtistTrackListState();
}

class _ArtistTrackListState extends State<ArtistTrackList> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();

    // Lắng nghe trạng thái của SongPlayerCubit và cập nhật selectedIndex
    context.read<SongPlayerCubit>().stream.listen((state) {
      if (state is SongPlayerLoaded) {
        setState(() {
          selectedIndex = state.currentIndex; // Cập nhật chỉ số của bài hát đang phát
        });
      }
    });
  }

  void _onSongSelected(int index, List<SongEntity> songs) {
    setState(() {
      selectedIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongPlayerPage(
          songs: songs,
          currentIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArtistControlCubit()..getSongsFromArtist(widget.artistId),
      child: BlocBuilder<ArtistControlCubit, ArtistControlState>(
        builder: (context, state) {
          if (state is ArtistControlLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ArtistControlLoadFailure) {
            return const Center(
              child: Text(
                "Failed to load songs",
                style: TextStyle(color: AppColors.lightGrey),
              ),
            );
          } else if (state is ArtistControlLoaded) {
            final artist = state.artists[0];
            if (artist.songs.isEmpty) {
              return const Text(
                "No songs available",
                style: TextStyle(color: AppColors.lightGrey),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
              itemCount: artist.songs.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final song = artist.songs[index];
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () => _onSongSelected(index, artist.songs),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey[850] : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        GestureDetector(
                          onTap: () {
                            // Thêm chức năng nếu cần cho nút này
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

