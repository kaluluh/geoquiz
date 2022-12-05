import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerWidget, StateProvider, WidgetRef;
import 'package:geoquiz/common/colors.dart';
import 'package:geoquiz/common/headings.dart';
import 'package:geoquiz/common/keys.dart';
import 'package:geoquiz/controller/application_controller.dart';
import 'package:provider/provider.dart';

import '../common/avatar.dart';
import '../common/navigation.dart';
import '../common/page_wrapper.dart';
import '../common/spaced_column.dart';
import '../controller/dtos/userdto.dart';
import '../game/game_controller.dart';
import '../services/firebase/auth.dart';
import 'game_page.dart';

class GameSelectPage extends ConsumerWidget {
  const GameSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomNavigationIndex = ref.watch(pageNavigationProvider);
    return PageWrapper(
      backgroundImage: const AssetImage("assets/images/background_image.png"),
      bottomNav: createBottomNavigation(bottomNavigationIndex.index, (index) {
        changePage(ref, AppPageExtension.getByNavIndex(index));
      }),
      child: _buildContent(context, ref),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: SpacedColumn(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20,
          children: [
            const Center(
              child: Heading(
                text: "Select a game",
                level: Headings.h1,
                styleOverride: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              child: SpacedColumn(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 20,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref.read(gameDifficultyProvider.notifier).state = GameDifficulty.easy;
                      changePage(ref, AppPage.game);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.difficultyEasy,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minimumSize: const Size(0, 100),
                    ),
                    child: const Text("Easy", style: TextStyle(fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(gameDifficultyProvider.notifier).state = GameDifficulty.medium;
                      changePage(ref, AppPage.game);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.difficultyMedium,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minimumSize: const Size(0, 100),
                    ),
                    child: const Text("Medium", style: TextStyle(fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(gameDifficultyProvider.notifier).state = GameDifficulty.hard;
                      changePage(ref, AppPage.game);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.difficultyHard,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minimumSize: const Size(0, 100),
                    ),
                    child: const Text("Hard", style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
