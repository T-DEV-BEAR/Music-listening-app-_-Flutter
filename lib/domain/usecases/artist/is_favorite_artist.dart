import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/artist/artist.dart';
import '../../../service_locator.dart';

class IsFavoriteArtistUseCase implements UseCase<bool,String> {
  @override
  Future<bool> call({String ? params}) async {
    return await sl<ArtistRepository>().isFavoriteArtists(params!);
  }
}