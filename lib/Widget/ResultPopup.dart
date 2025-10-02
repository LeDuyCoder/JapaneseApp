import 'package:flutter/material.dart';

class ResultPopup extends StatelessWidget {
  final bool isCorrect;        // true = đúng, false = sai
  final String correctWord;    // Kanji: "旅行"
  final String furigana;       // Furigana: "りょこう"
  final String meaning;
  final Function() onPressButton;// Nghĩa: "Du lịch"

  const ResultPopup({
    super.key,
    required this.isCorrect,
    required this.correctWord,
    required this.furigana,
    required this.meaning,
    required this.onPressButton,
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
                // Icon ✔ / ❌
                // Icon ✔ / ❌ với background tròn
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: mainColor.withOpacity(0.15), // nền nhạt
                  ),
                  child: Icon(
                    icon,
                    color: mainColor,
                    size: 60,
                  ),
                ),

                const SizedBox(height: 10),

                // Text "Chính Xác!" hoặc "Không Chính Xác!"
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
                      furigana,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      correctWord,
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
                    "Nghĩa của từ: $meaning",
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
                        if(isCorrect){
                          onPressButton();
                          Navigator.of(context).pop();
                        }else{
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        isCorrect ? "Tiếp tục" : "Thử lại",
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
