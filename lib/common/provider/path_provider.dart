import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final pathProvider = StateNotifierProvider<PathStateNotifier, Directory>(
  (ref) {
    return PathStateNotifier();
  },
);

class PathStateNotifier extends StateNotifier<Directory> {
  PathStateNotifier() : super(Directory('/'));

  void setPath(Directory path) {
    state = path;
  }
}
