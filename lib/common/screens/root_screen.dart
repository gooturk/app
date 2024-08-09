import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gooturk/common/const/color.dart';
import 'package:gooturk/common/const/data.dart';
import 'package:gooturk/common/icons/gooturk_icon_pack_icons.dart';
import 'package:gooturk/common/layout/default_screen_layout.dart';
import 'package:gooturk/hisotry/screens/history_screen.dart';
import 'package:gooturk/profile/screens/profile_screnn.dart';

class RootScreen extends StatelessWidget {
  static String get routerName => '/';
  final Widget child;
  const RootScreen({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    late final String appBarText;
    switch (child.runtimeType) {
      case HistoryScreen:
        appBarText = '나의 예약';
        break;
      case ProfileScreen:
        appBarText = '내 정보';
        break;
      default:
        appBarText = '';
    }
    return DefaultLayout(
      title: appBarText,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_ORANGE,
        unselectedItemColor: TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        // type: BottomNavigationBarType.shifting,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          switch (index) {
            case 0:
              context.go(INITIAL_LOCATION);
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
          if (location.startsWith('/home')) return 0;
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
      ),
      child: Container(
        color: Colors.white,
        child: child,
      ),
    );
  }
}
