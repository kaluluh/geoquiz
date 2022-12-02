import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../common/page_wrapper.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> controllerCompleter = Completer();

    return PageWrapper(
      backgroundColor: Colors.white,
      child: _buildContent(context, controllerCompleter),
    );
  }

  Widget _buildContent(BuildContext context, Completer<GoogleMapController> controllerCompleter) {
    return FutureBuilder(
      future: rootBundle.loadString('assets/map/styles/labelless.json'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 1,
            ),
            onMapCreated: (GoogleMapController controller) {
              controllerCompleter.complete(controller);
              controller.setMapStyle(snapshot.data.toString());
            },
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            trafficEnabled: false,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
