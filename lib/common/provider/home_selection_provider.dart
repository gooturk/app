import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HomeSelection { reservation, matching }

final homeSelectionProvider =
    StateNotifierProvider<HomeSelectionStateNotifier, HomeSelection>((ref) {
  return HomeSelectionStateNotifier();
});

class HomeSelectionStateNotifier extends StateNotifier<HomeSelection> {
  HomeSelectionStateNotifier() : super(HomeSelection.reservation);

  void toggle() {
    state = state == HomeSelection.reservation
        ? HomeSelection.matching
        : HomeSelection.reservation;
  }

  void update(HomeSelection selection) {
    state = selection;
  }
}
