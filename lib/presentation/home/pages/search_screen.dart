// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:spotify/core/configs/constants/app_urls.dart';
// import 'package:spotify/core/configs/theme/app_colors.dart';
// import 'package:spotify/domain/entities/podcast/podcast.dart';
// import 'package:spotify/domain/entities/song/song.dart';
// import 'package:spotify/presentation/bloc/get_podcasts_cubit.dart';
// import 'package:spotify/presentation/bloc/get_podcasts_state.dart';
// import 'package:spotify/presentation/home/bloc/play_list_cubit.dart';
// import 'package:spotify/presentation/home/bloc/play_list_state.dart';
// import 'package:spotify/presentation/song_player/pages/song_player.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import '../../song_player/pages/podcast_player.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   String _searchQuery = ''; // lưu chuỗi người dùng ghi vào
//   bool isListening = false; // dùng để kiểm tra xem mic có đang nghe hay không
//   late stt.SpeechToText _speechToText;
//   String micResultText = ''; // lưu kết quả tìm kiếm bằng giọng nói
//   final List<String> suggestions = [];
//   final SearchController _searchController = SearchController();

//   @override
//   void initState() {
//     _speechToText = stt.SpeechToText();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _speechToText.cancel();
//     super.dispose();
//   }

//   void _captureVoice() async {
//     if (!isListening) {
//       bool available = await _speechToText.initialize();
//       if (available) {
//         setState(() => isListening = true);
//         _speechToText.listen(
//           onResult: (result) => setState(() {
//             if (result.recognizedWords.isNotEmpty) {
//               micResultText = result.recognizedWords;
//               _searchController.text = micResultText;
//               _searchQuery = micResultText;
//             }
//           }),
//           localeId: 'vi-VN',
//           listenFor: const Duration(seconds: 5),
//         );
//       }
//     } else {
//       setState(() => isListening = false);
//       _speechToText.stop();
//     }

//     Future.delayed(const Duration(seconds: 5), () {
//       if (isListening) {
//         _speechToText.stop();
//         setState(() {
//           isListening = false;
//           if (micResultText.isEmpty) {
//             micResultText = "Không nghe thấy gì. Bấm vào nút để thử lại.";
//           }
//         });
//       }
//     });
//   }

//   // Tìm kiếm bài hát dựa trên từ khóa
//   List<SongEntity> _searchByNameSongsAndArtists(
//       List<SongEntity> songs, String query) {
//     if (query.isEmpty) return songs;
//     String normalizedQuery = query.toLowerCase();
//     return songs.where((song) {
//       return song.title.toLowerCase().contains(normalizedQuery) ||
//           song.artist.toLowerCase().contains(normalizedQuery);
//     }).toList();
//   }

//   // Tìm kiếm podcast dựa trên từ khóa
//   List<PodcastEntity> _searchByNamePodCasts(
//       List<PodcastEntity> podcasts, String query) {
//     if (query.isEmpty) return podcasts;
//     String normalizedQuery = query.toLowerCase();
//     return podcasts.where((podcast) {
//       return podcast.title.toLowerCase().contains(normalizedQuery) ||
//           podcast.podcast.toLowerCase().contains(normalizedQuery);
//     }).toList();
//   }

//   Widget _songs(List<SongEntity> songs) {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (BuildContext context) => SongPlayerPage(
//                   currentIndex: index,
//                   songs: songs,
//                 ),
//               ),
//             );
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 height: 70,
//                 width: 70,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(
//                       '${AppURLs.coverFirestorage}${songs[index].artist} - ${songs[index].title}.jpg?${AppURLs.mediaAlt}',
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       songs[index].title.length > 30
//                           ? '${songs[index].title.substring(0, 30)}...'
//                           : songs[index].title,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       songs[index].artist,
//                       style: const TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//       separatorBuilder: (context, index) => const SizedBox(height: 20),
//       itemCount: songs.length,
//     );
//   }

