import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:indoor_navigation/mapbox/map_colors.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapControl {
  MapboxMapController controller;

  dynamic geoJson;
  // List<List<LatLng>> wallLines;
  // List<List<LatLng>> pathLines;
  // Map<String, List<List<LatLng>>> stallPolys;
  // Map<String, LatLng> stallPoints;

  // Fill? selectedStall;
  // LatLng currentLoc;

  MapControl._create(
    this.geoJson,
    this.controller,
    // this.wallLines,
    // this.pathLines,
    // this.stallPolys,
    // this.stallPoints,
    // this.currentLoc,
  );

  static Future<MapControl> create(MapboxMapController controller) async {
    var geoJson = jsonDecode(await rootBundle.loadString("assets/map.geojson"));

    List<List<LatLng>> wallLines = [];
    List<List<LatLng>> pathLines = [];
    Map<String, List<List<LatLng>>> stallPolys = {};
    Map<String, LatLng> pathPoints = {};
    // Map<String, LatLng> stallPoints = {};

    for (var feature in geoJson["features"]) {
      if (feature["geometry"]["type"] == "LineString") {
        if (feature["properties"]["type"] == "wall") {
          wallLines
              .add(parseCoordinateLines(feature["geometry"]["coordinates"]));
        }
        if (feature["properties"]["type"] == "path") {
          pathLines
              .add(parseCoordinateLines(feature["geometry"]["coordinates"]));
        }
      }

      if (feature["geometry"]["type"] == "Polygon") {
        if (feature["properties"]["type"] == "stall") {
          stallPolys[feature["properties"]["name"]] =
              parseCoordinatePolys(feature["geometry"]["coordinates"]);
        }
      }

      if (feature["geometry"]["type"] == "Point") {
        if (["stall", "path", "entrance"]
            .contains(feature["properties"]["type"])) {
          pathPoints[feature["properties"]["name"]] =
              parseCoordinate(feature["geometry"]["coordinates"]);
        }
        // if (feature["properties"]["type"] == "stall") {
        //   stallPoints[feature["properties"]["name"]] =
        //       parseCoordinate(feature["geometry"]["coordinates"]);
        // }
      }
    }
    return MapControl._create(
      geoJson,
      controller,
      // wallLines,
      // pathLines,
      // stallPolys,
      // stallPoints,
      // pathPoints.first,
    );
  }

  static LatLng parseCoordinate(List<dynamic> cd) {
    return LatLng(cd[1], cd[0]);
  }

  static List<LatLng> parseCoordinateLines(List<dynamic> cds) {
    return cds.map((e) => parseCoordinate(e)).toList();
  }

  static List<List<LatLng>> parseCoordinatePolys(List<dynamic> cds) {
    return cds.map((e) => parseCoordinateLines(e)).toList();
  }

  init() async {
    // addWalls();
    // addStores();
    // addStoreLabels();
  }

  // addWalls() {
  //   for (var walls in wallLines) {
  //     controller.addLine(LineOptions(
  //       geometry: walls,
  //       lineColor: MapColors.wall,
  //       draggable: false,
  //     ));
  //   }
  // }

  // addStores() async {
  //   for (var stall in stallPolys.values) {
  //     controller.addFill(FillOptions(
  //       draggable: false,
  //       geometry: stall,
  //       fillColor: MapColors.stall,
  //       fillOutlineColor: MapColors.stallOutline,
  //       fillOpacity: 0.5,
  //     ));
  //   }
  //   controller.onFillTapped.add((fill) {
  //     var oldStall = selectedStall;
  //     selectedStall = fill;
  //     if (oldStall != null) {
  //       controller.updateFill(
  //           oldStall,
  //           const FillOptions(
  //             fillColor: MapColors.stall,
  //           ));
  //     }
  //     controller.updateFill(
  //         fill,
  //         const FillOptions(
  //           fillColor: MapColors.stallSelected,
  //         ));
  //   });
  // }

  // addStoreLabels() {
  //   stallPoints.forEach((key, value) {
  //     controller.addSymbol(SymbolOptions(
  //       draggable: false,
  //       textAnchor: "top",
  //       textField: key,
  //       geometry: value,
  //       textColor: MapColors.label,
  //     ));
  //   });
  // }
}
