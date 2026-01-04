import 'package:flutter/material.dart';
import 'package:japaneseapp/core/Theme/colors.dart';

class InputBlock extends StatelessWidget {
  final String title;
  final String hint;
  final String example;
  final TextEditingController controller;

  const InputBlock({
    required this.title,
    required this.hint,
    required this.example,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          example,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
