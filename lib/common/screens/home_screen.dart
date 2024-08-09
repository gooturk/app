import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gooturk/common/component/custom_button.dart';
import 'package:gooturk/common/provider/go_router_provider.dart';

class HomeScreen extends ConsumerWidget {
  static String get routerName => '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CustomButton(
          text: 'Playground',
          onPressed: () {
            ref.read(goRouterProvider).go('/playground');
          },
        ),
        CustomButton(
          text: 'Yolo',
          onPressed: () {
            ref.read(goRouterProvider).go('/yolo');
          },
        ),
        CustomButton(
          text: 'test',
          onPressed: () {
            ref.read(goRouterProvider).go('/test');
          },
        ),
      ],
    );
  }
}
