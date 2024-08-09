import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gooturk/common/const/color.dart';
import 'package:gooturk/common/provider/go_router_provider.dart';

class SplashScreen extends ConsumerWidget {
  static String get routerName => '/splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Timer(
      const Duration(seconds: 2),
      () => ref.read(goRouterProvider).go('/home'),
    );
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.86, -0.52),
            end: Alignment(-0.86, 0.52),
            colors: [PRIMARY_YELLOW, PRIMARY_ORANGE],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '구측',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'Gmarket Sans TTF',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
