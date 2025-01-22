import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class wrongTab extends StatelessWidget{
  final void Function() nextQuestion;
  final String rightAwnser;

  const wrongTab({super.key, required this.nextQuestion, required this.rightAwnser});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: Colors.red[100],

            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20)
            )
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.cancel, color: Colors.red, size: 40,),
                  SizedBox(width: 10,),
                  Text("Your Awnser Is Incorrect", style: TextStyle(color: Colors.red, fontSize: 25, fontWeight: FontWeight.bold),)
                ],
              ),
              Row(
                children: [
                  Text("Awnser right is: ", style: TextStyle(color: Colors.red, fontSize: 20),),
                  Text(rightAwnser, style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: (){
                    nextQuestion();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width - 40,
                    height: MediaQuery.sizeOf(context).width*0.15,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 103, 103, 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.red,
                              offset: Offset(6, 6)
                          )
                        ]
                    ),
                    child: Center(
                      child: Text("CONTINUE", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

}