import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class miniGameWidget extends StatefulWidget{

  final String accessImage, title, descrition;
  final bool lock;
  final void Function() executeCommand;
  final String dbTimeName;

  const miniGameWidget({super.key, required this.accessImage, required this.title, required this.descrition, required this.lock, required this.executeCommand, required this.dbTimeName});

  @override
  State<StatefulWidget> createState() => _miniGameWidget();

}

class _miniGameWidget extends State<miniGameWidget>{

  int timeDefaultWait = 300;
  bool isJoin = true;
  Stream<int> timeStream(int startTime) async* {
    int endTime = startTime + timeDefaultWait*1000; // Thời điểm kết thúc (tính bằng giây)

    while (true) {
      int timeLeft = (endTime ~/1000) - (DateTime.now().millisecondsSinceEpoch ~/ 1000);

      if(timeLeft == 1){
        isJoin = true;
      }

      if (timeLeft <= 0) {
        yield 0;
        break;
      }

      yield timeLeft;
      await Future.delayed(const Duration(seconds: 1));
    }
  }



  Future<int> getDataTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int time = prefs.getInt(widget.dbTimeName) ?? 0;
    int timeCheck = ((time + timeDefaultWait*1000 ~/1000) - (DateTime.now().millisecondsSinceEpoch ~/ 1000));
    print(timeCheck);
    if(prefs.containsKey(widget.dbTimeName)){
      if(timeCheck <= 0){
        isJoin = false;
      }
    }
    return time; // Trả về thời gian bắt đầu lưu trữ
  }


  void showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 20,
        right: 20,
        top: 50,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(12),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20,
                      offset: Offset(4, -4)
                  )
                ]
            ),
            child: const Text(
              'Đang Trong Thời Gian Đợi, Không Thể Vào',
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () async {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(!widget.lock) {
          if (isJoin) {
            widget.executeCommand();
            isJoin = false;
          } else {
            showOverlay(context);
          }
        }
      },
      child: FutureBuilder(future: getDataTime(), builder: (ctx, data){
        if(data.hasData){
          return Container(
              width: MediaQuery.sizeOf(context).width * 0.9,
              height: MediaQuery.sizeOf(context).width * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  image: AssetImage(widget.accessImage),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.03, fontFamily: "Itim", color: Colors.white),),
                        Text(widget.descrition, style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.02, fontFamily: "Itim", color: Colors.white),),
                        data.data! == 0 || !data.hasData ? Text(
                          "Trạng Thái: ${widget.lock ? "Chưa Mở" : "Mở"}",
                          style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.02, fontFamily: "Itim", color: Colors.white),
                        ) : StreamBuilder<int>(
                          stream: timeStream(data.data??0), // Nhận dữ liệu từ Stream
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Đang tải...", style: TextStyle(fontSize: MediaQuery.sizeOf(context).height*0.02));
                            }
                            else if (snapshot.hasError) {
                              return Text("Lỗi: ${snapshot.error}");
                            }
                            else {
                              return Text(
                                snapshot.data! <= 0 ? "Trạng Thái: Mở" : "Thời gian đợi: ${snapshot.data} giây",
                                style: TextStyle(fontSize: 20, fontFamily: "Itim", color: Colors.white),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  if(widget.lock)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  if(widget.lock)
                    const Center(
                      child: Icon(Icons.lock_outline_rounded, size: 60, color: Colors.black,),
                    )
                ],
              )
          );
        }

        return Center();
      })
    );
  }

}