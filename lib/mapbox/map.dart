import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class Map {
  dynamic geoJson;
  MapboxMapController controller;
  List<List<LatLng>> wallLines;
  List<List<LatLng>> pathLines;
  List<List<List<LatLng>>> stallPolygons;

  Map._create(
    this.geoJson,
    this.controller,
    this.wallLines,
    this.pathLines,
    this.stallPolygons,
  );

  static Future<Map> create(MapboxMapController controller) async {
    var geoJson = jsonDecode(await rootBundle.loadString("assets/map.geojson"));

    List<List<LatLng>> wallLines = [];
    List<List<LatLng>> pathLines = [];
    List<List<List<LatLng>>> stallPolygons = [];

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
        // print(feature);
        if (feature["properties"]["type"] == "stall") {
          stallPolygons
              .add(parseCoordinatePolys(feature["geometry"]["coordinates"]));
        }
      }
    }
    return Map._create(
        geoJson, controller, wallLines, pathLines, stallPolygons);
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
    addWalls();
    addStores();
  }

  addWalls() {
    for (var walls in wallLines) {
      controller.addLine(LineOptions(
        geometry: walls,
        lineColor: "black",
        draggable: false,
      ));
    }
  }

  addStores() async {
    print(stallPolygons.first);
    for (var stall in stallPolygons) {
      controller.addFill(FillOptions(
        draggable: false,
        geometry: stall,
        fillColor: "#008888",
        fillOutlineColor: "#555555",
        fillOpacity: 0.5,
      ));
    }
    controller.onFillTapped.add((fill) {
      controller.updateFill(
          fill,
          const FillOptions(
            fillColor: "#880000",
          ));
    });
  }
}
