import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:japaneseapp/Config/dataHelper.dart';
import 'package:japaneseapp/Theme/colors.dart';

class WordbookScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _WordbookScreen();
}

class _WordbookScreen extends State<WordbookScreen>{

  Widget VocabularyCard({
    required String word,        // từ vựng (Kanji)
    required String reading,     // cách đọc (Kana hoặc Romaji)
    required String meaning,     // nghĩa tiếng Việt
    required String exampleJp,   // ví dụ tiếng Nhật
    required String exampleVi,   // dịch tiếng Việt
  }) {
    return Container(
      width: MediaQuery.sizeOf(context).width / 1.1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Từ vựng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                word,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary
                ),
              ),
              IconButton(onPressed: () async {
                DatabaseHelper db = DatabaseHelper.instance;
                db.removeVocabulary(await db.database, wordJp: word, wordKana: reading);
                setState(() {

                });
              }, icon: Icon(Icons.delete_outline, color: AppColors.primary,))
            ],
          ),
          const SizedBox(height: 6),
          Text(
            reading,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            meaning,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          if(exampleJp.isNotEmpty)
            Container(
              width: MediaQuery.sizeOf(context).width/1.1,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                exampleJp,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
          if(exampleVi.isNotEmpty)
            ...[
              const SizedBox(height: 6),
              Text(
                exampleVi,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ]
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> loadData() async {
    DatabaseHelper db = DatabaseHelper.instance;
    return db.getAllVocabulary(await db.database);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Sổ Từ Vựng", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 25),),
        backgroundColor: AppColors.backgroundPrimary,
        scrolledUnderElevation: 0,
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(
          color: AppColors.backgroundPrimary
        ),
        child: FutureBuilder(future: loadData(), builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width / 1.1,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 70,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Container(
                        width: 140,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }

          if(snapshot.hasData){
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  if(snapshot.data!.isEmpty)
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(24),
                      width: MediaQuery.sizeOf(context).width/1.1,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 50,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Chưa có từ vựng nào",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Hãy lưu lại những từ bạn muốn học ở đây",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  for(Map<String, dynamic> data in snapshot.data!)
                    VocabularyCard(
                        word: data["word_jp"],
                        reading: data["word_kana"],
                        meaning: data["word_mean"],
                        exampleJp: data["example_jp"] ?? "",
                        exampleVi: data["example_vi"] ?? ""
                    ),
                ],
              ),
            );
          }

          return Container();
        })
      ),
    );
  }

}

