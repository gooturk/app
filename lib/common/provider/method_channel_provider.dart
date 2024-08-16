import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gooturk/common/const/data.dart';

final methodChannelProvider =
    StateNotifierProvider<MethodChannelStateNotifier, MethodChannel?>(
  (ref) => MethodChannelStateNotifier(),
);

class MethodChannelStateNotifier extends StateNotifier<MethodChannel?> {
  MethodChannelStateNotifier() : super(null);

  Future<void> initMethodChannel() async {
    state = MethodChannel(CHANNEL_NAME);
  }

  Future<T> invokeMethod<T>(String method, [dynamic arguments]) async {
    if (state == null) {
      throw Exception('MethodChannel is not initialized');
    }
    final result = await state!.invokeMethod<T>(method, arguments);
    if (result == null) {
      throw Exception('MethodChannel is not initialized');
    }
    return result;
  }
}
