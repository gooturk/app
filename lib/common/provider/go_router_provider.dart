import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gooturk/analysis/screens/analysis_screen.dart';
import 'package:gooturk/common/layout/default_screen_layout.dart';
import 'package:gooturk/common/screens/home_screen.dart';
import 'package:gooturk/common/screens/root_screen.dart';
import 'package:gooturk/common/screens/splash_screen.dart';
import 'package:gooturk/hisotry/screens/history_screen.dart';
import 'package:gooturk/main.dart';
import 'package:gooturk/playground.dart';
import 'package:gooturk/profile/screens/profile_screnn.dart';
import 'package:gooturk/record/screens/camera_example.dart';
import 'package:gooturk/record/screens/record_screen.dart';
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
            child: HistoryScreen(),
          ),
          routes: [
            GoRoute(
              path: 'splash',
              name: SplashScreen.routerName,
              builder: (_, __) => const SplashScreen(),
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
              path: 'record',
              name: RecordScreen.routerName,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: RootScreen(
                    child: RecordScreen(),
                  ),
                );
              },
              builder: (_, __) => const RootScreen(
                child: RecordScreen(),
              ),
            ),
            GoRoute(
              path: 'record-test',
              name: 'record-test',
              builder: (_, __) => const RootScreen(
                child: CameraExampleHome(),
              ),
            ),
            GoRoute(
              path: 'profile',
              name: ProfileScreen.routerName,
              pageBuilder: (_, __) => NoTransitionPage(
                child: RootScreen(
                  child:
                      kDebugMode ? const HomeScreen() : const ProfileScreen(),
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
            GoRoute(
              path: 'analysis/:id',
              builder: (context, state) {
                final id = state.pathParameters['id'];
                if (id == null) {
                  throw Exception('id is null');
                }
                return DefaultLayout(
                  title: id,
                  child: AnalysisScreen(
                    videoName: id,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  },
);
