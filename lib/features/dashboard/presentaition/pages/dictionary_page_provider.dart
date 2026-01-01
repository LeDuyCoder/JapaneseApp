import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/dictionary/bloc/dictionary_bloc.dart';
import 'package:japaneseapp/features/dictionary/bloc/dictionary_event.dart';
import 'package:japaneseapp/features/dictionary/data/datasources/dictionary_remote_datasource.dart';
import 'package:japaneseapp/features/dictionary/data/repositories/dictionary_repository_impl.dart';
import 'package:japaneseapp/features/dictionary/presentation/pages/dictionary_page.dart';

class DictionaryPageProvider extends StatelessWidget {
  const DictionaryPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DictionaryBloc(
        DictionaryRepositoryImpl(
          remoteDataSource: DictionaryRemoteDataSourceImpl(),
        ),
      )..add(LoadDictionary()),
      child: DictionaryPage(),
    );
  }

}
