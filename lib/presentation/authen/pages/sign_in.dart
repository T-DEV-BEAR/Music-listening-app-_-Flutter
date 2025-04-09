import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/button/basic_app_button.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/data/models/authen/signin_user_req.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/authen/sigin.dart';
import 'package:spotify/presentation/authen/pages/choose_artist_screen.dart';
import 'package:spotify/presentation/authen/pages/sign_up.dart';
import 'package:spotify/presentation/bloc/get_artists_cubit.dart';
import 'package:spotify/service_locator.dart';

class SignIn extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const SignIn({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String _errorMessage = '';
  Color _checkEmailButtonColor = Colors.grey;

  void _checkEmail() {
    if (EmailValidator.validate(_email.text)) {
      setState(() {
        _checkEmailButtonColor = Colors.green;
        _errorMessage = '';
      });
    } else {
      setState(() {
        _checkEmailButtonColor = Colors.grey;
        _errorMessage =
            'Định dạng email không hợp lệ. Vui lòng kiểm tra đầu vào của bạn.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signUpText(context),
      appBar: BasicAppbar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _registerText(),
            const SizedBox(height: 20),
            _emailField(context),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0), // Sửa từ "custom" thành "top"
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            _passwordField(context),
            const SizedBox(height: 20),
            BasicAppButton(
              key: const Key('sign_in_button'), // Thêm Key vào đây
              onPressed: () async {
  print('🚀 Bắt đầu đăng nhập');
  var result = await sl<SigninUseCase>().call(
    params: SigninUserReq(
      email: _email.text,
      password: _password.text,
    ),
  );
  result.fold(
    (l) {
      print('❌ Đăng nhập thất bại: $l');
      var snackbar = SnackBar(
        content: Text(l),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    },
    (r) {
      print('✅ Đăng nhập thành công → chuyển đến ChooseArtistScreen');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) {
              var cubit = GetArtistCubit();
              cubit.getArtists();
              return cubit;
            },
            child: ChooseArtistScreen(
              songs: widget.songs,
              currentIndex: widget.currentIndex,
              artists: widget.artists,
              podcasts: widget.podcasts,
              albums: widget.albums,
            ),
          ),
        ),
      );
    },
  );
},
              title: "Đăng Nhập",
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Đăng Nhập',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      textAlign: TextAlign.center,
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: InputDecoration(
        hintText: 'Nhập Email',
        suffixIcon: Icon(Icons.check, color: _checkEmailButtonColor),
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
      onChanged: (value) {
        _checkEmail();
      },
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      decoration: const InputDecoration(
        hintText: 'Mật Khẩu',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _signUpText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Chưa Là Thành Viên?',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SignUp(
                    songs: widget.songs,
                    currentIndex: widget.currentIndex,
                    artists: widget.artists,
                    podcasts: widget.podcasts,
                    albums: widget.albums,
                  ),
                ),
              );
            },
            child: const Text('Hãy Đăng Ký Ngay!'),
          ),
        ],
      ),
    );
  }
}