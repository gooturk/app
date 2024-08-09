import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gooturk/common/screens/home_screen.dart';
import 'package:gooturk/common/screens/root_screen.dart';
import 'package:gooturk/common/screens/splash_screen.dart';
import 'package:gooturk/hisotry/screens/history_screen.dart';
import 'package:gooturk/main.dart';
import 'package:gooturk/playground.dart';
import 'package:gooturk/profile/screens/profile_screnn.dart';
import 'package:gooturk/yolo_example.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/splash',
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: '/',
          name: RootScreen.routerName,
          builder: (_, __) => const RootScreen(
            child: HomeScreen(),
          ),
          routes: [
            GoRoute(
              path: 'splash',
              name: SplashScreen.routerName,
              builder: (_, __) => const SplashScreen(),
            ),
            GoRoute(
              path: 'home',
              name: HomeScreen.routerName,
              builder: (_, __) => const RootScreen(
                child: HomeScreen(),
              ),
            ),
            GoRoute(
              path: 'history',
              name: HistoryScreen.routerName,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: RootScreen(
                    child: HistoryScreen(),
                  ),
                );
              },
            ),
            GoRoute(
              path: 'profile',
              name: ProfileScreen.routerName,
              pageBuilder: (_, __) => NoTransitionPage(
                child: RootScreen(
                  child: ProfileScreen(),
                ),
              ),
            ),
            GoRoute(
              path: 'playground',
              builder: (_, __) => const PlaygroundWidget(),
            ),
            GoRoute(
              path: 'yolo',
              builder: (_, __) => const ExampleWidget(),
            ),
            GoRoute(
              path: 'test',
              builder: (_, __) => MyHomePage(title: '123123'),
            ),
          ],
        ),
      ],
    );
  },
);
