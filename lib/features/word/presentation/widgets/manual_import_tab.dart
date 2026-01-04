import 'package:flutter/material.dart';

class ManualImportTab extends StatefulWidget {
  final TabController controller;

  const ManualImportTab({super.key, required this.controller});

  @override
  State<ManualImportTab> createState() => _ManualImportTabState();
}

class _ManualImportTabState extends State<ManualImportTab>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          TabBar(
            controller: widget.controller,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: const Color(0xFFE52421),
              borderRadius: BorderRadius.circular(12),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              SizedBox(
                width: width / 2.3,
                height: 44,
                child: const Tab(
                  icon: Icon(Icons.edit, size: 18),
                  text: 'Thủ công',
                ),
              ),
              SizedBox(
                width: width / 2.3,
                height: 44,
                child: const Tab(
                  icon: Icon(Icons.upload_file, size: 18),
                  text: 'Import Excel',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
