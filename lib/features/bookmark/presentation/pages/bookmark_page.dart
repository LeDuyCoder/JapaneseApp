import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/core/Theme/colors.dart';
import 'package:japaneseapp/features/bookmark/bloc/bookmark_bloc.dart';
import 'package:japaneseapp/features/bookmark/bloc/bookmark_event.dart';
import 'package:japaneseapp/features/bookmark/bloc/bookmark_state.dart';
import 'package:japaneseapp/features/bookmark/data/datasources/bookmark_local_datasource.dart';
import 'package:japaneseapp/features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'package:japaneseapp/features/bookmark/presentation/widgets/vocabulary_card.dart';
import 'package:japaneseapp/features/bookmark/presentation/widgets/vocabulary_card_loading.dart';
import 'package:japaneseapp/features/bookmark/presentation/widgets/vocabulary_nodata.dart';

class BookmarkPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookMarkBloc(
        BookmarkRepositoryImpl(
          repository: BookmarkLocalDataSource(),
        ),
      )..add(LoadBookmarks()),
      child: BlocConsumer<BookMarkBloc, BookmarkState>(
          builder: (context, state){
            return Scaffold(
              backgroundColor: AppColors.backgroundPrimary,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: const Text("Sổ Từ Vựng", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 25),),
                backgroundColor: AppColors.backgroundPrimary,
                scrolledUnderElevation: 0,
              ),
              body: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      if(state is BookmarkLoading)
                        const VocabularyCardLoading(),
                      if(state is BookmarkLoaded)
                        if(state.bookmarks.isNotEmpty)...[
                          Column(
                            children: state.bookmarks.map((word) => VocabularyCard(wordEntity: word, onDelete: () {
                              context.read<BookMarkBloc>().add(RemoveBookmarkEvent(wordEntity: word));
                            },)).toList(),
                          )
                        ]else...[
                          const VocabularyNoData()
                        ]
                    ],
                  ),
                ),
              )
            );
          },
          listener: (context, state){}
      )
    );
  }
}