import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/button/basic_app_button.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/data/models/authen/create_user_req.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/authen/signup.dart';
import 'package:spotify/presentation/authen/pages/choose_artist_screen.dart';
import 'package:spotify/presentation/authen/pages/sign_in.dart';
import 'package:spotify/presentation/bloc/get_artists_cubit.dart';
import 'package:spotify/service_locator.dart';

class SignUp extends StatefulWidget {
  final List<SongEntity> songs;
  final int currentIndex;
  final List<ArtistEntity> artists;
  final List<PodcastEntity> podcasts;
  final List<AlbumEntity> albums;

  const SignUp({
    super.key,
    required this.songs,
    required this.currentIndex,
    required this.artists,
    required this.podcasts,
    required this.albums,
  });
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String _errorMessage = ''; // Thông báo lỗi email
  Color _checkEmailButtonColor =
      Colors.grey; // Màu mặc định cho nút kiểm tra email

  // Hàm kiểm tra email
  void _checkEmail() {
    if (EmailValidator.validate(_email.text)) {
      setState(() {
        _checkEmailButtonColor =
            Colors.green; // Đổi màu thành xanh nếu email hợp lệ
        _errorMessage = ''; // Xóa thông báo lỗi nếu có
      });
    } else {
      setState(() {
        _checkEmailButtonColor = Colors.grey; // Màu xám nếu email không hợp lệ
        _errorMessage =
            'Invalid email format. Please check your input.'; // Thông báo lỗi
      });
    }
  }

  // Định nghĩa một hàm bất đồng bộ để xử lý đăng ký
  Future<void> _signUp() async {
    if (_errorMessage.isEmpty) {
      var result = await sl<SignupUseCase>().call(
        params: CreateUserReq(
          fullName: _fullName.text,
          email: _email.text,
          password: _password.text,
        ),
      );
      result.fold(
        (l) {
          var snackbar = SnackBar(
            content: Text(l),
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        },
        (r) {
          Navigator.pushAndRemoveUntil(
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
            (route) => false,
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signInText(context),
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
            const SizedBox(height: 50),
            _fullNameField(context),
            const SizedBox(height: 20),
            _passwordField(context),
            const SizedBox(height: 20),
            _emailField(context),
            const SizedBox(height: 20),
            BasicAppButton(
              onPressed: _signUp, // Chỉ định hàm bất đồng bộ cho onPressed
              title: "Tạo Tài Khoản",
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Đăng Ký',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField(BuildContext context) {
    return TextField(
      controller: _fullName,
      decoration: const InputDecoration(
        hintText: 'Họ Và Tên',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _emailField(BuildContext context) {
    return Column(
      children: [
        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        TextField(
          controller: _email,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.check, color: _checkEmailButtonColor),
            hintText: 'Nhập Email',
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
          onChanged: (value) {
            _checkEmail(); // Gọi hàm kiểm tra email mỗi khi giá trị thay đổi
          },
        ),
      ],
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      decoration: const InputDecoration(
        hintText: 'Nhập Mật Khẩu',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _signInText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Bạn Chưa Có Tài Khoản?',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SignIn(
                    songs: widget.songs,
                    currentIndex: widget.currentIndex,
                    artists: widget.artists,
                    podcasts: widget.podcasts,
                    albums: widget.albums,
                  ),
                ),
              );
            },
            child: const Text('Đăng Nhập'),
          )
        ],
      ),
    );
  }
}
