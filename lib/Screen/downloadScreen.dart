import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Theme/colors.dart';

class DownloadScreen extends StatefulWidget {
  final String nameTopic;
  final Future<bool> Function() downloadTopic;

  const DownloadScreen({
    super.key,
    required this.nameTopic,
    required this.downloadTopic,
  });

  @override
  State<StatefulWidget> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  String state = "downloading";

  @override
  void initState() {
    super.initState();
    progressDownload(); // gọi ngay khi mở màn hình
  }

  Future<void> progressDownload() async {
    await Future.delayed(const Duration(seconds: 2));

    bool download = await widget.downloadTopic();

    // delay 5 giây
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        if(download){
          state = "done";
        }
      });
    }
  }

  Widget downloadWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 3.0,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
              Icon(
                Icons.cloud_download_rounded,
                size: 60,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Đang Tải Chủ Đề",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          "Vui lòng chờ trong giây lát...",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.textSecond.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.primary.withOpacity(0.3),
              ),
              child: Center(
                child: Text(
                 widget.nameTopic,
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.primary),
              ),
              child: const Center(
                child: Text(
                  "Hủy",
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget downloadSuccesedWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 3.0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const Icon(
                Icons.done,
                size: 60,
                color: Colors.green,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Tải thành công!",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          "Chủ đề đã sẵn sàng để học",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.textSecond.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.primary.withOpacity(0.2),
              ),
              child: Center(
                child: Text(
                  widget.nameTopic,
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.primary,
                ),
                child: const Center(
                  child: Text(
                    "Bắt đầu học",
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child:
        state == "downloading" ? downloadWidget() : downloadSuccesedWidget(),
      ),
    );
  }
}
