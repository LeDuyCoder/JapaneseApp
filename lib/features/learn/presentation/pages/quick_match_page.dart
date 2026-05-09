import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/presentation/cubit/quick_match_cubit.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/widget/card_widget.dart';

import '../cubit/quick_match_state.dart';

class QuickMatchPage extends StatefulWidget{
  final String topicId;
  final List<WordEntity> words;

  QuickMatchPage({
    super.key,
    required List<Map<String, dynamic>> words, required this.topicId,
  }) : words = words
      .map((e) => WordEntity.fromJson(e))
      .toList();

  @override
  State<StatefulWidget> createState() => _QuickMatchPage();

}

class _QuickMatchPage extends State<QuickMatchPage>{

  Widget _infoItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        )
      ],
    );
  }

  Widget _timeItem(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuickMatchCubit(words: widget.words)..generateCards(widget.topicId),
      child: BlocBuilder<QuickMatchCubit, QuickMatchState>(
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              title: const Text("Ghép Thẻ", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoItem(
                            value: '${state.listCompletes.length}',
                            label: 'Đã ghép',
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                          _infoItem(
                            value: '5',
                            label: 'Tổng cặp',
                            icon: Icons.bar_chart,
                            color: Colors.blue,
                          ),
                          _timeItem(formatTime(state.timeElapsed))
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    state.listCompletes.length >= 5
                      ? Expanded(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: MediaQuery.sizeOf(context).height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.timer_outlined, size: 18, color: Colors.blueAccent),
                                        SizedBox(width: 6),
                                        Text(
                                          'KỶ LỤC THỜI GIAN',
                                          style: TextStyle(
                                            fontSize: 12,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      ( state.timeElapsed < state.record || state.record == 0 ) ? formatTime(state.timeElapsed) : formatTime(state.record),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.flash_on, size: 16, color: Colors.blueAccent),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Lần này: ${formatTime(state.timeElapsed)}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.emoji_events_outlined,
                                              color: Colors.orange, size: 18),
                                          const SizedBox(width: 6),
                                          Text(
                                            ( state.timeElapsed < state.record || state.record == 0 ) ? "NEW RECORD" : 'Phản xạ cực nhanh!',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Text("Nhấn để quay về", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade400, fontSize: 25),)
                              ],
                            )
                          ),
                        )
                      ) : Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child:GridView.builder(
                        itemCount: state.listCards.length,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final card = state.listCards[index];

                          if(state.listCompletes.contains(card.wordEntity)){
                            return Container();
                          }

                          return GestureDetector(
                            onTap: () {
                              if(state.cardChosen == null){
                                context.read<QuickMatchCubit>().choseCard(card);
                              }else{
                                if(state.cardChosen == card){
                                  context.read<QuickMatchCubit>().unChoseCard();
                                }else{
                                  if(state.cardChosen!.wordEntity == card.wordEntity){
                                    context.read<QuickMatchCubit>().complete(widget.topicId, card.wordEntity);
                                  }else{
                                    context.read<QuickMatchCubit>().wrong(card);
                                  }
                                }
                              }
                            },
                            child: CardWidget(
                              key: ValueKey(card.text),
                              cardEntity: card,
                              isWrong: state.cardWrong == card,
                              isChosen: state.cardChosen == card,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            )
          );
        },
      ),
    );
  }

}