import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/features/word/presentation/widgets/input_block.dart';

import '../../../../core/Theme/colors.dart';

class FormInputWord extends StatelessWidget{
  final TextEditingController wordEditer;
  final TextEditingController meanEditer;
  final TextEditingController wayReadEditer;
  final Function() onSubmit;

  const FormInputWord({super.key, required this.wordEditer, required this.meanEditer, required this.wayReadEditer, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: InputBlock(
                  title: 'Từ vựng *',
                  hint: 'Nhập từ vựng',
                  example: 'Ví dụ: algorithm',
                  controller: wordEditer,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: InputBlock(
                  title: 'Nghĩa *',
                  hint: 'Nhập nghĩa',
                  example: 'Ví dụ: thuật toán',
                  controller: meanEditer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InputBlock(
                  title: 'Phát âm',
                  hint: 'Nhập phát âm',
                  example: 'Ví dụ: /ˈæl.ɡə.rɪ.ðəm/',
                  controller: wayReadEditer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          /// BUTTON
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.add, size: 22),
              label: const Text(
                'Thêm vào danh sách',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE52421),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

}