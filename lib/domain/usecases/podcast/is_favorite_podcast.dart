import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/podcast/podcast.dart';
import '../../../service_locator.dart';

class IsFavoritePodCastUseCase implements UseCase<bool,String> {
  @override
  Future<bool> call({String ? params}) async {
    return await sl<PodcastRepository>().isFavoritePodcasts(params!);
  }
}