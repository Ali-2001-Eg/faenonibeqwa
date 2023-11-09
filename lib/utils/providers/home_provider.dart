import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeProvider extends ChangeNotifier {
  final ProviderRef ref;
  HomeProvider(this.ref);

  void changeIndex(int newIndex) {
    ref.read(homeIndexState.state).update((state) => newIndex);
    
    notifyListeners();
  }
}

final homeProvider = Provider((ref) => HomeProvider(ref));
final homeIndexState = StateProvider<int>((ref) => 0);
