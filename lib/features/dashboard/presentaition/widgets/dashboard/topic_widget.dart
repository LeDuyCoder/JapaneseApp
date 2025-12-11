import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Screen/listWordScreen.dart';
import 'package:japaneseapp/core/Service/Local/local_db_service.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/topicdetail/presentation/pages/topicdetail_page.dart';

class TopicWidget extends StatefulWidget{
  final String nameTopic;
  final String id;
  final String owner;
  final void Function() reloadDashBoard;

  const TopicWidget({super.key, required this.nameTopic, required this.reloadDashBoard, required this.id, required this.owner});

  @override
  State<StatefulWidget> createState() => _topicWidget();
}

class _topicWidget extends State<TopicWidget>{

  AutoSizeGroup textGroup = AutoSizeGroup();

  Future<List<dynamic>> handledComplited () async {
    double sumComplitted = 0.0;
    double progressComplited = 0.0;

    final db = LocalDbService.instance;
    List<Map<String, dynamic>> dataWords = await db.topicDao.getAllWordbyTopic(widget.nameTopic);
    List<Map<String, dynamic>> dataTopic = await db.topicDao.getAllTopicByName(widget.nameTopic);
    if(dataWords.isNotEmpty) {
      for (Map<String, dynamic> word in dataWords) {
        sumComplitted += (word['level'] * 1.0) >= 27 ? 1 : 0;
        progressComplited += (word['level'] * 1.0) ?? 0;
      }
    }

    List<dynamic> dataResult = [
      dataWords.isNotEmpty ? progressComplited / (28*dataWords.length) : 0.0,
      sumComplitted,
      dataWords.length,
      dataTopic[0]["user"]
    ];

    return dataResult;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: handledComplited(), builder: (context, snapshot){
      if(snapshot.hasData){
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) => TopicDetailPage(
                    nameTopic: widget.nameTopic, idTopic: widget.id, owner: widget.owner,
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
              widget.reloadDashBoard();
            },
            child: Container(
              child: Stack(
                children: [
                  Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 120,
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 10,
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.nameTopic, style: TextStyle(fontSize: 20, color: AppColors.textPrimary),),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                                height: 30,
                                decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                ),
                                child: Center(
                                  child: Text("${snapshot.data?[2]} ${AppLocalizations.of(context)!.listword_Screen_AmountWord}", style: TextStyle(color: Colors.white),),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          const Divider(
                              color: Colors.grey,
                              height: 2
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(AppLocalizations.of(context)!.topic_persent),
                                  Text("${(snapshot.data?[0] as double).toStringAsFixed(2)}%"),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(AppLocalizations.of(context)!.topic_word_finish,  style: TextStyle(color: AppColors.textSucessState)),
                                  Text("${(snapshot.data?[1]??0).toInt()}", style: TextStyle(color: AppColors.textSucessState)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(AppLocalizations.of(context)!.topic_word_learning, style: TextStyle(color: AppColors.primary),),
                                  Text("${(snapshot.data?[2] - snapshot.data?[1] ?? 0).toInt()}", style: TextStyle(color: AppColors.primary)),
                                ],
                              )
                            ],
                          )
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
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