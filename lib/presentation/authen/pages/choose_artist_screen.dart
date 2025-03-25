import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/authen/widgets/artist_avatar_widget.dart';
import 'package:spotify/presentation/bloc/get_artists_cubit.dart';
import 'package:spotify/presentation/bloc/get_artists_state.dart';
import 'package:spotify/presentation/authen/pages/choose_podcast_screen.dart'; // Import ChoosePodcastScreen

class ChooseArtistScreen extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const ChooseArtistScreen({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  _ChooseArtistScreenState createState() => _ChooseArtistScreenState();
}

class _ChooseArtistScreenState extends State<ChooseArtistScreen> {
  List<ArtistEntity> _artists = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _artists = widget.artists;
  }

  List<ArtistEntity> _filterArtists(String query) {
    if (query.isEmpty) return _artists;
    return _artists.where((artist) {
      return artist.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetArtistCubit()..getArtists(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
              appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.lightBg,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Chọn Nghệ Sĩ",
          style: TextStyle(
            fontFamily: "AB",
            fontSize: 16,
            color: AppColors.lightBg,
          ),
        ),
        centerTitle: true,
      ),
        body: SafeArea(
          child: BlocBuilder<GetArtistCubit, GetArtistsState>(
            builder: (context, state) {
              if (state is GetArtistsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetArtistsLoaded) {
                _artists = state.artists;
                final filteredArtists = _filterArtists(_searchQuery);

                return Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    CustomScrollView(
                      slivers: [
                        _header(context),
                        _SearchBox(
                          onSearch: (query) {
                            setState(() {
                              _searchQuery = query;
                            });
                          },
                        ),
                        _artistList(filteredArtists),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.darkBg.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(90, 42),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          backgroundColor: AppColors.lightBg,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChoosePodcastScreen(
                                songs: widget.songs,
                                currentIndex: widget.currentIndex,
                                artists: _artists,
                                podcasts: widget.podcasts,
                                albums: widget.albums,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Xác Nhận",
                          style: TextStyle(
                            fontFamily: "AB",
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is GetArtistsLoadFailure) {
                return const Center(
                  child: Text(
                    "Không thể tải danh sách nghệ sĩ",
                    style: TextStyle(
                      fontFamily: "AB",
                      fontSize: 18,
                      color: AppColors.lightBg,
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    "Trạng thái không xác định",
                    style: TextStyle(
                      fontFamily: "AB",
                      fontSize: 18,
                      color: AppColors.lightBg,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(bottom: 22, top: 35, right: 25, left: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "CHỌN CÁC NGHỆ SĨ MÀ BẠN THÍCH",
              style: TextStyle(
                fontFamily: "AB",
                fontSize: 16,
                color: AppColors.lightBg,
              ),
            ),
            SizedBox(
              height: 1,
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _artistList(List<ArtistEntity> artists) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Center(
              child: ArtistAvatar(
                artist: artists[index],
              ),
            );
          },
          childCount: artists.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          mainAxisExtent: 200,
        ),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final Function(String) onSearch;

  const _SearchBox({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 25, left: 25),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 42,
          decoration: const BoxDecoration(
            color: AppColors.lightBg,
            borderRadius: BorderRadius.all(
              Radius.circular(7),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Image.asset("assets/images/icon_Search.png"),
                const SizedBox(width: 10),
                Flexible(
                  child: TextField(
                    onChanged: onSearch,
                    enableIMEPersonalizedLearning: true,
                    style: const TextStyle(
                      fontFamily: "AM",
                      fontSize: 16,
                      color: AppColors.darkBg,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 15, left: 15),
                      hintText: "Tìm kiếm",
                      hintStyle: TextStyle(
                        fontFamily: "AM",
                        color: AppColors.darkBg,
                        fontSize: 14,
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
      ),
    );
  }
}
