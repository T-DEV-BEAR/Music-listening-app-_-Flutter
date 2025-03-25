import 'package:dartz/dartz.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/repository/artist/artist.dart';
import '../../../service_locator.dart';
import '../../../core/usecase/usecase.dart';

class GetSongsFromArtistUseCase implements UseCase<Either<Exception, ArtistEntity>, String> {
  @override
  Future<Either<Exception, ArtistEntity>> call({String? params}) async {
    try {
      final artistWithSongs = await sl<ArtistRepository>().getArtistWithSongs(params!);
      return Right(artistWithSongs);
    } catch (e) {
      return Left(Exception('Failed to load songs for artist: $e'));
    }
  }
}
