import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final stateProvider = ChangeNotifierProvider.autoDispose<CounterModel>((ref) => CounterModel());
class CounterModel with ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }

  void decrement() {
   if (_counter > 0) {
      _counter--;
    }
    notifyListeners();
  }
}