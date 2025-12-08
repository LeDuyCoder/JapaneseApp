import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class BoxFailWidget extends StatelessWidget{
  const BoxFailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: AppColors.grey,
                offset: Offset(0, 2),
                blurRadius: 10
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.error_outlined, color: AppColors.primary, size: 50,),
          const Text("Không Tìm Thấy", style: TextStyle(fontSize: 20, fontFamily: "Itim"),),
          Text("Từ bạn vừa nhập không tìm thấy trong từ điển", style: TextStyle(fontFamily: "itim", color: AppColors.textSecond.withOpacity(0.5)),)
        ],
      ),
    );
  }

}