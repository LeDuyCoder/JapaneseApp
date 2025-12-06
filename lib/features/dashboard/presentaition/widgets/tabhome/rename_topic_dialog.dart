import 'package:flutter/material.dart';

class RenameTopicDialog {
  static Future<String?> show(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    String? errorText;

    return await showGeneralDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOut.transform(animation.value);

        return Transform.translate(
          offset: Offset(0, -300 + (300 * curvedValue)),
          child: Opacity(
            opacity: animation.value,
            child: Center(
              child: Dialog(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color.fromRGBO(195, 20, 20, 1.0),
                            width: 10,
                          ),
                        ),
                      ),
                      child: SizedBox(
                        height: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/character/character6.png",
                              width: MediaQuery.of(context).size.width * 0.3,
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              "Tên Topic Đã Tồn Tại Vui Lòng Đổi Tên",
                              style: TextStyle(
                                  fontFamily: "indieflower", fontSize: 15),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  hintText: "Tên topic mới",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorText: errorText,
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () async {
                                final newName = controller.text.trim();

                                if (newName.isEmpty) {
                                  setState(() {
                                    errorText = "Tên không được để trống";
                                  });
                                  return;
                                }

                                // 🚩 Nếu có service DB bạn thêm vào đây:
                                // final exists = await LocalDbService.instance.topicDao.hasTopicName(newName)

                                setState(() {
                                  errorText = null;
                                });

                                Navigator.pop(context, newName);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Đổi Tên",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
