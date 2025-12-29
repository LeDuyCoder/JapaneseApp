import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/learn/bloc/learn_bloc.dart';
import 'package:japaneseapp/features/learn/bloc/learn_event.dart';
import 'package:japaneseapp/features/learn/bloc/learn_state.dart';
import 'package:japaneseapp/features/learn/data/datasources/learn_local_datasource.dart';
import 'package:japaneseapp/features/learn/data/repositories/learn_repository_impl.dart';
import 'package:japaneseapp/features/learn/domain/enum/type_test.dart';

class LearnCharacterPage extends StatelessWidget{
  final TypeTest type;
  final int setLevel;

  const LearnCharacterPage({super.key, required this.type, required this.setLevel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LearnBloc(
        LearnRepositoryImpl(
            LearnLocalDataSourceImpl()
        )
      )..add(StartLearningCharacterEvent(type: type, setLevel: setLevel)),
      child: BlocConsumer<LearnBloc, LearnState>(
          builder: (context, state){
            return Container();
          },
          listener: (context, state){}
      ),
    );
  }

}