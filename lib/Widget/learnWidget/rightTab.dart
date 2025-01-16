import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class rightTab extends StatelessWidget{
  final void Function() nextQuestion;

  const rightTab({super.key, required this.nextQuestion});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(178, 255, 152, 1.0),
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
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 40,),
                SizedBox(width: 10,),
                Text("Your Awnser Is Correct", style: TextStyle(color: Colors.green, fontSize: 30, fontWeight: FontWeight.bold),)
              ],
            ),
            const Text("This time you perfect, continues try hard!", style: TextStyle(color: Colors.green, fontSize: 20),),
            SizedBox(height: 10,),
            Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onTap: (){
                  nextQuestion();
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width - 40,
                  height: 80,
                  decoration: BoxDecoration(
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

            )
          ],
        ),
      )
    );
  }

}