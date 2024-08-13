import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gooturk/common/const/color.dart';
import 'package:gooturk/common/icons/gooturk_icon_pack_icons.dart';
import 'package:gooturk/common/layout/default_screen_layout.dart';
import 'package:gooturk/hisotry/screens/history_screen.dart';
import 'package:gooturk/profile/screens/profile_screnn.dart';
import 'package:gooturk/record/provider/record_status_provider.dart';

class RootScreen extends StatelessWidget {
  static String get routerName => '/';
  final Widget child;
  const RootScreen({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    late final String appBarText;
    switch (child.runtimeType) {
      case HistoryScreen _:
        appBarText = '기록';
        break;
      case ProfileScreen _:
        appBarText = '프로필';
        break;
      default:
        appBarText = '';
    }
    return DefaultLayout(
      title: appBarText,
      bottomNavigationBar: BottomNavBar(),
      child: Container(
        color: Colors.white,
        child: child,
      ),
    );
  }
}

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 150),
      firstCurve: Curves.easeInOut,
      secondCurve: Curves.easeInOut,
      firstChild: const SizedBox.shrink(),
      secondChild: _buildBottomNavigationBar(context),
      crossFadeState: ref.watch(recordStatusProvider)
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }
}

BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
  return BottomNavigationBar(
    selectedItemColor: PRIMARY_ORANGE,
    unselectedItemColor: TEXT_COLOR,
    selectedFontSize: 10,
    unselectedFontSize: 10,
    // type: BottomNavigationBarType.shifting,
    type: BottomNavigationBarType.fixed,
    onTap: (int index) {
      switch (index) {
        case 0:
          context.go('/record');
          break;
        case 1:
          context.go('/history');
          break;
        case 2:
          context.go('/profile');
          break;
      }
    },
    currentIndex: () {
      final location = GoRouterState.of(context).location;
      if (location.startsWith('/record')) return 0;
      if (location.startsWith('/history')) return 1;
      if (location.startsWith('/profile')) return 2;
      return 0;
    }(),
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.camera),
        label: '촬영',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: '기록',
      ),
      BottomNavigationBarItem(
        icon: Icon(GooturkIconPack.profile),
        label: '프로필',
      ),
    ],
  );
}
