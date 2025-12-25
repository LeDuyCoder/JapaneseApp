import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/dashboard/presentaition/cubit/tab_state.dart';

class TabCubit extends Cubit<TabState> {
  TabCubit() : super(TabState(0, 0));

  void changeTab(int index) {
    emit(TabState(index, state.reloadKey));
  }

  void resetTab() {
    emit(state.copyWith(reloadKey: state.reloadKey + 1));
  }
}
