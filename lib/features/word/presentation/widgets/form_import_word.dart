import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class FormImportWord extends StatefulWidget{
  final Function() onTap;
  final PlatformFile? file;

  const FormImportWord({super.key, required this.onTap, this.file});

  @override
  State<StatefulWidget> createState() => _FormImportWord();

}

class _FormImportWord extends State<FormImportWord>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 380,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20,),
          const Icon(Icons.file_open, color: AppColors.primary, size: 55,),
          const SizedBox(height: 10,),
          const Text("Import từ fule Excel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
          const SizedBox(height: 10),
          const Text("Tải lên file Excel (.xlsx, .xls) chứa danh sách từ vựng của bạn. Hệ thống sẽ tự động nhận diện và import các từ vựng.", style: TextStyle(color: Colors.grey, fontSize: 15), textAlign: TextAlign.center,),
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: 200,
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
                  Icon(Icons.file_upload_outlined, color: Colors.white,),
                  SizedBox(width: 10,),
                  Text("Chọn file Excel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                ],
              ),
            ),
          ),
          const SizedBox(height: 40,),
          Text(widget.file == null ? "Chưa chọn file nào" : "Đã chọn: ${widget.file?.name ?? "N/A"}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),),
        ],
      ),
    );
  }

}