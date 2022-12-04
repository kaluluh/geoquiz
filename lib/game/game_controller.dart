import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/city.dart';
import '../services/api/city_data_service.dart';

enum GameType{
  world,
  europe,
  asia,
  africa,
  northAmerica,
  southAmerica,
  oceania,
}

extension GameTypeExtension on GameType {
  String get name {
    switch (this) {
      case GameType.world:
        return 'World';
      case GameType.europe:
        return 'Europe';
      case GameType.asia:
        return 'Asia';
      case GameType.africa:
        return 'Africa';
      case GameType.northAmerica:
        return 'North America';
      case GameType.southAmerica:
        return 'South America';
      case GameType.oceania:
        return 'Oceania';
    }
  }
}

enum GameDifficulty{
  easy,
  medium,
  hard,
}

extension GameDifficultyExtension on GameDifficulty {
  String get name {
    switch (this) {
      case GameDifficulty.easy:
        return 'Easy';
      case GameDifficulty.medium:
        return 'Medium';
      case GameDifficulty.hard:
        return 'Hard';
    }
  }

  double get factor {
    switch (this) {
      case GameDifficulty.easy:
        return 0.025;
      case GameDifficulty.medium:
        return 0.05;
      case GameDifficulty.hard:
        return 0.075;
    }
  }

  double get maxDistance {
    switch (this) {
      case GameDifficulty.easy:
        return 5000;
      case GameDifficulty.medium:
        return 2500;
      case GameDifficulty.hard:
        return 1000;
    }
  }
}

enum GameState{
  notStarted,
  loading,
  playing,
  guessed,
  finished,
}

class GameInfo {
  final GameType gameType;
  final GameDifficulty difficulty;
  final GameState gameState;
  final int score;
  final int guessCount;
  final int combo;
  final int lives;

  final City? currentCity;

  static const maxLives = 3;

  GameInfo({
    this.gameType = GameType.world,
    this.difficulty = GameDifficulty.medium,
    this.gameState = GameState.notStarted,
    this.score = 0,
    this.guessCount = 0,
    this.combo = 0,
    this.lives = maxLives,
    this.currentCity,
  });

  GameInfo copyWith({
    GameType? gameType,
    GameDifficulty? difficulty,
    GameState? gameState,
    int? score,
    int? guessCount,
    int? combo,
    int? lives,
    City? currentCity,
  }) {
    return GameInfo(
      gameType: gameType ?? this.gameType,
      difficulty: difficulty ?? this.difficulty,
      gameState: gameState ?? this.gameState,
      score: score ?? this.score,
      guessCount: guessCount ?? this.guessCount,
      combo: combo ?? this.combo,
      lives: lives ?? this.lives,
      currentCity: currentCity ?? this.currentCity,
    );
  }
}

class GuessInfo {
  final LatLng guess;
  final LatLng actual;
  final double distance;
  final double score;
  final bool correct;

  GuessInfo({
    required this.guess,
    required this.actual,
    required this.distance,
    required this.score,
    required this.correct,
  });
}

final gameControllerProvider = StateNotifierProvider<GameController, GameInfo>((ref) => GameController());

class GameController extends StateNotifier<GameInfo> {
  GameController() : super(GameInfo());

  static const perfectScore = 2500.0;
  static const perfectCutoff = 0.01;

  int getMaxPopulation(){
    const double startMaxPop = 40000000.0;
    const double limit = 10000.0;
    final result = pow(startMaxPop, -(0.5 * state.difficulty.factor * state.guessCount - 1));
    return max(result.roundToDouble(), limit).toInt();
  }

  int getMinPopulation(){
    const double startMinPop = 15000000.0;
    const double limit = 1000.0;
    final result = pow(startMinPop, -(state.difficulty.factor * state.guessCount - 1));
    return max(result.roundToDouble(), limit).toInt();
  }

  double getCapitalChance(){
    final result = tanh(state.difficulty.factor * state.guessCount) + 1;
    return max(result.toDouble(), 0.0);
  }

  Future<City> getNextCity() async {
    final maxPop = getMaxPopulation();
    final minPop = getMinPopulation();
    final capitalChance = getCapitalChance();
    final getCapital = Random().nextDouble() < capitalChance;
    final cities = await CityDataService.fetchCities(
      maxPopulation: maxPop,
      minPopulation: minPop,
      limit: 100,
    );
    if (getCapital) {
      final capitals = cities.where((city) => city.isCapital).toList();
      if (capitals.isNotEmpty) {
        var randomCity = capitals[Random().nextInt(capitals.length)];
        print(randomCity);
        return randomCity;
      }
    }
    var randomCity = cities[Random().nextInt(cities.length)];
    print(randomCity);
    return randomCity;
  }

  double calculateDistanceFromLatLon(double lat1, double lon1, double lat2, double lon2) {
    var R = 6378; // Radius of the earth in km
    var dLat = deg2rad(lat2-lat1);  // deg2rad below
    var dLon = deg2rad(lon2-lon1);
    var a =
      sin(dLat/2) * sin(dLat/2) +
      cos(deg2rad(lat1)) * cos(deg2rad(lat2)) *
      sin(dLon/2) * sin(dLon/2)
      ;
    var c = 2 * atan2(sqrt(a), sqrt(1-a));
    var d = R * c; // Distance in km
    return d;
  }

  double calculateScore(double distance){
    // Perfect score is 2500, worst score is 0
    // A perfect score is 1/100 of the max distance
    // A worst score is the max distance
    if (distance > state.difficulty.maxDistance) {
      return 0;
    }
    if (distance <= state.difficulty.maxDistance * perfectCutoff) {
      return perfectScore;
    }
    // Linear interpolation between perfect and worst score
    final factor = 1 - (distance - perfectCutoff * state.difficulty.maxDistance) / (state.difficulty.maxDistance - perfectCutoff * state.difficulty.maxDistance);
    return min(perfectScore * factor, perfectScore);
  }

  void startGame(GameType gameType, GameDifficulty gameDifficulty) async {
    resetGame();
    state = state.copyWith(
      gameType: gameType,
      difficulty: gameDifficulty,
      gameState: GameState.loading,
    );
    await nextTurn();
  }

  Future<void> nextTurn() async {
    if (state.lives <= 0) {
      state = state.copyWith(
        gameState: GameState.finished,
      );
      return;
    }
    final nextCity = await getNextCity();
    state = state.copyWith(
      gameState: GameState.playing,
      currentCity: nextCity,
    );
  }

  GuessInfo guess(double lat, double lon){
    final distance = calculateDistanceFromLatLon(
        lat, lon,
        state.currentCity?.latitude ?? 0, state.currentCity?.longitude ?? 0
    );
    final score = calculateScore(distance).ceilToDouble();
    final correct = distance < state.difficulty.maxDistance;

    state = state.copyWith(
      score: state.score + score.toInt(),
      guessCount: correct ? state.guessCount + 1 : state.guessCount,
      lives: correct ? state.lives : state.lives - 1,
      gameState: GameState.guessed,
    );

    return GuessInfo(
      guess: LatLng(lat, lon),
      actual: LatLng(state.currentCity?.latitude ?? 0, state.currentCity?.longitude ?? 0),
      distance: distance,
      score: score,
      correct: correct,
    );
  }

  void resetGame(){
    state = GameInfo();
  }
}

double tanh(double d) {
  return (exp(d) - exp(-d)) / (exp(d) + exp(-d));
}

double deg2rad(double deg) {
  return deg * (pi/180);
}