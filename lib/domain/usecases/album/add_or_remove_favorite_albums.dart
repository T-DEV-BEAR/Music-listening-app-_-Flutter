import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/album/album.dart';

import '../../../service_locator.dart';

class AddOrRemoveFavoriteAlbumsUseCase implements UseCase<Either,String> {
  @override
  Future<Either> call({String ? params}) async {
    return await sl<AlbumRepository>().addOrRemoveFavoriteAlbums(params!);
  }
}