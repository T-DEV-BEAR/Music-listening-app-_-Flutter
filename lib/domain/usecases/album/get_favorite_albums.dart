import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/album/album.dart';

import '../../../service_locator.dart';

class GetFavoriteAlbumsUseCase implements UseCase<Either,dynamic> {
  @override
  Future<Either> call({params}) async{
    return await sl<AlbumRepository>().getUserFavoriteAlbums();
  }
}