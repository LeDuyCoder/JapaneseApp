import 'package:flutter/material.dart';
import 'package:japaneseapp/features/local_topic/presentation/widgets/page_button.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPage;
  final Function(int page) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPage,
    required this.onPageChanged,
  });

  List<dynamic> buildPagination({
    required int currentPage,
    required int totalPage,
  }) {
    final List<dynamic> pages = [];

    if (totalPage <= 5) {
      for (int i = 1; i <= totalPage; i++) {
        pages.add(i);
      }
      return pages;
    }

    /// Case: page 1, 2, 3
    if (currentPage <= 3) {
      pages.addAll([1, 2, 3, '...', totalPage]);
      return pages;
    }

    /// Case: page cuối (total, total-1, total-2)
    if (currentPage >= totalPage - 1) {
      pages.addAll([
        1,
        2,
        3,
        '...',
        totalPage - 1,
        totalPage,
      ]);
      return pages;
    }

    /// Case: page giữa
    pages.addAll([
      1,
      2,
      3,
      '...',
      currentPage,
      '...',
      totalPage,
    ]);

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final pages = buildPagination(
      currentPage: currentPage,
      totalPage: totalPage,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pages.map((item) {
        if (item == '...') {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              "...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        final page = item as int;
        return PageButton(
          text: page.toString(),
          isSelected: page == currentPage,
          onTap: () => onPageChanged(page),
        );
      }).toList(),
    );
  }
}
