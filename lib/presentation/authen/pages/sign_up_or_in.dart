import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/helpers/if_dark.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/button/basic_app_button.dart';
import 'package:spotify/core/configs/assets/app_images.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/data/models/authen/create_user_req.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/authen/facebook_sign_up.dart';
import 'package:spotify/domain/usecases/authen/google_sign_up.dart';
import 'package:spotify/presentation/authen/pages/choose_artist_screen.dart';
import 'package:spotify/presentation/authen/pages/sign_in.dart';
import 'package:spotify/presentation/authen/pages/sign_up.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spotify/presentation/bloc/get_artists_cubit.dart';
import 'package:spotify/service_locator.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignUpOrIn extends StatelessWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const SignUpOrIn({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BasicAppbar(),
          Align(
            alignment: Alignment.topLeft,
            child: SvgPicture.asset(AppVectors.topPattern),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(AppVectors.bottomPattern),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(AppImages.authBG),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
              child: Column(
                children: [
                  SvgPicture.asset(AppVectors.logo),
                  const SizedBox(height: 30),
                  const Text(
                    'Lắng Nghe Âm Nhạc Bằng Nhịp Đập Trái Tim Của Bạn!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 21),
                  const Text(
                    'Spotify là một dịch vụ phát trực tuyến âm thanh và phương tiện truyền thông dành cho người nghe. ',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: AppColors.greyText),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: BasicAppButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SignUp(
                                  songs: songs,
                                  currentIndex: currentIndex,
                                  artists: artists,
                                  podcasts: podcasts,
                                  albums: albums,
                                ),
                              ),
                            );
                          },
                          title: 'Đăng Ký',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) {
                                    var cubit = GetArtistCubit();
                                    cubit.getArtists();
                                    return cubit;
                                  },
                                  child: SignIn(
                                    songs: songs, // Truyền songs vào
                                    currentIndex: currentIndex,
                                    artists: artists,
                                    podcasts: podcasts,
                                    albums: albums,
                                  ),
                                ),
                              ),                           
                            );
                          },
                          child: Text(
                            'Đăng Nhập',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: context.isDarkmode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 49),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            side: const BorderSide(
                              width: 1,
                              color: AppColors.lightGrey,
                            ),
                          ),
                          onPressed: () async {
                            await _signInWithFacebook(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.iconFaceBook),
                              const SizedBox(width: 10),
                              Text(
                                "Đăng Nhập Với Facebook",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: context.isDarkmode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 49),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            side: const BorderSide(
                              width: 1,
                              color: AppColors.lightGrey,
                            ),
                          ),
                          onPressed: () async {
                            await _signInWithGoogle(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.iconGoogle),
                              const SizedBox(width: 10),
                              Text(
                                "Đăng Nhập với Google",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: context.isDarkmode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 49),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            side: const BorderSide(
                              width: 1,
                              color: AppColors.lightGrey,
                            ),
                          ),
                          onPressed: () async {
                            // Implement phone sign-in logic here
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.iconPhone),
                              const SizedBox(width: 10),
                              Text(
                                "Đăng Nhập Bằng SĐT",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: context.isDarkmode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        var snackbar = const SnackBar(
          content: Text("Đăng nhập Google bị huỷ"),
          behavior: SnackBarBehavior.floating,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return;
      }

      // ignore: unnecessary_nullable_for_final_variable_declarations
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      var result = await FirebaseAuth.instance.signInWithCredential(credential);
      
      if (result.user != null) {
        // ignore: no_leading_underscores_for_local_identifiers
        String _email = result.user!.email ?? '';
        // ignore: no_leading_underscores_for_local_identifiers
        String _name = result.user!.displayName ?? 'Unknown';

        await sl<SignupGoogleUseCase>().call(
          params: CreateUserReq(
            fullName: _name,
            email: _email,
            password: googleAuth?.idToken ?? '',
          ),
        );

        // Điều hướng đến ChooseArtistScreen và truyền songs và currentIndex
        Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) {
                var cubit = GetArtistCubit();
                cubit.getArtists();
                return cubit;
              },
              child: ChooseArtistScreen(
                songs: songs,
                currentIndex: currentIndex,
                artists: artists,
                podcasts: podcasts,
                albums: albums,
              ),
            ),
          ),
          (route) => false,
        );
      } else {
        var snackbar = const SnackBar(
          content: Text("Đăng nhập Google thất bại"),
          behavior: SnackBarBehavior.floating,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (error) {
      var snackbar = SnackBar(
        content: Text("Có lỗi xảy ra: $error"),
        behavior: SnackBarBehavior.floating,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        // ignore: await_only_futures
        final AccessToken? accessToken = await loginResult.accessToken;

        if (accessToken == null) {
          throw FirebaseAuthException(
            code: "ERROR",
            message: "Failed to get access token.",
          );
        }

        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        final UserCredential result = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        if (result.user != null) {
          // ignore: no_leading_underscores_for_local_identifiers
          String _emailfb = result.user!.email ?? '';
          // ignore: no_leading_underscores_for_local_identifiers
          String _namefb = result.user!.displayName ?? 'Unknown';

          await sl<SignupFacebookUseCase>().call(
            params: CreateUserReq(
              fullName: _namefb,
              email: _emailfb,
              password: accessToken.tokenString,
            ),
          );

          // Điều hướng đến HomePage và truyền songs và currentIndex
          Navigator.pushAndRemoveUntil(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) {
                  var cubit = GetArtistCubit();
                  cubit.getArtists();
                  return cubit;
                },
                child: ChooseArtistScreen(
                  songs: songs, // Truyền songs vào
                  currentIndex: currentIndex, // Truyền currentIndex vào
                  artists: artists, //
                  podcasts: podcasts,
                  albums: albums,
                ),
              ),
            ),
            (route) =>
                false, // Điều kiện này sẽ xóa tất cả các màn hình trước đó
          );
        } else {
          var snackbar = const SnackBar(
            content: Text("Đăng nhập Facebook thất bại"),
            behavior: SnackBarBehavior.floating,
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      }
    } catch (e) {
      var snackbar = SnackBar(
        content: Text("Có lỗi xảy ra: $e"),
        behavior: SnackBarBehavior.floating,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
