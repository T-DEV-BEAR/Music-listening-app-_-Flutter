import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/podcast/podcast.dart';

import '../../../service_locator.dart';

class GetFavoritePodcastsUseCase implements UseCase<Either,dynamic> {
  @override
  Future<Either> call({params}) async{
    return await sl<PodcastRepository>().getUserFavoritePodcasts();
  }
}