//   Widget _podcasts(List<PodcastEntity> podcasts) {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (BuildContext context) => PodcastPlayer(
//                   currentIndex: index,
//                   podcasts: podcasts,
//                 ),
//               ),
//             );
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 height: 70,
//                 width: 70,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(
//                       '${AppURLs.podcaseCoverFirestorage}${podcasts[index].podcast} - ${podcasts[index].title}.jpg?${AppURLs.mediaAlt}',
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       podcasts[index].title.length > 30
//                           ? '${podcasts[index].title.substring(0, 30)}...'
//                           : podcasts[index].title,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       podcasts[index].podcast,
//                       style: const TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//       separatorBuilder: (context, index) => const SizedBox(height: 20),
//       itemCount: podcasts.length,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.darkBg,
//             appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 27, 27, 27),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           color: AppColors.lightBg,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           "Tìm Kiếm",
//           style: TextStyle(
//             fontFamily: "AB",
//             fontSize: 16,
//             color: AppColors.lightBg,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         height: 35,
//                         width: MediaQuery.of(context).size.width - 102.5,
//                         decoration: const BoxDecoration(
//                           color: Color(0xff282828),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           child: Row(
//                             children: [
//                               const Icon(Icons.search,
//                                   color: AppColors.primary),
//                               Expanded(
//                                 child: TextField(
//                                   controller: _searchController,
//                                   style: const TextStyle(
//                                     fontFamily: "AM",
//                                     fontSize: 16,
//                                     color: AppColors.lightBg,
//                                   ),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _searchQuery = value;
//                                     });
//                                   },
//                                   decoration: const InputDecoration(
//                                     contentPadding:
//                                         EdgeInsets.only(top: 10, left: 15),
//                                     hintText:"Tìm Kiếm bài hát",
//                                     hintStyle: TextStyle(
//                                       fontFamily: "AM",
//                                       color: AppColors.primary,
//                                       fontSize: 15,
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         style: BorderStyle.none,
//                                         width: 0,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       AvatarGlow(
//                         animate: isListening,
//                         glowColor: const Color.fromARGB(255, 194, 191, 191),
//                         duration: const Duration(milliseconds: 1000),
//                         repeat: true,
//                         child: IconButton(
//                           onPressed: _captureVoice,
//                           icon: Icon(isListening ? Icons.mic : Icons.mic_none),
//                           color: AppColors.primary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 15, bottom: 10),
//                   child: Text(
//                     "Tìm kiếm gần đây",
//                     style: TextStyle(
//                       fontFamily: "AM",
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.lightBg,
//                       fontSize: 17,
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: BlocProvider(
//                   create: (_) => PlayListCubit()..getPlayList(),
//                   child: BlocBuilder<PlayListCubit, PlayListState>(
//                     builder: (context, state) {
//                       if (state is PlayListLoading) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else if (state is PlayListLoaded) {
//                         final filteredSongs = _searchByNameSongsAndArtists(
//                             state.songs, _searchQuery);
//                         return _songs(filteredSongs);
//                       }
//                       return Container();
//                     },
//                   ),
//                 ),
//               ),
//               // Hiển thị danh sách podcast
//               SliverToBoxAdapter(
//                 child: BlocProvider(
//                   create: (_) => GetPodcastCubit()..getPodcasts(),
//                   child: BlocBuilder<GetPodcastCubit, GetPodcastsState>(
//                     builder: (context, state) {
//                       if (state is GetPodcastsLoading) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else if (state is GetPodcastsLoaded) {
//                         final filteredPodcasts =
//                             _searchByNamePodCasts(state.podcasts, _searchQuery);
//                         return _podcasts(filteredPodcasts);
//                       }
//                       return Container();
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/home/bloc/play_list_cubit.dart';
import 'package:spotify/presentation/home/bloc/play_list_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../common/widgets/appbar/app_bar.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../bloc/get_podcasts_cubit.dart';
import '../../bloc/get_podcasts_state.dart';
import '../../song_player/pages/podcast_player.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = ''; // lưu chuỗi người dùng ghi vào
  bool isListening = false; // dùng để kiểm tra xem mic có đang nghe hay không
  late stt.SpeechToText _speechToText;
  String micResultText = ''; // lưu kết quả tìm kiếm bằng giọng nói
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    _speechToText = stt.SpeechToText(); // Khởi tạo đối tượng Speech to text
    super.initState();
  }

  @override
  void dispose() {
    _speechToText.cancel(); // kết thúc lắng nghe
    super.dispose();
  }

  void _captureVoice() async {
    if (!isListening) {
      bool available =
          await _speechToText.initialize(); // kiểm tra mic có sẵn sàng không
      if (available) {
        setState(() => isListening = true);
        _speechToText.listen(
          onResult: (result) => setState(() {
            if (result.recognizedWords.isNotEmpty) {
              // cập nhật kết quả lắng nghe vào micResultText và _searchQuery
              micResultText = result.recognizedWords;
              _searchController.text = micResultText;
              _searchQuery = micResultText;
            }
          }),
          localeId: 'vi-VN', // đặt ngôn ngữ là tiếng việt
          listenFor: const Duration(seconds: 5), // lắng nghe trong 5s
        );
      }
    } else {
      setState(() => isListening = false); // dừng nghe
      _speechToText.stop();
    }

    // Kiểm tra lắng nghe nếu không có kq
    Future.delayed(const Duration(seconds: 5), () {
      if (isListening) {
        _speechToText.stop(); // dừng nghe
        setState(() {
          isListening = false;
          if (micResultText.isEmpty) {
            micResultText = "Không nghe thấy gì. Bấm vào nút để thử lại.";
          }
        });
      }
    });
  }

  // Tìm kiếm bài hát dựa trên từ khóa
  List<SongEntity> _searchByNameSongsAndArtists(
      List<SongEntity> songs, String query) {
    if (query.isEmpty) return songs; // Nếu query trống thì trả về danh sách gốc
    String normalizedQuery = query.toLowerCase(); // Đưa về chữ thường
    return songs.where((song) {
      return song.title.toLowerCase().contains(normalizedQuery) ||
          song.artist.toLowerCase().contains(normalizedQuery);
    }).toList(); // Lọc danh sách bài hát theo query
  }

  // Tìm kiếm podcast dựa trên từ khóa
  List<PodcastEntity> _searchByNamePodCasts(
      List<PodcastEntity> podcasts, String query) {
    if (query.isEmpty) return podcasts;
    String normalizedQuery = query.toLowerCase();
    return podcasts.where((podcast) {
      return podcast.title.toLowerCase().contains(normalizedQuery) ||
          podcast.podcast.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  // List<PodcastEntity> _search(List<AlbumEntity> albums, String query) {
  //   if (query.isEmpty) return albums;
  //   String normalizedQuery = query.toLowerCase();
  //   return albums.where((albums) {
  //     return podcast.title.toLowerCase().contains(normalizedQuery);
  //   }).toList();
  // }

  // Hàm hiển thị danh sách các bài hát
  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            //chuyển đến trang bài hát khi nhấn vào
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SongPlayerPage(
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

  // Hàm xây dựng danh sách các podcast
  Widget _podcasts(List<PodcastEntity> podcasts) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => PodcastPlayer(
                  currentIndex: index,
                  podcasts: podcasts,
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
                      '${AppURLs.podcaseCoverFirestorage}${podcasts[index].podcast} - ${podcasts[index].title}.jpg?${AppURLs.mediaAlt}',
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
                      podcasts[index].title.length > 30
                          ? '${podcasts[index].title.substring(0, 30)}...'
                          : podcasts[index].title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      podcasts[index].podcast,
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
      itemCount: podcasts.length,
    );
  }

  // Hàm xây dựng giao diện màn hình tìm kiếm
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        //backgroundColor: AppColors.primary,
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      backgroundColor: AppColors.darkBg,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
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
                              const Icon(Icons.search,
                                  color: AppColors.primary),
                              Expanded(
                                child:
                                    // thanh tìm kiếm
                                    TextField(
                                  controller: _searchController,
                                  style: const TextStyle(
                                    fontFamily: "AM",
                                    fontSize: 16,
                                    color: AppColors.lightBg,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery =
                                          value; // Cập nhật từ khóa tìm kiếm
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(top: 10, left: 15),
                                    hintText:
                                        "Tìm kiếm bài hát, nghệ sĩ hoặc podcast",
                                    hintStyle: TextStyle(
                                      fontFamily: "AM",
                                      color: AppColors.primary,
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
                      AvatarGlow(
                        animate: isListening,
                        glowColor: const Color.fromARGB(255, 194, 191, 191),
                        duration: const Duration(milliseconds: 1000),
                        repeat: true,
                        child: IconButton(
                          onPressed:
                              _captureVoice, // Gọi hàm khi nhấn vào nút  micro
                          icon: Icon(isListening ? Icons.mic : Icons.mic_none),
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
              // sử dụng SliverToBoxAdapter để tạo nd theo dạng cuộn
              SliverToBoxAdapter(
                // Hiển thị kết quả tìm kiếm
                child: BlocProvider(
                  create: (_) => PlayListCubit()
                    ..getPlayList(), //gọi phương thức getPlayList để tải dữ liệu danh sách bài hát.
                  child: BlocBuilder<PlayListCubit, PlayListState>(
                    builder: (context, state) {
                      if (state is PlayListLoading) {
                        //hiển thị CircularProgressIndicator để thông báo người dùng rằng danh sách bài hát đang được tải.
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is PlayListLoaded) {
                        final filteredSongs = _searchByNameSongsAndArtists(
                            // hàm searchByNameSongsAndArtists để lọc các bài hát theo từ khóa tìm kiếm searchQuery
                            state.songs,
                            _searchQuery);
                        return _songs(
                            filteredSongs); // trả về danh sách các bài hát đã lọc
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              // Hiển thị danh sách podcast
              SliverToBoxAdapter(
                child: BlocProvider(
                  //Tạo và cung cấp PodListCubit, gọi getPodList để tải dữ liệu danh sách podcast.
                  create: (_) => GetPodcastCubit()..getPodcasts(),
                  child: BlocBuilder<GetPodcastCubit, GetPodcastsState>(
                    builder: (context, state) {
                      if (state is GetPodcastsLoading) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // hiển thị vòng xoay CircularProgressIndicator.
                      } else if (state is GetPodcastsLoaded) {
                        final filteredPodcasts = _searchByNamePodCasts(
                            state.podcasts,
                            _searchQuery); //để lọc các podcast dựa trên từ khóa tìm kiếm
                        return _podcasts(
                            filteredPodcasts); // là danh sách các podcast đã lọc.
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
}
