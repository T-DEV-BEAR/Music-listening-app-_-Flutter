import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Thêm dòng này
import 'package:spotify/service_locator.dart';

// Giả sử đây là entry point của app
import 'package:spotify/presentation/authen/pages/choose_artist_screen.dart';
import 'package:spotify/presentation/authen/pages/sign_in.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/entities/artist/artist.dart';
import 'package:spotify/domain/entities/podcast/podcast.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/presentation/authen/pages/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spotify/firebase_options.dart'; // nếu bạn dùng FlutterFire CLI

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // nếu có FirebaseOptions
  );
  // 🛠️ Fix chính nằm ở đây
  setUpAll(() async {
    await initializeDependencies(); // Đảm bảo GetIt được setup trước khi chạy test
  });




  group('Sign In Integration Tests', () {
    final List<SongEntity> testSongs = [];
    final List<ArtistEntity> testArtists = [];
    final List<PodcastEntity> testPodcasts = [];
    final List<AlbumEntity> testAlbums = [];
    const int testIndex = 0;

    Future<void> pumpSignInScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SignIn(
            songs: testSongs,
            currentIndex: testIndex,
            artists: testArtists,
            podcasts: testPodcasts,
            albums: testAlbums,
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Successful sign in flow', (WidgetTester tester) async {
      await pumpSignInScreen(tester);

      final emailField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;
      final signInButton = find.byKey(const Key('sign_in_button'));

      await tester.enterText(emailField, 'khuong@gmail.con');
      await tester.enterText(passwordField, '123456');
      await tester.pump();

      expect(
        tester.widget<Icon>(find.byIcon(Icons.check)).color,
        Colors.green,
      );

      await tester.tap(signInButton);
      await tester.pump(const Duration(milliseconds: 500));
      await waitFor(tester, find.byType(ChooseArtistScreen));

      expect(find.byType(ChooseArtistScreen), findsOneWidget);
    });

    testWidgets('Invalid email format shows error', (WidgetTester tester) async {
      await pumpSignInScreen(tester);

      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'invalid-email');
      await tester.pumpAndSettle();

      expect(
        find.text('Định dạng email không hợp lệ. Vui lòng kiểm tra đầu vào của bạn.'),
        findsOneWidget,
      );

      expect(
        tester.widget<Icon>(find.byIcon(Icons.check)).color,
        Colors.grey,
      );
    });

    testWidgets('Empty fields handling', (WidgetTester tester) async {
      await pumpSignInScreen(tester);
      final signInButton = find.byKey(const Key('sign_in_button'));
      await tester.tap(signInButton);
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Navigate to Sign Up screen', (WidgetTester tester) async {
      await pumpSignInScreen(tester);
      final signUpButton = find.text('Hãy Đăng Ký Ngay!');
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(find.byType(SignUp), findsOneWidget);
    });
  });
}

Future<void> waitFor(WidgetTester tester, Finder finder) async {
  const maxAttempts = 10;
  var attempts = 0;
  while (attempts < maxAttempts) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 500));
    attempts++;
  }
  throw Exception('Widget not found after $maxAttempts attempts');
}
