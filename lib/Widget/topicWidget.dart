import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Screen/listWordScreen.dart';

class topicWidget extends StatefulWidget{
  final String nameTopic;
  final String id;
  final void Function() reloadDashBoard;

  const topicWidget({super.key, required this.nameTopic, required this.reloadDashBoard, required this.id});

  @override
  State<StatefulWidget> createState() => _topicWidget();
}

class _topicWidget extends State<topicWidget>{

  AutoSizeGroup textGroup = AutoSizeGroup();

  Future<List<dynamic>> handledComplited () async {
    double sumComplitted = 0.0;

    DatabaseHelper db = DatabaseHelper.instance;
    List<Map<String, dynamic>> dataWords = await db.getAllWordbyTopic(widget.nameTopic);
    List<Map<String, dynamic>> dataTopic = await db.getAllTopicByName(widget.nameTopic);
    if(dataWords.isNotEmpty) {

      for (Map<String, dynamic> word in dataWords) {
        sumComplitted += (word['level'] * 1.0) ?? 0;
      }
    }

    List<dynamic> dataResult = [dataWords.isNotEmpty ? sumComplitted / (28*dataWords.length) : 0.0, sumComplitted, dataWords.length, dataTopic[0]["user"]];

    return dataResult;
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: handledComplited(), builder: (context, snapshot){
      if(snapshot.hasData){
        return Padding(
            padding: EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) => listWordScreen(
                      id: widget.id,
                      topicName: widget.nameTopic,
                      reloadDashboard: () {
                        widget.reloadDashBoard();
                      },
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                      );

                      return ScaleTransition(
                        scale: scaleAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Container(
                child: Stack(
                  children: [
                    Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 120,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: MediaQuery.sizeOf(context).width*0.01,),
                            Stack(
                              alignment: Alignment.center, // Căn giữa tất cả phần tử trong Stack
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width*0.18,
                                  height: MediaQuery.sizeOf(context).width*0.18,
                                  child: CustomPaint(
                                    painter: _CircularProgressPainter(
                                      progress: snapshot.data![0] ?? 0,
                                      backgroundColor: Colors.grey,
                                      progressColor: Colors.green,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${((snapshot.data![0] ?? 0)*100).toInt()}%",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: "Itim"),
                                ),
                              ],
                            ),
                            SizedBox(width: MediaQuery.sizeOf(context).width*0.02,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width*0.65,
                                  child: AutoSizeText(widget.nameTopic, style: TextStyle(fontFamily: "Itim", fontSize: MediaQuery.sizeOf(context).width*0.045), maxLines: 1,),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Số Lượng Từ: ${snapshot.data![2]}",
                                      style:
                                      TextStyle(fontSize: MediaQuery.sizeOf(context).width*0.04, fontWeight: FontWeight.bold,fontFamily: "Itim"),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 0.65,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: AutoSizeText(
                                          "Hoàn Thành: ${snapshot.data![0].toInt()}",
                                          style: TextStyle(
                                            fontSize: MediaQuery.sizeOf(context).width * 0.035,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                            fontFamily: "Itim",
                                          ),
                                          minFontSize: 8,
                                          maxLines: 1,
                                          wrapWords: false,
                                          group: textGroup, // Đồng bộ kích thước
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: AutoSizeText(
                                          "Chưa Hoàn Thành: ${(snapshot.data![2] - snapshot.data![0]).toInt()}",
                                          style: TextStyle(
                                            fontSize: MediaQuery.sizeOf(context).width * 0.035,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontFamily: "Itim",
                                          ),
                                          minFontSize: 8,
                                          maxLines: 1,
                                          wrapWords: false,
                                          group: textGroup, // Đồng bộ kích thước
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: AutoSizeText(
                                    "Tạo bởi: ${snapshot.data![3]}",
                                    style: TextStyle(
                                      fontSize: MediaQuery.sizeOf(context).width * 0.035,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontFamily: "Itim",
                                    ),
                                    minFontSize: 8,
                                    maxLines: 1,
                                    wrapWords: false,
                                    group: textGroup, // Đồng bộ kích thước
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                    ),
                  ],
                ),
              ),
            )
        );
      }

      return const Center();

    });
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2 - 8;

    // Vẽ đường tròn nền
    canvas.drawCircle(center, radius, backgroundPaint);

    // Vẽ đường tiến trình
    double startAngle = -3.14 / 2;
    double sweepAngle = 2 * 3.14 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}