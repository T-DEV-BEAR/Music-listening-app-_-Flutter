import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/album/album.dart';
import '../../../service_locator.dart';

class IsFavoriteAlbumUseCase implements UseCase<bool,String> {
  @override
  Future<bool> call({String ? params}) async {
    return await sl<AlbumRepository>().isFavoriteAlbums(params!);
  }
}