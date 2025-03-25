import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // Cấu hình cho Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Icon mặc định cho thông báo

    // Cấu hình khởi tạo tổng hợp
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Khởi tạo notification
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Xử lý khi người dùng tương tác với thông báo
        // ignore: avoid_print
        print('Notification clicked: ${details.payload}');
      },
    );
  }

  Future<void> showSignOutNotification(String userName) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Channel_id', // ID của kênh
      'Channel_title', // Tên kênh
      priority: Priority.high,
      importance: Importance.max,
      icon: '@mipmap/ic_launcher',
      channelShowBadge: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await notificationsPlugin.show(
      0, // ID của thông báo
      'Đăng xuất thành công', // Tiêu đề của thông báo
      'Bạn đã đăng xuất khỏi $userName', // Nội dung của thông báo
      notificationDetails,
      payload: 'Sign Out', // Payload nếu cần
    );
  }
}
