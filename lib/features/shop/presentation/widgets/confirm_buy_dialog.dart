import 'package:flutter/material.dart';

class ConfirmBuyDialog extends StatelessWidget {
  final String url;
  final Color colorBackground;
  final String? itemName;
  final bool isCircleImage;

  const ConfirmBuyDialog({
    super.key,
    required this.url,
    required this.colorBackground,
    this.itemName, required this.isCircleImage,
  });

  @override
  Widget build(BuildContext context) {
    print(isCircleImage);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(10), // thêm khoảng cách giữa khung và ảnh
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.45,
                colors: [
                  colorBackground.withOpacity(0.01),
                  colorBackground,
                ],
              ),
              borderRadius: BorderRadius.circular(20), // giữ khung bo tròn
            ),
            child: Center(
              child: ClipOval(
                child: Image.network(
                  url,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

            // Title
            const Text(
              "Xác Nhận Mua",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),

            // Message
            Text(
              "Bạn có muốn mua ${itemName ?? 'vật phẩm này'}?",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      "Hủy",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      "Mua",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool?> show(
      BuildContext context, {
        required String url,
        required Color colorBackground,
        required bool isCircleImage,
        String? itemName,
      }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmBuyDialog(
        url: url,
        colorBackground: colorBackground,
        itemName: itemName, isCircleImage: isCircleImage,
      ),
    );
  }
}
