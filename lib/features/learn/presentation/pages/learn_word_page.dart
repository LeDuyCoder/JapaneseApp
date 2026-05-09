import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/learn_word_cubit.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/learn_word_state.dart';

import '../widget/swipe_word_card.dart';

class LearnWordPage extends StatefulWidget{
  final String topicName;
  final List<WordEntity> words;

  LearnWordPage({
    super.key,
    required List<Map<String, dynamic>> words, required this.topicName,
  }) : words = words
      .map((e) => WordEntity.fromJson(e))
      .toList();

  @override
  State<StatefulWidget> createState() => _LearnWordPage();

}

class _LearnWordPage extends State<LearnWordPage>{

  Widget buildStatItem({
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(context).width*0.9,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 25),

            const SizedBox(width: 14),

            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget completeCard({
    required int rememberedWords,
    required int reviewWords,
    VoidCallback? onReplay,
    VoidCallback? onReviewUnKnow,
  }) {
    return Container(
      width: MediaQuery.sizeOf(context).width*0.9,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🎉 Hoàn thành! 🎉',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Bạn đã nhớ $rememberedWords từ',
            style: const TextStyle(
              fontSize: 22,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            '$reviewWords từ cần ôn lại',
            style: const TextStyle(
              fontSize: 22,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 62,
            child: OutlinedButton(
              onPressed: onReviewUnKnow,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    color: Colors.black,
                    size: 26,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Ôn tập từ chưa thuộc',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: onReplay,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE63950),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text(
                '🌸  Học lại từ đầu',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),




        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LearnWordCubit(words: widget.words),
      child: BlocBuilder<LearnWordCubit, LearnWordState>(
          builder: (context, state){
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(widget.topicName, style: const TextStyle(fontWeight: FontWeight.bold),),
              ),
              body: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      const Text("👉 Kéo thẻ sang phải (đã nhớ) · Sang trái (chưa nhớ)", style: TextStyle(color: Colors.grey),),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.9,
                        height: 80,
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(180),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildStatItem(
                              value:
                              "${widget.words.length - state.knownWords.length - state.unknownWords.length}",
                              label: "📚 Chưa học",
                            ),
                            buildStatItem(
                              value: "${state.knownWords.length}",
                              label: "✅ Đã nhớ",
                            ),
                            buildStatItem(
                              value: "${state.unknownWords.length}",
                              label: "🔄 Cần ôn",
                            ),
                          ],
                        ),
                      ),


                      if(widget.words.length - state.knownWords.length - state.unknownWords.length <= 0)...[
                        const SizedBox(height: 20,),
                        completeCard(
                            rememberedWords: state.knownWords.length,
                            reviewWords: state.unknownWords.length,
                            onReplay: (){
                              context.read<LearnWordCubit>().replay();
                            },
                            onReviewUnKnow: (){
                              List<Map<String, dynamic>> wordsReview = state.unknownWords.map((word) => word.toJson()).toList();

                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LearnWordPage(words: wordsReview, topicName: widget.topicName)));
                            }
                        )
                      ]
                      else...[
                        const SizedBox(height: 30,),
                        SwipeWordCard(
                          word: widget.words[state.currentIndex].word,
                          hira: widget.words[state.currentIndex].wayread,
                          meaning: widget.words[state.currentIndex].mean,
                          onSwipeLeft: () {
                            context.read<LearnWordCubit>().addUnknownWord(widget.words[state.currentIndex]);
                          },
                          onSwipeRight: () {
                            context.read<LearnWordCubit>().addKnownWord(widget.words[state.currentIndex]);
                          },
                        ),

                        const SizedBox(height: 60,),

                        Column(
                          children: [
                            _buildActionButton(
                              icon: Icons.arrow_back,
                              text: "Lùi lại",
                              onTap: () {
                                context.read<LearnWordCubit>().back();
                              },
                            ),

                            const SizedBox(height: 18),
                          ],
                        )
                      ]


                    ],
                  ),
                )
              ),
            );
          }
      )
    );
  }

}