import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class ButtonImport extends StatelessWidget{
  final Function() onTap;

  const ButtonImport({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: 60,
        decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.red.withOpacity(0.5),
                  blurRadius: 20
              )
            ]
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.file_download_outlined, color: Colors.white,),
            SizedBox(width: 10,),
            Text("Import từ vựng", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
  
}