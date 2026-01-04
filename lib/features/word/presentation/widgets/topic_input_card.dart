import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class TopicInputCard extends StatelessWidget {
  final TextEditingController nameTopicEditer;

  const TopicInputCard({super.key, required this.nameTopicEditer});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width,
        height: 160,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withOpacity(0.6),
                blurRadius: 10,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.h_mobiledata,
                    size: 30,
                    color: AppColors.primary,
                  ),
                  Text(
                    "Tên Chủ Đề",
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: nameTopicEditer,
                cursorColor: Colors.black,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Nhập tên chủ đề từ vựng',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Ví dụ: Từ vang tiếng nhật chuyên ngành",
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 15,
                  inherit: true,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
        ));
  }
}
