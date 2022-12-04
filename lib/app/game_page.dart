import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoquiz/common/headings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../common/page_wrapper.dart';
import '../common/spaced_column.dart';
import '../game/game_controller.dart';

final selectedLatProvider = StateProvider<double>((ref) => 0.0);
final selectedLongProvider = StateProvider<double>((ref) => 0.0);
final markersProvider = StateProvider<Set<Marker>>((ref) => {});
final linesProvider = StateProvider<Set<Polyline>>((ref) => {});
final lastGuessProvider = StateProvider<GuessInfo?>((ref) => null);

class GamePage extends ConsumerWidget {
  GamePage({Key? key}) : super(key: key);

  static const MarkerId markerId = MarkerId('guessPosition');
  Completer<GoogleMapController> controllerCompleter = Completer();
  static BitmapDescriptor markerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  static BitmapDescriptor answerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var markers = ref.watch(markersProvider);
    var lines = ref.watch(linesProvider);
    return PageWrapper(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: _buildMap(context, ref, markers, lines),
          ),
          _buildBottomBar(context, ref),
        ],
      )
    );
  }

  Widget _buildMap(BuildContext context, WidgetRef ref,
      Set<Marker> markers, Set<Polyline> lines) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: const CameraPosition(
        target: LatLng(0, 0),
        zoom: 2,
      ),
      onMapCreated: (GoogleMapController controller) {
        // update style
        rootBundle.loadString('assets/map/styles/labelless.json').then((string) {
          controller.setMapStyle(string);
          controllerCompleter.complete(controller);
        });
      },
      mapToolbarEnabled: false,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      trafficEnabled: false,
      onTap: (LatLng latLng) {
        // if gamestate is playing then update marker
        if (ref.read(gameControllerProvider).gameState != GameState.playing) return;
        ref.read(selectedLatProvider.notifier).state = latLng.latitude;
        ref.read(selectedLongProvider.notifier).state = latLng.longitude;
        _updateGuessMarker(ref, latLng, visible: true);
      },
      markers: markers,
      polylines: lines,
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref){
    return Container(
      height: 200,
      color: Colors.white,
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
            return ElevatedButton(
                onPressed: () {
                  ref.read(gameControllerProvider.notifier).startGame(GameType.world, GameDifficulty.medium);
                },
                child: const Text('Start Game')
            );
        }
      }(),
    );
  }

  Widget _buildPlayingBar(BuildContext context, WidgetRef ref) {
    return SpacedColumn(
      children: [
        const Heading(
            text: "Find the city!",
            level: Headings.h5,
        ),
        Text(
          ref.watch(gameControllerProvider).currentCity?.name ?? "unknown",
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          "Lives: ${ref.watch(gameControllerProvider).lives.toString()}",
          style: Theme.of(context).textTheme.headline6,
        ),
        ElevatedButton(
          onPressed: () {
            var guess = ref.read(gameControllerProvider.notifier).guess(
              ref.read(selectedLatProvider),
              ref.read(selectedLongProvider),
            );
            ref.read(lastGuessProvider.notifier).state = guess;
            _showActualPositionMarker(ref, guess.actual);
            _zoomToMarkers(ref);
            _drawLine(ref, guess.guess, guess.actual);
          },
          child: const Text('Guess'),
        ),
      ],
    );
  }

  Widget _buildGuessedBar(BuildContext context, WidgetRef ref) {
    var guess = ref.watch(lastGuessProvider)!;
    var gameController = ref.watch(gameControllerProvider);
    return SpacedColumn(
      children: [
        Heading(
          text: "You guessed ${guess.correct ? "right!" : "incorrectly"}",
          level: Headings.h5,
        ),
        Text(
          // todo: show distance in meters if < 1000
          "You were ${guess.distance.toStringAsFixed(3)} km away and gained ${guess.score} points",
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(gameControllerProvider.notifier).nextTurn();
            _clearMarkers(ref);
          },
          child: Text(gameController.lives <= 0 ? "Finish" : "Next"),
        ),
      ],
    );
  }

  Widget _buildFinishedBar(BuildContext context, WidgetRef ref) {
    return Text("Game finished!");
  }

  void _clearMarkers(WidgetRef ref) {
    ref.read(markersProvider.notifier).state = {};
    ref.read(linesProvider.notifier).state = {};
  }

  void _updateGuessMarker(WidgetRef ref, LatLng latLng, {bool visible = true}) async {
    final marker = Marker(
      markerId: MarkerId('guessPosition${DateTime.now()}'),
      position: latLng,
      visible: visible,
      icon: markerIcon,
    );
    ref.read(markersProvider.notifier).state = {marker};
  }

  void _showActualPositionMarker(WidgetRef ref, LatLng latLng) async {
    var prevMarkers = ref.read(markersProvider);
    final marker = Marker(
      markerId: MarkerId('actualPosition${DateTime.now()}'),
      position: latLng,
      visible: true,
      icon: answerIcon,
    );
    ref.read(markersProvider.notifier).state = prevMarkers.union({marker});
  }

  void _zoomToMarkers(WidgetRef ref) async {
    var controller = await controllerCompleter.future;
    var markers = ref.read(markersProvider);
    // initialize bounds to the guess marker
    var northeast = markers.first.position;
    var southwest = markers.first.position;
    for (var marker in markers) {
      // get leftmost and rightmost markers
      if (marker.position.latitude < southwest.latitude) {
        southwest = LatLng(marker.position.latitude, southwest.longitude);
      }
      if (marker.position.latitude > northeast.latitude) {
        northeast = LatLng(marker.position.latitude, northeast.longitude);
      }
      // get topmost and bottommost markers
      if (marker.position.longitude < southwest.longitude) {
        southwest = LatLng(southwest.latitude, marker.position.longitude);
      }
      if (marker.position.longitude > northeast.longitude) {
        northeast = LatLng(northeast.latitude, marker.position.longitude);
      }
    }
    var bounds = LatLngBounds(southwest: southwest, northeast: northeast);
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  void _drawLine(WidgetRef ref, LatLng start, LatLng end) async {
    var polyline = Polyline(
      polylineId: PolylineId('line${DateTime.now()}'),
      visible: true,
      points: [start, end],
      color: Colors.deepOrangeAccent,
      width: 2,
      geodesic: true,
    );
    ref.read(linesProvider.notifier).state = {polyline};
  }
}
