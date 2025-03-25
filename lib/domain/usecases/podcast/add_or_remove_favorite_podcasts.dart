import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/podcast/podcast.dart';

import '../../../service_locator.dart';

class AddOrRemoveFavoritePodcastsUseCase implements UseCase<Either,String> {
  @override
  Future<Either> call({String ? params}) async {
    return await sl<PodcastRepository>().addOrRemoveFavoritePodcasts(params!);
  }
}