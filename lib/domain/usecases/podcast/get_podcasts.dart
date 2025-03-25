import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/podcast/podcast.dart';
import 'package:spotify/service_locator.dart';

class GetPodcastsUseCase implements UseCase<Either,dynamic> {
  @override
  Future<Either> call({params}) async{
    return await sl<PodcastRepository>().getPodcasts();
  }
}