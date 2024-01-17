import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeProvider extends StateNotifier<int> {
  // super state like cubit
  HomeProvider(super.state) {
    //to make initial method as soon as it is loaded
    changeIndex(0);
  }
//method to update UI and if it was for a model should use copyWith method
  void changeIndex(int newIndex) {
    state = newIndex;
  }
}

