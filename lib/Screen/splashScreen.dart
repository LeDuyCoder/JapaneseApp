import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Screen/dashboardScreen.dart';

class splashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _splashScreen();

}

class _splashScreen extends State<splashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    // Tạo AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Tạo hiệu ứng chuyển động từ trên xuống
    _animation = Tween<Offset>(
      begin: Offset(0, -0.5), // Bắt đầu từ ngoài màn hình (trên cùng)
      end: Offset(0, 0),   // Kết thúc ở vị trí ban đầu
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Đường cong hiệu ứng
    ));

    // Bắt đầu hoạt ảnh
    _controller.forward();
    _initializeDatabase();

  }

  Future<void> _initializeDatabase() async {
    // Khởi tạo cơ sở dữ liệu và gọi await để chờ cơ sở dữ liệu được tạo
    final db = await DatabaseHelper.instance.database;
    print("Database initialized successfully.");
    Navigator.push(context, MaterialPageRoute(builder: (context) => dashboardScreen()));

  }

  @override
  void dispose() {
    _controller.dispose(); // Giải phóng bộ nhớ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Japanese App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          body: Container(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _animation,
                  child: Image.asset(
                    "assets/logo.png",
                    scale: 0.8,
                  ),
                ),
                const SizedBox(height: 10,),
                const Text("日本語", style: TextStyle(fontFamily: "aboshione", fontSize: 50),),
                const Text("Application", style: TextStyle(fontFamily: "islandmoment", fontSize: 50),)
              ],
            ),
          ),
        )
    );
  }

}