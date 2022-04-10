import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:indoor_navigation/mapbox/map_colors.dart';
import 'package:indoor_navigation/mapbox/path_graph.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapController extends GetxController {
  MapboxMapController? controller;

  dynamic geoJson;
  PathGraph graph;
  List<List<LatLng>> wallLines;

  Fill? selectedStall;
  Circle? currentLoc;
  Line? currentPath;
  String nextLocName = "Entrance 1";

  MapController._create(
    this.geoJson,
    this.graph,
    this.wallLines,
  );

  static Future<MapController> create() async {
    var geoJson = jsonDecode(await rootBundle.loadString("assets/map.geojson"));

    List<List<LatLng>> wallLines = [];
    List<List<LatLng>> pathLines = [];
    Map<String, List<List<LatLng>>> stallPolys = {};
    Map<String, LatLng> pathPoints = {};

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
      }
    }

    PathGraph graph = PathGraph(pathPoints, pathLines, stallPolys);

    return MapController._create(
      geoJson,
      graph,
      wallLines,
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

  init(MapboxMapController controller) async {
    this.controller = controller;

    addWalls();
    addStalls();
    addStallLabels();

    changeCurrentLoc();

    // print(await graph.findPathByName("Entrance 1", "Stall 5"));
    // for (var node in await graph.findPathByName("Entrance 1", "Stall 10")) {
    //   print(node.name);
    // }
  }

  addWalls() {
    for (var walls in wallLines) {
      controller?.addLine(LineOptions(
        geometry: walls,
        lineColor: MapColors.wall,
        draggable: false,
      ));
    }
  }

  addStalls() async {
    for (var node in graph.allNodes) {
      if (node.stallPoly != null) {
        controller
            ?.addFill(FillOptions(
              draggable: false,
              geometry: node.stallPoly,
              fillColor: MapColors.stall,
              fillOutlineColor: MapColors.stallOutline,
              fillOpacity: 0.5,
            ))
            .then((value) => node.stallFill = value);
      }
    }
    controller?.onFillTapped.add((fill) {
      var oldStall = selectedStall;
      selectedStall = fill;
      if (oldStall != null) {
        controller?.updateFill(
            oldStall,
            const FillOptions(
              fillColor: MapColors.stall,
            ));
      }
      controller?.updateFill(
          fill,
          const FillOptions(
            fillColor: MapColors.stallSelected,
          ));
      showRoute();
    });
  }

  addStallLabels() {
    for (var node in graph.allNodes) {
      if (node.stallPoly != null && node.name != null) {
        controller?.addSymbol(SymbolOptions(
          draggable: false,
          textAnchor: "top",
          textField: node.name,
          geometry: node.coordinate,
          textColor: MapColors.label,
        ));
      }
    }
  }

  changeCurrentLoc() async {
    var oldLoc = currentLoc;

    if (oldLoc != null) {
      controller?.removeCircle(oldLoc);
    }

    currentLoc = await controller?.addCircle(CircleOptions(
      draggable: false,
      circleRadius: 10,
      circleColor: MapColors.currentLoc,
      geometry: graph.nodesByName[nextLocName]?.coordinate,
    ));
  }

  showRoute() async {
    var start = graph.nodesByCoord[currentLoc?.options.geometry];
    var goal = graph.allNodes
        .firstWhere((node) => node.stallFill?.id == selectedStall?.id);

    var path = await graph.findPath(start, goal);
    var oldPath = currentPath;

    if (oldPath != null) {
      controller?.removeLine(oldPath);
    }

    currentPath = await controller?.addLine(LineOptions(
      draggable: false,
      lineColor: MapColors.path,
      lineWidth: 3,
      geometry: path.map((node) => node.coordinate).toList(),
    ));
  }
}
