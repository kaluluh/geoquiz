import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoquiz/common/navigation.dart';
import 'package:geoquiz/controller/stats_controller.dart';

import '../../common/colors.dart';
import '../../common/headings.dart';
import '../../common/spaced_column.dart';
import '../../controller/application_controller.dart';
import '../../game/game_controller.dart';
import '../../services/firebase/auth.dart';
import '../game_page.dart';

class GameBottomBar extends ConsumerWidget {
  const GameBottomBar({
    Key? key,
    required this.gameType,
    required this.gameDifficulty,
    required this.guessAction
  }) : super(key: key);

  final GameType gameType;
  final GameDifficulty gameDifficulty;
  final VoidCallback guessAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.backgroundLight, AppColors.backgroundDark],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: () {
          switch (ref.watch(gameControllerProvider).gameState) {
            case GameState.playing:
              return _buildPlayingBar(context, ref);
            case GameState.guessed:
              return _buildGuessedBar(context, ref);
            case GameState.finished:
              return _buildFinishedBar(context, ref);
            case GameState.loading:
              return const Center(child: CircularProgressIndicator());
            case GameState.notStarted:
              return _buildStartScreen(context, ref);
          }
        }()
      ),
    );
  }

  Widget _buildPlayingBar(BuildContext context, WidgetRef ref) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 1, child: _buildLivesCouter(context, ref)),
          Expanded(flex: 2, child: _buildPlayingInfo(context, ref)),
          Expanded(flex: 1, child: _buildScoreCounter(context, ref)),
        ],
      ),
    );
  }

  Widget _buildLivesCouter(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text('Lives', style: TextStyle(color: AppColors.textLightSecondary, fontSize: 16)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _createLiveIcons(ref.watch(gameControllerProvider).lives),
        ),
      ],
    );
  }

  List<Widget> _createLiveIcons(int lives) {
    const maxLives = GameInfo.maxLives;
    return List.generate(maxLives, (index) {
      return Icon(
        index < lives ? Icons.favorite : Icons.heart_broken,
        color: index < lives ? AppColors.primary : AppColors.textDark,
      );
    });
  }

  Widget _buildPlayingInfo(BuildContext context, WidgetRef ref) {
    final hasPlacedMarker = ref.watch(markerPlacedProvider);
    return SpacedColumn(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Guess the location',
          style: TextStyle(color: AppColors.textLightSecondary, fontSize: 16),
        ),
        Text(
            ref.watch(gameControllerProvider).currentCity?.name ?? '',
            style: const TextStyle(color: AppColors.textLight, fontSize: 28),
        ),
        ElevatedButton(
          onPressed: hasPlacedMarker ? guessAction : null,
          style: ElevatedButton.styleFrom(
            primary: AppColors.primary,
            onPrimary: AppColors.textLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Guess'),
        ),
      ],
    );
  }

  Widget _buildScoreCounter(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('Score', style: TextStyle(color: AppColors.textLightSecondary, fontSize: 16)),
        Text(
          ref.watch(gameControllerProvider).score.toString(),
          style: const TextStyle(fontSize: 24, color: AppColors.textLight),
        ),
      ],
    );
  }

  Widget _buildGuessedBar(BuildContext context, WidgetRef ref) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 1, child: _buildLivesCouter(context, ref)),
          Expanded(flex: 2, child: _buildGuessedInfo(context, ref)),
          Expanded(flex: 1, child: _buildScoreCounter(context, ref)),
        ],
      ),
    );
  }

  Widget _buildGuessedInfo(BuildContext context, WidgetRef ref) {
    var guess = ref.watch(lastGuessProvider)!;
    var gameController = ref.watch(gameControllerProvider);
    return SpacedColumn(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'You guessed',
          style: TextStyle(color: AppColors.textLightSecondary, fontSize: 16),
        ),
        Text(
          guess.correct ? 'Correctly!' : 'Incorrectly...',
          style: const TextStyle(color: AppColors.textLight, fontSize: 28),
        ),
        Text(
          "You were ${guess.distance.toStringAsFixed(3)} km away",
          style: const TextStyle(color: AppColors.textLightSecondary, fontSize: 14),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(gameControllerProvider.notifier).nextTurn();
            ref.read(markerPlacedProvider.notifier).state = false;
            _clearMarkers(ref);
          },
          style: ElevatedButton.styleFrom(
            primary: AppColors.primary,
            onPrimary: AppColors.textLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(ref.watch(gameControllerProvider).lives <= 0 ? 'Finish' : 'Next'),
        ),
      ],
    );
  }

  Widget _buildFinishedBar(BuildContext context, WidgetRef ref) {
    return Center(
      child: SpacedColumn(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Game finished',
            style: TextStyle(color: AppColors.textLightSecondary, fontSize: 16),
          ),
          Text(
            'You scored ${ref.watch(gameControllerProvider).score} points',
            style: const TextStyle(color: AppColors.textLight, fontSize: 28),
          ),
          Text(
            'and you gained ${(ref.watch(gameControllerProvider).score / 25 * gameDifficulty.xpMultiplier).toInt().toString()} experience',
            style: const TextStyle(color: AppColors.textLightSecondary, fontSize: 14),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(gameControllerProvider.notifier).resetGame();
                  _clearMarkers(ref);
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors.primary,
                  onPrimary: AppColors.textLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Play again'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  ref.read(gameControllerProvider.notifier).resetGame();
                  _clearMarkers(ref);
                  changePage(ref, AppPage.home);
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColors.secondary,
                  onPrimary: AppColors.textLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Back to menu'),
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget _buildStartScreen(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                  offset: Offset(0.0, 0.0),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SpacedColumn(
                spacing: 20,
                children: [
                  const Heading(
                    text: "Rules",
                    level: Headings.h1,
                    styleOverride: TextStyle(color: AppColors.textDark),
                  ),
                  Container(
                    width: 340,
                    child: SpacedColumn(
                      spacing: 16,
                      children: [
                        Text("You will be prompted to find a city on the map. "
                            "Based on the distance you are away from the city, "
                            "you will be awarded points to a maximum of ${GameController.perfectScore.toInt()} points.",
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textDark,
                          ),),
                        Text("Place your guess within ${(gameDifficulty.maxDistance*GameController.perfectCutoff).toInt()} km to get the maximum points."
                            "Build up combos by getting perfect scores in a row!",
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textDark,
                          ),),
                        Text("If you are further than ${gameDifficulty.maxDistance.toInt()} km away, "
                            "you will lose a life. You have ${GameInfo.maxLives} lives.",
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textDark,
                          ),),
                        Row(
                          children: const [
                            SizedBox(width: 48, child: Icon(Icons.location_on, size: 32, color: AppColors.textDark,),),
                            Text("Find the prompted city on the map", style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textDark,
                            ),),
                          ],
                        ),
                        Row(
                          children: const [
                            SizedBox(width: 48, child: Icon(Icons.touch_app, size: 32, color: AppColors.textDark,),),
                            Text("Tap the map to place your guess", style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textDark,
                            ),),
                          ],
                        ),
                        Row(
                          children: const [
                            SizedBox(width: 48, child: Icon(Icons.check_circle, size: 32, color: AppColors.textDark,),),
                            Text("Tap the guess button to submit your guess", style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textDark,
                            ),),
                          ],
                        ),
                        Row(
                          children: const [
                            SizedBox(width: 48, child: Icon(Icons.heart_broken, size: 32, color: AppColors.textDark,),),
                            Text("Repeat until you run out of lives", style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textDark,
                            ),),
                          ],
                        ),
                        const Text("Good luck!", style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(gameControllerProvider.notifier).startGame(gameType, gameDifficulty);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.primary,
                      onPrimary: AppColors.textLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "Start the game",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _clearMarkers(WidgetRef ref) {
    ref.read(markersProvider.notifier).state = {};
    ref.read(linesProvider.notifier).state = {};
  }
}
