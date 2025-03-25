import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:spotify/core/configs/theme/app_theme.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/firebase_options.dart';
import 'package:spotify/notifications/notifications_service.dart';
import 'package:spotify/presentation/album_player/bloc/album_control_cubit.dart';
import 'package:spotify/presentation/artist_player/bloc/artist_control_cubit.dart';
import 'package:spotify/presentation/authen/bloc/favorite_album_cubit.dart';
import 'package:spotify/presentation/authen/bloc/favorite_artist_cubit.dart';
import 'package:spotify/presentation/authen/bloc/favorite_podcast_cubit.dart';
import 'package:spotify/presentation/bloc/theme_cubit.dart';
import 'package:spotify/presentation/home/bloc/news_episoded_cubit.dart';
import 'package:spotify/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/podcast_player_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/splash/splash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDependencies();
  
  NotificationService().initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  final List<SongEntity> songs = [];
  const int currentIndex = 0; 
  final List<ArtistEntity> artists =[];
  final List<PodcastEntity> podcasts=[];
  final List<AlbumEntity> albums=[];

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => SongPlayerCubit()),
        BlocProvider(create: (_) => PodcastPlayerCubit()),       
        BlocProvider(create: (_) => FavoriteSongsCubit()..getFavoriteSongs(),),
        BlocProvider(create: (_) => FavoriteArtistCubit()..getFavoriteArtists()),
        BlocProvider(create: (_) => FavoritePodcastCubit()..getFavoritePodcasts()),
        BlocProvider(create: (_) => FavoriteAlbumCubit()..getFavoriteAlbums()),
        BlocProvider(create: (_) => ArtistControlCubit()..getArtists()),
        BlocProvider(create: (_) => AlbumControlCubit()..getAlbums()),
        BlocProvider(create: (_) => NewsEpisodedCubit()..getNewsEpisodedSongs()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          debugShowCheckedModeBanner: false,
          home: SplashPage(
            songs: songs,
            currentIndex: currentIndex,
            artists: artists,
            podcasts: podcasts,
            albums: albums,
          ),
        ),
      ),
    );
  }
}
