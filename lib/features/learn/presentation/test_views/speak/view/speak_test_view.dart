import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/base_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/speak/cubit/speak_test_cubit.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/speak/cubit/speak_test_state.dart';

class SpeakTestView extends StatelessWidget implements BaseTestView{

  final VoidCallback onComplete;
  final BuildContext contextPage;

  final WordEntity wordEntity;

  const SpeakTestView({super.key, required this.onComplete, required this.contextPage, required this.wordEntity});

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.sizeOf(context).width * 0.3;

    return BlocProvider(
      create: (_) => SpeakTestCubit(wordEntity, onTestComplete),
      child: BlocBuilder<SpeakTestCubit, SpeakTestState>(
          builder: (context, state){
            return Container(
              width: MediaQuery.sizeOf(context).width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      color: AppColors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Bạn hãy đọc từ bên dưới", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(state.wordEntity.wayread, style: TextStyle(fontSize: 25),),
                                AutoSizeText(state.wordEntity.word, style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),),
                                const SizedBox(
                                  height: 200,
                                ),

                                if(state.speaking)
                                  Text(
                                    state.timeDisplay,
                                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                  ),
                                SizedBox(height: 10,),
                                Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      context.read<SpeakTestCubit>().speak(context);
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        if (state.speaking)
                                          ...[
                                            Container(
                                              width: size+10,
                                              height: size+10,
                                              child: const CircularProgressIndicator(
                                                color: AppColors.primary,
                                                strokeWidth: 4,
                                              ),
                                            ),
                                          ],

                                        AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 300),
                                          transitionBuilder: (child, anim) =>
                                              ScaleTransition(scale: anim, child: child),
                                          child: Container(
                                            key: ValueKey(state.speaking),
                                            height: size,
                                            width: size,
                                            decoration: state.speaking
                                                ? const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            )
                                                : BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Icon(
                                              state.speaking ? Icons.pause : Icons.mic_rounded,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  @override
  VoidCallback get onTestComplete => onComplete;

}