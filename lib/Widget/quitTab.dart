import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class quitTab extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20)
            )
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/character/character5.png", width: MediaQuery.sizeOf(context).height*0.2),
              Text("Do you want to quit ?", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),

              SizedBox(height: 20,),
              Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width - 40,
                    height: MediaQuery.sizeOf(context).width*0.15,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(97, 213, 88, 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.green,
                              offset: Offset(6, 6)
                          )
                        ]
                    ),
                    child: Center(
                      child: Text("CONTINUE", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),

              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width - 40,
                  height: MediaQuery.sizeOf(context).width*0.15,
                  color: Colors.white,
                  child: Center(
                    child: Text("QUIT", style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

}