import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/artist/artist.dart';

import '../../../service_locator.dart';

class AddOrRemoveFavoriteArtistsUseCase implements UseCase<Either,String> {
  @override
  Future<Either> call({String ? params}) async {
    return await sl<ArtistRepository>().addOrRemoveFavoriteArtists(params!);
  }
}