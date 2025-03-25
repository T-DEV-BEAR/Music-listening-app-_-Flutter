import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsFirebase {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    // ignore: avoid_print
    print('Token: $fCMToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    // Handle background message logic here
    if (message.notification != null) {
      // Handle the notification as required
    }
  }
}
