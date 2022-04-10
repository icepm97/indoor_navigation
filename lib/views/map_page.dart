import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:indoor_navigation/mapbox/map.controller.dart';
import 'package:indoor_navigation/views/widgets/app_drawer.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapPage extends StatelessWidget {
  MapPage({Key? key}) : super(key: key);

  MapboxMapController? mapboxController;
  final MapController mapController = Get.find<MapController>();

  final String token =
      'pk.eyJ1IjoiY2xvdWQta2l0Y2hlbi1zbCIsImEiOiJjbDFjZzQ2cWUwN2IyM2NueDM5cmNrMDhuIn0.AHe3WiRUdrp43gol5NPmuA';
  final String style =
      'mapbox://styles/cloud-kitchen-sl/cl1s64g8w009314o9kilycump';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indoor Navigation'),
      ),
      drawer: appDrawer(),
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
          mapboxController = controller;
        },
        onStyleLoadedCallback: () {
          mapController.init(mapboxController!);
        },
      ),
    );
  }
}
