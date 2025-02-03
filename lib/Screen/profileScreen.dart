import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profileScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _profileScreen();
}

class _profileScreen extends State<profileScreen>{

  Future<Map<String, dynamic>> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      "level": prefs.getInt("level"),
      "exp": prefs.getInt("exp"),
      "nextExp": prefs.getInt("nextExp")
    };
  }

  String getTitle(int level){
    if(level < 10){
      return "Học Sĩ";
    }else if(level < 20){
      return "Minh Triết Giả";
    }else if(level < 30){
      return "Tư Tưởng Gia";
    }else if(level < 40){
      return "Bác Học Tôn Giả";
    }else if(level < 50){
      return "Hàn Lâm Học Sĩ";
    }else if(level < 60){
      return "Kỳ Tài Văn Học";
    }else if(level < 70){
      return "Trí Thánh Nhân";
    }else if(level < 80){
      return "Thiên Tài Biện Luận";
    }else if(level < 90){
      return "Học Đạo Tinh Thông";
    }else if(level < 100){
      return "Chí Sĩ Văn Nhân";
    }else if(level < 110){
      return "Luyện Tư Học Sĩ";
    }else if(level < 120){
      return "Thông Tuệ Giả";
    }else if(level < 130){
      return "Hiền Triết Uyên Thâm";
    }else if(level < 150){
      return "Văn Nhã Chân Nhân";
    }else{
      return "Trí Nhân Kỳ Tài";
    }
  }

  String getImage(int level){
    if(level < 10){
      return "assets/StateLevel/state1.png";
    }else if(level < 20){
      return "assets/StateLevel/state2.png";
    }else if(level < 30){
      return "assets/StateLevel/state3.png";
    }else if(level < 40){
      return "assets/StateLevel/state4.png";
    }else if(level < 50){
      return "assets/StateLevel/state5.png";
    }else if(level < 60){
      return "assets/StateLevel/state6.png";
    }else if(level < 70){
      return "assets/StateLevel/state7.png";
    }else if(level < 80){
      return "assets/StateLevel/state8.png";
    }else if(level < 90){
      return "assets/StateLevel/state9.png";
    }else if(level < 100){
      return "assets/StateLevel/state10.png";
    }else if(level < 110){
      return "assets/StateLevel/state11.png";
    }else if(level < 120){
      return "assets/StateLevel/state12.png";
    }else if(level < 130){
      return "assets/StateLevel/state13.png";
    }else if(level < 150){
      return "assets/StateLevel/state14.png";
    }else{
      return "assets/StateLevel/state15.png";
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: getData(), builder: (ctx, snapshot){
        if(snapshot.hasData){
          return Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 80,),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Container VIỀN (background)
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      height: MediaQuery.sizeOf(context).width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(width: 10, color: Colors.transparent),
                        image: const DecorationImage(
                          image: AssetImage('assets/textureBoder/textureStone.png'),
                          repeat: ImageRepeat.repeat, // Lặp texture
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 20,
                            offset: Offset(4, 4),
                          ),
                        ],
                      ),
                    ),
                    // Container NỘI DUNG (che phủ)
                    Container(
                        width: MediaQuery.sizeOf(context).width * 0.57,
                        height: MediaQuery.sizeOf(context).width * 0.77,
                        decoration: const BoxDecoration(
                          color: Colors.white, // Màu nền bên trong
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: Image.asset(getImage(snapshot.data!["level"]), width: MediaQuery.sizeOf(context).width*0.45,),
                        )
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Text("Bậc Tri Thức: ${snapshot.data!["level"]}", style: TextStyle(fontFamily: "Itim", fontSize: 35),),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  child: Text("Kiến Thức: ${snapshot.data!["exp"]}/${snapshot.data!["nextExp"]}", style: TextStyle(fontFamily: "Itim", fontSize: 25), maxLines: 2, textAlign: TextAlign.center,),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  child: Text("Danh Hiệu: ${getTitle(snapshot.data!["level"])}", style: TextStyle(fontFamily: "Itim", fontSize: 25), maxLines: 2, textAlign: TextAlign.center,),
                )
              ],
            ),
          );
        }

        return Center();
      })
    );
  }

}