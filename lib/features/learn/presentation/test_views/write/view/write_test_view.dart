import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/handwriting_input/data/datasource/handwriting_remote_datasource.dart';
import 'package:japaneseapp/features/handwriting_input/data/repository/handwriting_repository_impl.dart';
import 'package:japaneseapp/features/handwriting_input/domain/usecases/delete_text.dart';
import 'package:japaneseapp/features/handwriting_input/domain/usecases/insert_text.dart';
import 'package:japaneseapp/features/handwriting_input/domain/usecases/send_handwriting.dart';
import 'package:japaneseapp/features/handwriting_input/presentation/cubit/handwriting_cubit.dart';
import 'package:japaneseapp/features/handwriting_input/presentation/widget/custom_keyboard.dart';
import 'package:japaneseapp/features/learn/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/base_test_view.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/write/cubit/write_test_cubit.dart';
import 'package:japaneseapp/features/learn/presentation/test_views/write/cubit/write_test_state.dart';

class WriteTestView extends StatelessWidget implements BaseTestView{

  final VoidCallback? onComplete;
  final BuildContext contextPage;

  final WordEntity wordEntity;
  final GlobalKey<CustomKeyboardState> _keyboardKey = GlobalKey();

  WriteTestView({super.key, this.onComplete, required this.contextPage, required this.wordEntity});

  double getResponsiveSize(BuildContext context, String text) {
    double baseSize = MediaQuery.of(context).size.width * 0.2;
    double scaleFactor = 1 / (1 + text.length * 0.05);
    return baseSize * scaleFactor;
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WriteTestCubit(wordEntity),
      child: BlocBuilder<WriteTestCubit, WriteTestState>(
          builder: (context, state){
            return Stack(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Container(
                            width: MediaQuery.sizeOf(context).width,
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: Center(
                                          child: AutoSizeText(
                                            textAlign: TextAlign.center,
                                            state.wordEntity.word,
                                            style: TextStyle(fontSize: getResponsiveSize(context, state.wordEntity.word)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.8,
                                        height: MediaQuery.of(context).size.width * 0.10,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.black, width: 1.0),
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: TextField(
                                            //focusNode: textFieldFocusNode,
                                            onTap: (){
                                              _keyboardKey.currentState?.showKeyboard();
                                            },
                                            readOnly: true,
                                            controller: textEditingController,
                                            decoration: InputDecoration(
                                              icon: Icon(Icons.draw),
                                              border: InputBorder.none,
                                              hintText: AppLocalizations.of(context)!.learn_write_input,
                                              hintStyle: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 50),

                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height-90,
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlocProvider(
                          create: (_) {
                            final remote = HandwritingRemoteDataSource();
                            final repository = HandwritingRepositoryImpl(
                              remote: remote,
                            );

                            return HandwritingCubit(
                              sendHandwritingUsecase: SendHandwriting(repository),
                              insertTextUsecase: InsertText(),
                              deleteTextUsecase: DeleteText(),
                              repository: repository,
                            );
                          },
                          child: CustomKeyboard(key: _keyboardKey, textEditingController: textEditingController,)
                      )
                    ],
                  ),
                )
              ]
            );
          }
      ),
    );
  }

  @override
  VoidCallback? get onTestComplete => onComplete;
}