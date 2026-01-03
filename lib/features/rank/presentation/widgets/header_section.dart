/* ================= HEADER ================= */

import 'package:flutter/material.dart';
import 'package:japaneseapp/core/utils/week_utils.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'SEASON ${WeekUtils.getLastWeekString().split("-")[2]}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
          ),
        ),
        SizedBox(height: 6),
        const Text(
          'Mùa giải đã kết thúc',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}