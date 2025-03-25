import 'package:get_it/get_it.dart';
import 'package:spotify/data/repository/album/album_repository_impl.dart';

import 'package:spotify/data/repository/artists/artist_repository_impl.dart';
import 'package:spotify/data/repository/authen/authen_repository_impl.dart';
import 'package:spotify/data/repository/podcast/podcast_repository_impl.dart';
import 'package:spotify/data/repository/song/song_repository_impl.dart';
import 'package:spotify/data/sources/album/album_firebase_service.dart';

import 'package:spotify/data/sources/artist/artist_firebase_service.dart';
import 'package:spotify/data/sources/authen/authen_firebase_service.dart';
import 'package:spotify/data/sources/podcast/podcast_firebase_service.dart';
import 'package:spotify/data/sources/song/song_firebase_service.dart';
import 'package:spotify/domain/repository/album/album.dart';
import 'package:spotify/domain/repository/artist/artist.dart';
import 'package:spotify/domain/repository/authen/authen.dart';
import 'package:spotify/domain/repository/podcast/podcast.dart';
import 'package:spotify/domain/repository/song/song.dart';
import 'package:spotify/domain/usecases/album/add_or_remove_favorite_albums.dart';
import 'package:spotify/domain/usecases/album/get_albums.dart';
import 'package:spotify/domain/usecases/album/get_favorite_albums.dart';
import 'package:spotify/domain/usecases/album/get_songs_from_album.dart';
import 'package:spotify/domain/usecases/album/is_favorite_album.dart';
import 'package:spotify/domain/usecases/artist/add_or_remove_favorite_artists.dart';
import 'package:spotify/domain/usecases/artist/get_artists.dart';
import 'package:spotify/domain/usecases/artist/get_favorite_artists.dart';
import 'package:spotify/domain/usecases/artist/get_songs_from_artist.dart';
import 'package:spotify/domain/usecases/artist/is_favorite_artist.dart';
import 'package:spotify/domain/usecases/authen/facebook_sign_up.dart';
import 'package:spotify/domain/usecases/authen/get_user.dart';
import 'package:spotify/domain/usecases/authen/google_sign_up.dart';
import 'package:spotify/domain/usecases/authen/sigin.dart';
import 'package:spotify/domain/usecases/authen/signup.dart';
import 'package:spotify/domain/usecases/podcast/add_or_remove_favorite_podcasts.dart';
import 'package:spotify/domain/usecases/podcast/get_favorite_podcasts.dart';
import 'package:spotify/domain/usecases/podcast/get_podcasts.dart';
import 'package:spotify/domain/usecases/podcast/is_favorite_podcast.dart';
import 'package:spotify/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:spotify/domain/usecases/song/get_favorite_songs.dart';
import 'package:spotify/domain/usecases/song/get_news_episoded.dart';
import 'package:spotify/domain/usecases/song/get_news_songs.dart';
import 'package:spotify/domain/usecases/song/get_play_list.dart';
import 'package:spotify/domain/usecases/song/is_favorite_song.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  //Dang nhap 
  sl.registerSingleton<AuthenFirebaseService>(AuthenFirebaseServiceImpl());

  sl.registerSingleton<AuthenReponsitory>(AuthenRepositoryImpl());

  sl.registerSingleton<SignupUseCase>(SignupUseCase());

  sl.registerSingleton<SignupFacebookUseCase>(SignupFacebookUseCase());

  sl.registerSingleton<SignupGoogleUseCase>(SignupGoogleUseCase());

  sl.registerSingleton<SigninUseCase>(SigninUseCase());


  //Firebase cua Song
  sl.registerSingleton<SongFirebaseService>(SongFirebaseServiceImpl());

  sl.registerSingleton<SongsRepository>(SongRepositoryImpl());

  sl.registerSingleton<GetNewsSongsUseCase>(GetNewsSongsUseCase());

  sl.registerSingleton<GetPlayListUseCase>(GetPlayListUseCase());

  sl.registerSingleton<AddOrRemoveFavoriteSongUseCase>(
      AddOrRemoveFavoriteSongUseCase());

  sl.registerSingleton<IsFavoriteSongUseCase>(IsFavoriteSongUseCase());

  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());

  sl.registerSingleton<GetFavoriteSongsUseCase>(GetFavoriteSongsUseCase());

  sl.registerSingleton<GetNewsEpisodedUseCase>(GetNewsEpisodedUseCase());

  //Artists
  sl.registerSingleton<ArtistRepository>(ArtistRepositoryImpl());

  sl.registerSingleton<ArtistFirebaseService>(ArtistFirebaseServiceImpl());

  sl.registerSingleton<IsFavoriteArtistUseCase>(IsFavoriteArtistUseCase());

  sl.registerSingleton<GetArtistsUseCase>(GetArtistsUseCase());

  sl.registerSingleton<AddOrRemoveFavoriteArtistsUseCase>(
      AddOrRemoveFavoriteArtistsUseCase());

  sl.registerSingleton<GetFavoriteArtistsUseCase>(GetFavoriteArtistsUseCase());

  //Podcast
  sl.registerSingleton<PodcastRepository>(PodcastRepositoryImpl());

  sl.registerSingleton<PodcastFirebaseService>(PodcastFirebaseServiceImpl());

  sl.registerSingleton<IsFavoritePodCastUseCase>(IsFavoritePodCastUseCase());

  sl.registerSingleton<GetPodcastsUseCase>(GetPodcastsUseCase());

  sl.registerSingleton<AddOrRemoveFavoritePodcastsUseCase>(AddOrRemoveFavoritePodcastsUseCase());


  sl.registerSingleton<GetFavoritePodcastsUseCase>(GetFavoritePodcastsUseCase());
  
  sl.registerSingleton<GetSongsFromArtistUseCase>( GetSongsFromArtistUseCase());


  
  //Album
  sl.registerSingleton<AlbumRepository>(AlbumRepositoryImpl());

  sl.registerSingleton<AlbumFirebaseService>(AlbumFirebaseServiceImpl());

  sl.registerSingleton<IsFavoriteAlbumUseCase>(IsFavoriteAlbumUseCase());

  sl.registerSingleton<GetAlbumsUseCase>(GetAlbumsUseCase());

  sl.registerSingleton<AddOrRemoveFavoriteAlbumsUseCase>(AddOrRemoveFavoriteAlbumsUseCase());


  sl.registerSingleton<GetFavoriteAlbumsUseCase>(GetFavoriteAlbumsUseCase());
  
  sl.registerSingleton<GetSongsFromAlbumUseCase>( GetSongsFromAlbumUseCase());


}
