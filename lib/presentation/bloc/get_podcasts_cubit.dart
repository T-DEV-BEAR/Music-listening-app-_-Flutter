import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/podcast/get_podcasts.dart';
import 'package:spotify/presentation/bloc/get_podcasts_state.dart';

import '../../../service_locator.dart';

class GetPodcastCubit extends Cubit<GetPodcastsState> {

  GetPodcastCubit() : super(GetPodcastsLoading());

  Future<void> getPodcasts() async {
  var returnedPodcasts = await sl<GetPodcastsUseCase>().call();
  returnedPodcasts.fold(
    (l) {
      // ignore: avoid_print
      print('Failed to load Podcasts: $l');
      emit(GetPodcastsLoadFailure());
    },
    (data) {
      // ignore: avoid_print
      print('Podcasts loaded: ${data.length}');
      emit(GetPodcastsLoaded(podcasts: data));
    }
  );
}
}