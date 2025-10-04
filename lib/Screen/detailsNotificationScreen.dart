import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Theme/colors.dart';

class detailsNotificationScreen extends StatefulWidget{
  final String title;
  final String description;

  const detailsNotificationScreen({super.key, required this.title, required this.description});

  @override
  State<StatefulWidget> createState() => _detailsNotificationScreene();

}

class _detailsNotificationScreene extends State<detailsNotificationScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.backgroundPrimary,
        scrolledUnderElevation: 0,
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        color: AppColors.backgroundPrimary,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey,
                      blurRadius: 10,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Text(
                  widget.description.replaceAll("\\n", "\n"),
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        )
      ),
    );
  }

}