import 'dart:collection';
import 'dart:math';

import 'package:indoor_navigation/mapbox/a_star.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class PathNode extends Object with Node<PathNode> {
  LatLng coordinate;
  String? name;
  List<List<LatLng>>? stallPoly;
  Fill? stallFill;

  PathNode(this.coordinate, this.name);
}

class PathGraph extends Graph<PathNode> {
  Map<LatLng, PathNode> nodesByCoord = {};
  Map<String, PathNode> nodesByName = {};
  Map<PathNode, Set<PathNode>> graph = {};

  late AStar pathFinder;

  PathGraph(
    Map<String, LatLng> pathPoints,
    List<List<LatLng>> pathLines,
    Map<String, List<List<LatLng>>> stallPolys,
  ) {
    pathPoints.forEach((key, value) {
      PathNode node = PathNode(value, key);
      nodesByCoord[value] = node;
      nodesByName[key] = node;
      graph[node] = {};
    });

    stallPolys.forEach((key, value) {
      nodesByName[key]?.stallPoly = value;
    });

    for (var pathLine in pathLines) {
      var nodeA = nodesByCoord[pathLine.first];
      var nodeB = nodesByCoord[pathLine.last];
      if (pathLine.length == 2 && nodeA != null && nodeB != null) {
        graph[nodeA]!.add(nodeB);
        graph[nodeB]!.add(nodeA);
      } else {
        print(pathLine);
        print("invalid path line segment");
      }
    }

    pathFinder = AStar<PathNode>(this);
  }

  double calculateDistance(LatLng p1, LatLng p2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((p2.latitude - p1.latitude) * p) / 2 +
        c(p1.latitude * p) *
            c(p2.latitude * p) *
            (1 - c((p2.longitude - p1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Iterable<PathNode> get allNodes => graph.keys;

  @override
  num getDistance(PathNode a, PathNode b) {
    if (graph[a]?.contains(b) == true) {
      return calculateDistance(a.coordinate, b.coordinate);
    }
    return double.infinity;
  }

  @override
  num getHeuristicDistance(PathNode a, PathNode b) {
    return calculateDistance(a.coordinate, b.coordinate);
  }

  @override
  Iterable<PathNode> getNeighboursOf(PathNode node) {
    return graph[node]?.toList() ?? [];
  }

  Future<Queue<PathNode>> findPathByName(String start, String goal) async {
    var nodeA = nodesByName[start];
    var nodeB = nodesByName[goal];
    if (nodeA != null && nodeB != null) {
      return await pathFinder.findPath(nodeA, nodeB) as Queue<PathNode>;
    }
    return Queue();
  }

  Future<Queue<PathNode>> findPath(PathNode? start, PathNode? goal) async {
    if (start != null && goal != null) {
      return await pathFinder.findPath(start, goal) as Queue<PathNode>;
    }
    return Queue();
  }
}
