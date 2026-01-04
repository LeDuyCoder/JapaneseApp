import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/ui/snackbar/app_snackbar.dart';
import 'package:japaneseapp/features/word/bloc/word_bloc.dart';
import 'package:japaneseapp/features/word/bloc/word_event.dart';
import 'package:japaneseapp/features/word/bloc/word_state.dart';
import 'package:japaneseapp/features/word/data/data/word_datasource.dart';
import 'package:japaneseapp/features/word/data/repositories/word_repository_impl.dart';
import 'package:japaneseapp/features/word/domain/entities/topic_entity.dart';
import 'package:japaneseapp/features/word/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/word/presentation/cubit/topic_cubit.dart';
import 'package:japaneseapp/features/word/presentation/cubit/topic_cubit_state.dart';
import 'package:japaneseapp/features/word/presentation/widgets/button_import.dart';
import 'package:japaneseapp/features/word/presentation/widgets/form_import_word.dart';
import 'package:japaneseapp/features/word/presentation/widgets/form_input_word.dart';
import 'package:japaneseapp/features/word/presentation/widgets/format_excel_box.dart';
import 'package:japaneseapp/features/word/presentation/widgets/manual_import_tab.dart';
import 'package:japaneseapp/features/word/presentation/widgets/topic_input_card.dart';
import 'package:japaneseapp/features/word/presentation/widgets/word_preview_box.dart';

class WordPage extends StatefulWidget{
  const WordPage({super.key});

  @override
  State<StatefulWidget> createState() => _WordPage();


}

class _WordPage extends State<WordPage> with SingleTickerProviderStateMixin {

  late TabController _controller;

  TextEditingController wordEditer = TextEditingController();
  TextEditingController meanEditer = TextEditingController();
  TextEditingController wayReadEditer = TextEditingController();

  TextEditingController nameTopicEditer = TextEditingController();

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WordBloc(repository: WordRepositoryImpl(datasource: WordDatasource()))),
        BlocProvider(create: (_) => TopicCubit()),
      ],
      child: BlocConsumer<WordBloc, WordState>(
        builder: (context, stateTopic){
          return BlocBuilder<TopicCubit, TopicCubitState>(
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    scrolledUnderElevation: 0,
                    title: const Text(
                      "Thêm Từ Vựng",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      if(stateTopic is LoadingWordState)...[
                        const CircularProgressIndicator(
                          color: AppColors.primary,
                        )
                      ],

                      if(stateTopic is SuccessWordState)...[
                        const Icon(Icons.done, color: AppColors.primary,)
                      ]

                      else...[
                        IconButton(
                          onPressed: () async {
                            if(nameTopicEditer.text.isEmpty){
                              AppSnackBar.show(
                                context,
                                message: 'tên chủ đề không được rỗng',
                                type: AppSnackBarType.error,
                              );
                            }else{
                              if(!await context.read<WordBloc>().isExistTopicName(nameTopicEditer.text)){
                                context.read<WordBloc>().add(CreateTopicEvent(topicEntity: TopicEntity(name: nameTopicEditer.text, words: state.words)));
                              }else{
                                AppSnackBar.show(
                                  context,
                                  message: 'tên chủ đề đã tồn tại',
                                  type: AppSnackBarType.error,
                                );
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.save_as_outlined,
                            color: AppColors.primary,
                            size: 25,
                          ),
                        )
                      ]
                    ],
                  ),
                  body: Container(
                    color: Colors.white,
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  TopicInputCard(nameTopicEditer: nameTopicEditer),
                                  const SizedBox(height: 15),
                                  const Row(
                                    children: [
                                      Icon(Icons.add_circle_outlined,
                                          color: AppColors.primary),
                                      SizedBox(width: 10),
                                      Text(
                                        "Thêm từ vựng",
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ManualImportTab(controller: _controller),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        controller: _controller,
                        children: [
                          /// TAB 1
                          SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                FormInputWord(wordEditer: wordEditer, wayReadEditer: wayReadEditer, meanEditer: meanEditer, onSubmit: () {
                                  String word = wordEditer.text;
                                  String wayRead = wayReadEditer.text;
                                  String mean = meanEditer.text;

                                  if(word.isNotEmpty && wayRead.isNotEmpty && mean.isNotEmpty){
                                    WordEntity wordEntity = WordEntity(word: word, mean: mean, wayread: wayRead);
                                    if(!context.read<TopicCubit>().isWord(wordEntity)){
                                      context.read<TopicCubit>().addWord(wordEntity);
                                      wordEditer.clear();
                                      wayReadEditer.clear();
                                      meanEditer.clear();
                                    }
                                  }
                                }),
                                const SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Danh sách từ vựng", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                    Container(
                                        width: 80,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Center(
                                          child: Text("${state.words.length} từ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                                        )
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Column(
                                  children: [
                                    for(WordEntity word in state.words)...[
                                      WordPreviewBox(
                                        wordEntity: WordEntity(word: word.word, mean: word.mean, wayread: word.wayread),
                                        onDelete: (){
                                          context.read<TopicCubit>().deleteWord(word);
                                        },
                                      ),
                                      const SizedBox(height: 10,)
                                    ]
                                  ],
                                ),
                              ],
                            ),
                          ),

                          /// TAB 2
                          SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                FormImportWord(
                                  onTap: () {
                                    context.read<TopicCubit>().pickExcelFile();
                                  },
                                  file: state.file,
                                ),
                                const SizedBox(height: 20,),
                                const FormatExcelBox(),
                                const SizedBox(height: 20,),
                                ButtonImport(
                                    onTap: () async {
                                      if(state.file != null) {
                                        bool isAddSucess = await context.read<TopicCubit>().addWordFromFile(state.file!);
                                        if(isAddSucess){
                                          AppSnackBar.show(
                                            context,
                                            message: 'Import thành công',
                                            type: AppSnackBarType.success,
                                          );
                                        }else{
                                          AppSnackBar.show(
                                            context,
                                            message: 'Import thất bại, kiểm tra và thử lại',
                                            type: AppSnackBarType.error,
                                          );
                                        }
                                      }else{
                                        AppSnackBar.show(
                                          context,
                                          message: 'Vui lòng chọn file và thử lại',
                                          type: AppSnackBarType.warning,
                                        );
                                      }
                                    }
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              );
            },
          );
        },
        listener: (context, stateTopic){
          if(stateTopic is SuccessWordState){
            Navigator.pop(context);
          }
        },
      ),
    );
  }

}