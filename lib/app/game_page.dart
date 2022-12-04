import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoquiz/app/game_page/bottom_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../common/page_wrapper.dart';
import '../game/game_controller.dart';

final selectedLatProvider = StateProvider<double>((ref) => 0.0);
final selectedLongProvider = StateProvider<double>((ref) => 0.0);
final markerPlacedProvider = StateProvider<bool>((ref) => false);
final markersProvider = StateProvider<Set<Marker>>((ref) => {});
final linesProvider = StateProvider<Set<Polyline>>((ref) => {});
final lastGuessProvider = StateProvider<GuessInfo?>((ref) => null);

class GamePage extends ConsumerWidget {
  GamePage({Key? key, required this.gameType, required this.gameDifficulty}) : super(key: key);

  final GameType gameType;
  final GameDifficulty gameDifficulty;

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
    var gameState = ref.watch(gameControllerProvider).gameState;
    return PageWrapper(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: _buildMap(context, ref, markers, lines),
          ),
          Expanded(
            flex: gameState == GameState.notStarted ? 1000 : 0,
            child: GameBottomBar(
              gameType: gameType,
              gameDifficulty: gameDifficulty,
              guessAction: () => guessAction(ref),
            ),
          ),
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
        ref.read(markerPlacedProvider.notifier).state = true;
        _updateGuessMarker(ref, latLng, visible: true);
      },
      markers: markers,
      polylines: lines,
    );
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

  void guessAction(WidgetRef ref) {
    var guessInfo = ref.read(gameControllerProvider.notifier).guess(
      ref.read(selectedLatProvider),
      ref.read(selectedLongProvider),
    );
    ref.read(lastGuessProvider.notifier).state = guessInfo;
    _showActualPositionMarker(ref, guessInfo.actual);
    _zoomToMarkers(ref);
    _drawLine(ref, guessInfo.guess, guessInfo.actual);
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
