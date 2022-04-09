import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapPage extends StatelessWidget {
  MapPage({Key? key}) : super(key: key);

  MapboxMapController? mapController;

  final String token =
      'pk.eyJ1IjoiY2xvdWQta2l0Y2hlbi1zbCIsImEiOiJjbDFjZzQ2cWUwN2IyM2NueDM5cmNrMDhuIn0.AHe3WiRUdrp43gol5NPmuA';
  final String style = 'mapbox://styles/mapbox/light-v10';

  void onFeatureTap(dynamic featureId, Point<double> point, LatLng latLng) {
    print(featureId);
    print(point);
    // Get.snackbar("Feature Tapped", featureId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: MapboxMap(
      //   accessToken: token,
      //   styleString: style,
      //   initialCameraPosition: const CameraPosition(
      //     zoom: 18.0,
      //     target: LatLng(49.867630660511715, 10.89075028896332),
      //     bearing: 0,
      //     tilt: 0,
      //   ),
      // ),
      body: MapboxMap(
        accessToken: token,
        styleString: style,
        initialCameraPosition: const CameraPosition(
          zoom: 18.0,
          target: LatLng(6.796899, 79.900451),
          bearing: 0,
          tilt: 0,
        ),
        onMapCreated: (controller) {
          mapController = controller;
          controller.onFeatureTapped.add(onFeatureTap);
        },
        onStyleLoadedCallback: () {
          mapController?.addSource(
              'floorplan',
              const GeojsonSourceProperties(
                  data:
                      "https://api.mapbox.com/datasets/v1/cloud-kitchen-sl/cl1m3m344240v28lbgp08gvwk/features?access_token=pk.eyJ1IjoiY2xvdWQta2l0Y2hlbi1zbCIsImEiOiJjbDFjZzQ2cWUwN2IyM2NueDM5cmNrMDhuIn0.AHe3WiRUdrp43gol5NPmuA"));

          mapController?.addLayer(
              "floorplan",
              "room-extrusion",
              const FillLayerProperties(
                fillOpacity: 0.5,
                fillColor: "violet",
              ));
          mapController!.addSymbol(const SymbolOptions(
            textAnchor: "top",
            textField: "Hello",
            geometry: LatLng(6.796899, 79.900451),
          ));
        },
      ),
    );
  }
}
