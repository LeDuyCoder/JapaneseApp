import 'package:flutter/material.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';

class ResultPopupWidget extends StatelessWidget {
  final bool isCorrect;
  final bool tryAgain;
  final WordEntity? wordEntityWrong;
  final WordEntity wordEntity;
  final Function() onPressButton;

  const ResultPopupWidget({
    super.key,
    required this.isCorrect,
    required this.wordEntity,
    required this.onPressButton,
    required this.tryAgain, 
    this.wordEntityWrong,
  });

  @override
  Widget build(BuildContext context) {
    final Color mainColor = isCorrect ? Colors.green : Colors.red;
    final IconData icon = isCorrect ? Icons.done : Icons.close;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: !isCorrect ?
                    Image.asset("assets/character/hinh6.png", width: 150, height: 150,) :
                    Image.asset("assets/character/hinh10.png", width: 200, height: 200)
                ),

                const SizedBox(height: 10),
                Text(
                  isCorrect ? "Chính Xác!" : "Không Chính Xác!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 5),

                if (!isCorrect)
                  const Text(
                    "Câu trả lời đúng là",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                const SizedBox(height: 15),

                // Furigana + Kanji
                Column(
                  children: [
                    Text(
                      (wordEntity.wayread)??"",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      wordEntity.word,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Nghĩa của từ
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Nghĩa của từ: ${wordEntity.mean}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 20),

                // Nút Tiếp Theo
                GestureDetector(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                        onPressButton();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        isCorrect ? "Tiếp tục" : tryAgain ? "Thử lại" : "Tiếp Theo",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
            if(isCorrect)
              Image.asset("assets/animation/6k2.gif"),
          ],
        )
      ),
    );
  }
}
