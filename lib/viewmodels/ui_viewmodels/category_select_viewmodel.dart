import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySelectedNotifier extends StateNotifier<int> {
  CategorySelectedNotifier() : super(0);

  setCategory(int value) {
    state = value;
  }
}

final categorySelectedProvider = StateNotifierProvider<CategorySelectedNotifier,int>(
  (ref) => CategorySelectedNotifier(),
);
