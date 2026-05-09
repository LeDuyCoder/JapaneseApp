import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoxFeatureWidget extends StatelessWidget{
  final double width;
  final double height;
  final String imagePath;
  final String title;
  final Function() onTap;

  const BoxFeatureWidget(
      {
        super.key,
        this.width = 0.0,
        this.height = 0.0,
        required this.imagePath,
        required this.title,
        required this.onTap
      }
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 20,
                  spreadRadius: 5
              )
            ]
        ),
        child: Column(
          children: [
            Image.asset(imagePath),
            Text(title, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),)
          ],
        ),
      ),
    );
  }

}