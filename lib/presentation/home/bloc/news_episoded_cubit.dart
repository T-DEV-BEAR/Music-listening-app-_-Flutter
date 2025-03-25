import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/song/get_news_episoded.dart';
import 'package:spotify/presentation/home/bloc/news_episoded_state.dart';

import '../../../service_locator.dart';

enum SortNewsEpisodedOption { recent, recentlyAdded, alphabetical }

class NewsEpisodedCubit extends Cubit<NewsEpisodedState> {
  List<SongEntity> newSongsEpisoded = [];

  NewsEpisodedCubit() : super(NewsEpisodedLoading());

  Future<void> getNewsEpisodedSongs() async {
    emit(NewsEpisodedLoading());

    var returnedSongs = await sl<GetNewsEpisodedUseCase>().call();
    returnedSongs.fold(
      (l) {
        emit(NewsEpisodedFailure());
      },
      (data) {
        newSongsEpisoded = data;
        emit(NewsEpisodedLoaded(songs: newSongsEpisoded));
      },
    );
  }

  void sortSongs(SortNewsEpisodedOption option) {
    switch (option) {
      case SortNewsEpisodedOption.recent:
        newSongsEpisoded.sort((a, b) => b.duration.compareTo(a.duration));
        break;
      case SortNewsEpisodedOption.recentlyAdded:
        newSongsEpisoded.sort((a, b) => b.release.compareTo(a.release));
        break;
      case SortNewsEpisodedOption.alphabetical:
        newSongsEpisoded.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
    }
    // Phát hành danh sách đã sắp xếp để BlocBuilder cập nhật
    emit(NewsEpisodedLoaded(songs: List.from(newSongsEpisoded)));
  }
}
