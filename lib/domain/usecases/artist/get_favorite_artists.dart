import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/artist/artist.dart';

import '../../../service_locator.dart';

class GetFavoriteArtistsUseCase implements UseCase<Either,dynamic> {
  @override
  Future<Either> call({params}) async{
    return await sl<ArtistRepository>().getUserFavoriteArtists();
  }
}