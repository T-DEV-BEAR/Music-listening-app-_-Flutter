import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/bloc/get_podcasts_cubit.dart';
import 'package:spotify/presentation/bloc/get_podcasts_state.dart';
import 'package:spotify/presentation/home/pages/dashboard_screen.dart';
import 'package:spotify/presentation/authen/widgets/podcast_avatar_widget.dart';

class ChoosePodcastScreen extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const ChoosePodcastScreen({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  _ChoosePodcastScreenState createState() => _ChoosePodcastScreenState();
}

class _ChoosePodcastScreenState extends State<ChoosePodcastScreen> {
  List<PodcastEntity> _podcasts = [];
  String _searchQuery = '';

  // Hàm lọc danh sách podcast dựa trên từ khóa tìm kiếm
  List<PodcastEntity> _filterPodcasts(String query) {
    if (query.isEmpty) return _podcasts;
    return _podcasts.where((podcast) {
      return podcast.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetPodcastCubit()..getPodcasts(),
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
          child: BlocBuilder<GetPodcastCubit, GetPodcastsState>(
            builder: (context, state) {
              if (state is GetPodcastsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetPodcastsLoaded) {
                _podcasts = state.podcasts; // Cập nhật danh sách podcast từ API
                final filteredPodcasts = _filterPodcasts(_searchQuery);
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
                        _podcastList(filteredPodcasts),
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
                          minimumSize: const Size(100, 55),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          backgroundColor: AppColors.lightBg,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashBoardScreen(
                                songs: widget.songs,
                                currentIndex: widget.currentIndex,
                                artists: widget.artists,
                                podcasts: widget.podcasts,
                                albums: widget.albums,
                              ),
                            ),
                            (route) => false,
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
              } else {
                return const Center(
                  child: Text(
                    "Snap! Error Happened",
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
              "HÃY CHỌN PODCAST MÀ BẠN THÍCH",
              style: TextStyle(
                fontFamily: "AB",
                fontSize: 17,
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

  Widget _podcastList(List<PodcastEntity> podcasts) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 90),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return PodcastAvatarWidget(
              podcast: podcasts[index],
            );
          },
          childCount: podcasts.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 165,
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
        padding: const EdgeInsets.only(bottom: 35, right: 25, left: 25),
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
                    style: const TextStyle(
                      fontFamily: "AM",
                      fontSize: 16,
                      color: AppColors.darkBg,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 15, left: 15),
                      hintText: "Tìm kiếm ",
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
