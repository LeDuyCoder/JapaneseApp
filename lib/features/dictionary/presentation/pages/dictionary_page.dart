import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/core/generated/app_localizations.dart';
import 'package:japaneseapp/features/bookmark/presentation/pages/bookmark_page.dart';
import 'package:japaneseapp/features/dictionary/bloc/dictionary_bloc.dart';
import 'package:japaneseapp/features/dictionary/bloc/dictionary_event.dart';
import 'package:japaneseapp/features/dictionary/bloc/dictionary_state.dart';
import 'package:japaneseapp/features/dictionary/domain/entities/word_entity.dart';
import 'package:japaneseapp/features/dictionary/presentation/widgets/box_fail_widget.dart';
import 'package:japaneseapp/features/dictionary/presentation/widgets/box_loading_widget.dart';
import 'package:japaneseapp/features/dictionary/presentation/widgets/word_same_widget.dart';

class DictionaryPage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WordEntity currentWordEntity;

    return BlocConsumer<DictionaryBloc, DictionaryState>(
      listener: (context, state) {
        if(state is DictionaryLoaded){
          currentWordEntity = state.word;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.distionary_Screen_title, style: TextStyle(color: AppColors.primary, fontFamily: "Itim", fontSize: 30),),
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.backgroundPrimary,
          ),
          body: Container(
            width: MediaQuery.sizeOf(context).width,
            color: AppColors.backgroundPrimary,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          width: MediaQuery.sizeOf(context).width,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0), // pill shape
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26, // shadow mờ hơn
                                offset: Offset(0, 2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              border: InputBorder.none, // bỏ border mặc định
                              prefixIcon: Icon(Icons.translate, color: Colors.black, size: 30,),
                              hintText: AppLocalizations.of(context)!.distionary_Screen_hint,
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                            ),
                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        String word = _searchController.text.trim();
                        if(word.isNotEmpty){
                          context.read<DictionaryBloc>().add(SearchChanged(word));
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Vui lòng nhập từ cần tìm", style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 58,
                        height: 58,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.search, color: Colors.white,),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        if(state is DictionaryError)
                          const BoxFailWidget(),
                        if(state is DictionaryLoaded)
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
                            width: MediaQuery.sizeOf(context).width,
                            constraints: const BoxConstraints(
                              maxHeight: 600, // 👈 minHeight cho cả container
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.grey,
                                  offset: Offset(0, 2),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: SingleChildScrollView(// 👈 thêm scroll
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        state.word.word,
                                        style: TextStyle(fontSize: 25),
                                      ),
                                      IconButton(
                                        onPressed: (){
                                          context.read<DictionaryBloc>().add(ToggleBookmarkEvent(state.word));
                                        },
                                        icon: Icon(
                                        (state.word.isBookmarked) ? CupertinoIcons.heart_fill : AntDesign.heart_outline,
                                        size: 30,
                                        color: (state.word.isBookmarked)
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    state.word.reading,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.textSecond.withOpacity(0.5),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    AppLocalizations.of(context)!.distionary_Screen_mean,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.textPrimary,
                                      fontFamily: "Itim",
                                    ),
                                  ),
                                  Divider(
                                    height: 2,
                                    color: AppColors.grey.withOpacity(0.3),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    constraints: BoxConstraints(minHeight: 50),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(color: AppColors.primary, width: 2),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            state.word.meaning,
                                            style: TextStyle(fontSize: 15, fontFamily: "Itim"),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  if(state.word.example.isNotEmpty)
                                    Container(
                                        constraints: BoxConstraints(minHeight: 50),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(color: AppColors.primary, width: 2),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                state.word.example.split("-")[0],
                                                style: TextStyle(fontSize: 15, fontFamily: "Itim"),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                state.word.example.split("-")[1].trim(),
                                                style: TextStyle(fontSize: 15, fontFamily: "Itim"),
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                  SizedBox(height: 10),
                                  Text(
                                    AppLocalizations.of(context)!.distionary_Screen_info,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.textPrimary,
                                      fontFamily: "Itim",
                                    ),
                                  ),
                                  Divider(
                                    height: 2,
                                    color: AppColors.grey.withOpacity(0.3),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        "${AppLocalizations.of(context)!.distionary_Screen_type} ${
                                            state.word.tag
                                        }",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: AppColors.textPrimary.withOpacity(0.6),
                                          fontFamily: "Itim",
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "${AppLocalizations.of(context)!.distionary_Screen_level} ${
                                            state.word.jlpt
                                        }",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: AppColors.textPrimary.withOpacity(0.6),
                                          fontFamily: "Itim",
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: [
                                      for (int i = 0; i < state.word.anotherWord.length; i++)
                                        WordSameWidget(
                                          word: state.word.anotherWord[i],
                                          onTap: (){
                                            context.read<DictionaryBloc>().add(SearchChanged(state.word.anotherWord[i]));
                                          },
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        if(state is DictionaryLoading)
                          const BoxLoadingWidget(),

                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 400),
                                  pageBuilder: (context, animation, secondaryAnimation) => BookmarkPage(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    // Slide từ dưới lên
                                    var slideTween = Tween<Offset>(
                                      begin: const Offset(0, 1),
                                      end: Offset.zero,
                                    ).chain(CurveTween(curve: Curves.easeOutCubic));

                                    // Fade mượt
                                    var fadeTween = Tween<double>(begin: 0.0, end: 1.0)
                                        .chain(CurveTween(curve: Curves.easeOut));

                                    return SlideTransition(
                                      position: animation.drive(slideTween),
                                      child: FadeTransition(
                                        opacity: animation.drive(fadeTween),
                                        child: child,
                                      ),
                                    );
                                  },
                                ),
                              );
                              context.read<DictionaryBloc>().add(LoadDictionary());
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: const Row(
                              children: [
                                Icon(Icons.book, size: 40, color: Colors.white),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    "Sổ từ vựng",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
