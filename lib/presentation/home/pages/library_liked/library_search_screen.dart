import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

class LikedSearchScreen extends StatefulWidget {
  const LikedSearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LikedSearchScreenState createState() => _LikedSearchScreenState();
}

class _LikedSearchScreenState extends State<LikedSearchScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomScrollView(
            slivers: [
              const _SearchBox(),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: Text(
                    "Recent searches",
                    style: TextStyle(
                      fontFamily: "AM",
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightBg,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              // Fetch and display songs in a single BlocBuilder
              SliverToBoxAdapter(
                child: BlocProvider(
                  create: (_) => FavoriteSongsCubit()..getFavoriteSongs(),
                  child: BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
                    builder: (context, state) {
                      if (state is FavoriteSongsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is FavoriteSongsLoaded) {
                        // Filter songs based on search query
                        final filteredSongs = _searchByNameSongsAndArtists(state.favoriteSongs, _searchQuery);
                        return _songs(filteredSongs);
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Search songs based on the query
  List<SongEntity> _searchByNameSongsAndArtists(List<SongEntity> songs, String query) {
    if (query.isEmpty) return songs; // Return all songs if the query is empty
    String normalizedQuery = query.toLowerCase();

    // Filter the songs based on the search query
    return songs.where((song) {
      return song.title.toLowerCase().contains(normalizedQuery) ||
          song.artist.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SongPlayerPage(
                  //songEntity: songs[index],
                  currentIndex: index,
                  songs: songs,
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      '${AppURLs.coverFirestorage}${songs[index].artist} - ${songs[index].title}.jpg?${AppURLs.mediaAlt}',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      songs[index].title.length > 30 
                          ? '${songs[index].title.substring(0, 30)}...' 
                          : songs[index].title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      songs[index].artist,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: songs.length,
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 35,
              width: MediaQuery.of(context).size.width - 102.5,
              decoration: const BoxDecoration(
                color: Color(0xff282828),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/icon_search_transparent.png",
                      color: AppColors.lightBg,
                    ),
                    Expanded(
                      child: TextField(
                        enableIMEPersonalizedLearning: true,
                        style: const TextStyle(
                          fontFamily: "AM",
                          fontSize: 16,
                          color: AppColors.lightBg,
                        ),
                        onChanged: (value) {
                          // Update search query in the state
                          final searchScreenState = context.findAncestorStateOfType<_LikedSearchScreenState>();
                          if (searchScreenState != null) {
                            // ignore: invalid_use_of_protected_member
                            searchScreenState.setState(() {
                              searchScreenState._searchQuery = value;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10, left: 15),
                          hintText: "Tìm Kiếm",
                          hintStyle: TextStyle(
                            fontFamily: "AM",
                            color: AppColors.lightBg,
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.none,
                              width: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Hủy",
                style: TextStyle(
                  fontFamily: "AM",
                  color: AppColors.lightBg,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
