import 'package:dartz/dartz.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/repository/album/album.dart';
import '../../../service_locator.dart';
import '../../../core/usecase/usecase.dart';

class GetSongsFromAlbumUseCase implements UseCase<Either<Exception, AlbumEntity>, String> {
  @override
  Future<Either<Exception, AlbumEntity>> call({String? params}) async {
    try {
      final albumWithSongs = await sl<AlbumRepository>().getAlbumWithSongs(params!);
      return Right(albumWithSongs);
    } catch (e) {
      return Left(Exception('Failed to load songs for artist: $e'));
    }
  }
}
