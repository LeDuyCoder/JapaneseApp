import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:japaneseapp/Screen/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  // Đăng ký công việc chạy mỗi ngày
  Workmanager().registerPeriodicTask(
    "uniqueTaskId",  // ID duy nhất của task
    "simpleTask",
    frequency: Duration(minutes: 15), // WorkManager chỉ hỗ trợ tối thiểu 15 phút
    initialDelay: Duration(seconds: 5), // Delay ban đầu
  );
  runApp(MyApp());
}

// Hàm chạy ngầm kiểm tra điều kiện và gửi thông báo
void callbackDispatcher() {

  Workmanager().executeTask((task, inputData) async {
    bool shouldSendNotification = await checkCondition();
    if (shouldSendNotification) {
      showNotification();
    }
    return Future.value(true);
  });
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Cấu hình thông báo
Future<void> initNotifications() async {
  var androidSettings =
  const AndroidInitializationSettings('@mipmap/icon');
  print(androidSettings.defaultIcon);
  var initSettings = InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

// Gửi thông báo
Future<void> showNotification() async {
  var androidDetails = const AndroidNotificationDetails(
    'channel_id',
    'Scheduled Notification',
    importance: Importance.high,
    priority: Priority.high,
  );

  var notificationDetails = NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
    0,
    '📢 Nhắc Nhở Học Tập!',
    '⏳ Bạn còn **1 giờ** để vào học! 📚 Hãy tiếp tục cố gắng để giữ vững chuỗi thành tích! 💪🔥',
    notificationDetails,
  );
}

// Hàm kiểm tra điều kiện (tùy chỉnh điều kiện của bạn ở đây)
Future<bool> checkCondition() async {
  DateTime date = DateTime.now();
  SharedPreferences data = await SharedPreferences.getInstance();
  String lastChecking = data.getString("lastCheckIn")!;
  String dateCheck = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()}";
  return lastChecking.isNotEmpty && lastChecking != dateCheck; // Thứ 2 đến thứ 6
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //showNotification();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: splashScreen()
    );
  }
}

