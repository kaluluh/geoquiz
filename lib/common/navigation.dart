import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoquiz/common/colors.dart';
import 'package:geoquiz/game/game_controller.dart';

import '../app/dashboard_page.dart';
import '../app/friends_page.dart';
import '../app/game_page.dart';
import '../app/game_select_page.dart';

enum AppPage {
  home,
  gameSelection,
  friends,
  game,
}

extension AppPageExtension on AppPage {
  int get index => AppPage.values.indexOf(this);

  Widget get page {
    switch (this) {
      case AppPage.home:
        return const DashboardPage();
      case AppPage.gameSelection:
        return const GameSelectPage();
      case AppPage.friends:
        return FriendsPage();
      case AppPage.game:
        return GamePage();
    }
  }

  static AppPage getByNavIndex(int index) {
    switch (index) {
      case 0:
        return AppPage.home;
      case 1:
        return AppPage.gameSelection;
      case 2:
        return AppPage.friends;
      default:
        return AppPage.home;
    }
  }
}

final pageNavigationProvider = StateProvider<AppPage>((ref) => AppPage.home);

BottomNavigationBar createBottomNavigation(int navIndex, Function(int) onTap) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: AppColors.backgroundDarkSecondary,
    elevation: 10,
    currentIndex: navIndex,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    onTap: onTap,
    items: const <BottomNavigationBarItem>[
      // Home
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
        backgroundColor: Colors.black45,
      ),
      // Games
      BottomNavigationBarItem(
        icon: Icon(Icons.games),
        label: "Games",
        backgroundColor: Colors.black45,
      ),
      // Friends
      BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: "Friends",
        backgroundColor: Colors.black45,
      ),
    ],
  );
}

void changePage(WidgetRef ref, AppPage page) {
  ref.read(pageNavigationProvider.notifier).state = page;
}