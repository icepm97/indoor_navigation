import 'dart:math';

import 'package:flutter/material.dart';
import 'package:indoor_navigation/mapbox/map_control.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapPage extends StatelessWidget {
  MapPage({Key? key}) : super(key: key);

  MapboxMapController? mapController;
  MapControl? map;

  final String token =
      'pk.eyJ1IjoiY2xvdWQta2l0Y2hlbi1zbCIsImEiOiJjbDFjZzQ2cWUwN2IyM2NueDM5cmNrMDhuIn0.AHe3WiRUdrp43gol5NPmuA';
  final String style =
      'mapbox://styles/cloud-kitchen-sl/cl1s64g8w009314o9kilycump';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        accessToken: token,
        styleString: style,
        initialCameraPosition: const CameraPosition(
          zoom: 18.0,
          target: LatLng(6.904996, 79.868385),
          bearing: 0,
          tilt: 0,
        ),
        onMapCreated: (controller) async {
          mapController = controller;
          map = await MapControl.create(controller);
        },
        onStyleLoadedCallback: () {
          map?.init();
        },
      ),
    );
  }
}
