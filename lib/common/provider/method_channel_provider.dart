import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final methodChannelProvider =
    StateNotifierProvider<MethodChannelStateNotifier, MethodChannel>(
  (ref) => MethodChannelStateNotifier(),
);

class MethodChannelStateNotifier extends StateNotifier<MethodChannel> {
  MethodChannelStateNotifier() : super(MethodChannel('gooturk_native'));

  Future<T> invokeMethod<T>(String method, [dynamic arguments]) async {
    final result = await state.invokeMethod<T>(method, arguments);
    if (result == null) {
      throw Exception('MethodChannel is not initialized');
    }
    return result;
  }
}
