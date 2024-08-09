import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ais_visualizer/providers/draw_on_map_provider.dart';

class DrawOnMapComponent extends StatefulWidget {
  @override
  State<DrawOnMapComponent> createState() => _DrawOnMapComponentState();
}

class _DrawOnMapComponentState extends State<DrawOnMapComponent> {
  static Completer<GoogleMapController> _controller = Completer();

  late double _latvalue;
  late double _longvalue;
  late double _tiltvalue;
  late double _bearingvalue;
  late LatLng _center;

  final Set<Polygon> _polygons = HashSet<Polygon>();
  final Set<Polyline> _polyLines = HashSet<Polyline>();

  bool _drawPolygonEnabled = false;
  final List<LatLng> _userPolyLinesLatLngList = [];
  bool _clearDrawing = false;
  int? _lastXCoordinate, _lastYCoordinate;

  @override
  void initState() {
    super.initState();
    _controller = Completer();
    _latvalue = 67.26;
    _longvalue = 18.38;
    _tiltvalue = 0;
    _bearingvalue = 0;
    _center = LatLng(_latvalue, _longvalue);
  }

  @override
  void dispose() {
    super.dispose();
    _controller = Completer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (_drawPolygonEnabled) ? _onPanUpdate : null,
        onPanEnd: (_drawPolygonEnabled) ? _onPanEnd : null,
        child: Consumer<DrawOnMapProvider>(
            builder: (context, drawOnMapProvider, child) {
          if (drawOnMapProvider.polyLinesLatLngList.isEmpty &&
              !drawOnMapProvider.isDrawing) {
            _polyLines.clear();
          }
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 6,
              bearing: _bearingvalue,
              tilt: _tiltvalue,
            ),
            polygons: drawOnMapProvider.polyLinesLatLngList.isEmpty
                ? <Polygon>{}
                : _polygons,
            polylines: _polyLines,
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
          );
        }),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(right: 210),
        child: FloatingActionButton(
          onPressed: _toggleDrawing,
          tooltip: 'Drawing',
          child: Icon((_drawPolygonEnabled) ? Icons.cancel : Icons.edit),
        ),
      ),
    );
  }

  _toggleDrawing() {
    _clearPolygons();
    setState(() => _drawPolygonEnabled = !_drawPolygonEnabled);
  }

  _onPanUpdate(DragUpdateDetails details) async {
    if (_clearDrawing) {
      _clearDrawing = false;
      _clearPolygons();
    }

    if (_drawPolygonEnabled) {
      double? x, y;
      if (Platform.isAndroid) {
        int pixRatio = MediaQuery.of(context).devicePixelRatio.toInt();
        x = details.localPosition.dx * pixRatio;
        y = details.localPosition.dy * pixRatio;
      } else if (Platform.isIOS) {
        x = details.localPosition.dx;
        y = details.localPosition.dy;
      }

      int xCoordinate = x!.round();
      int yCoordinate = y!.round();

      if (_lastXCoordinate != null && _lastYCoordinate != null) {
        var distance = math.sqrt(math.pow(xCoordinate - _lastXCoordinate!, 2) +
            math.pow(yCoordinate - _lastYCoordinate!, 2));
        if (distance > 80.0) return;
      }

      _lastXCoordinate = xCoordinate;
      _lastYCoordinate = yCoordinate;

      ScreenCoordinate screenCoordinate =
          ScreenCoordinate(x: xCoordinate, y: yCoordinate);

      final GoogleMapController controller = await _controller.future;
      LatLng latLng = await controller.getLatLng(screenCoordinate);

      try {
        if (_userPolyLinesLatLngList.length > 1 && _doesLineIntersect(latLng)) {
          // Intersection detected, ignore this point
          return;
        }

        _userPolyLinesLatLngList.add(latLng);

        _polyLines.removeWhere(
            (polyline) => polyline.polylineId.value == 'user_polyline');
        _polyLines.add(
          Polyline(
            polylineId: PolylineId('user_polyline'),
            points: _userPolyLinesLatLngList,
            width: 5,
            color: Colors.blue,
          ),
        );
      } catch (e) {
        print(" error painting $e");
      }
      setState(() {});
    }
  }

  bool _doesLineIntersect(LatLng newPoint) {
    for (int i = 0; i < _userPolyLinesLatLngList.length - 2; i++) {
      LatLng a = _userPolyLinesLatLngList[i];
      LatLng b = _userPolyLinesLatLngList[i + 1];
      LatLng c = _userPolyLinesLatLngList.last;
      LatLng d = newPoint;

      if (_doLinesIntersect(a, b, c, d)) {
        return true;
      }
    }
    return false;
  }

  bool _doLinesIntersect(LatLng p1, LatLng q1, LatLng p2, LatLng q2) {
    // Use orientation test to determine if two line segments intersect
    int o1 = _orientation(p1, q1, p2);
    int o2 = _orientation(p1, q1, q2);
    int o3 = _orientation(p2, q2, p1);
    int o4 = _orientation(p2, q2, q1);

    if (o1 != o2 && o3 != o4) {
      return true;
    }

    // Collinear cases
    if (o1 == 0 && _onSegment(p1, p2, q1)) return true;
    if (o2 == 0 && _onSegment(p1, q2, q1)) return true;
    if (o3 == 0 && _onSegment(p2, p1, q2)) return true;
    if (o4 == 0 && _onSegment(p2, q1, q2)) return true;

    return false;
  }

  int _orientation(LatLng p, LatLng q, LatLng r) {
    double val = (q.longitude - p.longitude) * (r.latitude - q.latitude) -
        (q.latitude - p.latitude) * (r.longitude - q.longitude);

    if (val == 0) return 0; // collinear
    return (val > 0) ? 1 : 2; // clock or counterclockwise
  }

  bool _onSegment(LatLng p, LatLng q, LatLng r) {
    if (q.longitude <= math.max(p.longitude, r.longitude) &&
        q.longitude >= math.min(p.longitude, r.longitude) &&
        q.latitude <= math.max(p.latitude, r.latitude) &&
        q.latitude >= math.min(p.latitude, r.latitude)) {
      return true;
    }
    return false;
  }

  _onPanEnd(DragEndDetails details) async {
    _lastXCoordinate = null;
    _lastYCoordinate = null;

    if (_drawPolygonEnabled) {
      _polygons
          .removeWhere((polygon) => polygon.polygonId.value == 'user_polygon');
      _polygons.add(
        Polygon(
          polygonId: PolygonId('user_polygon'),
          points: _userPolyLinesLatLngList,
          strokeWidth: 5,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.4),
        ),
      );

      final drawOnMapProvider =
          Provider.of<DrawOnMapProvider>(context, listen: false);
      _userPolyLinesLatLngList.add(_userPolyLinesLatLngList.first);
      drawOnMapProvider.addPolyLineLatLng(_userPolyLinesLatLngList
          .map((latLng) => LatLng(latLng.latitude, latLng.longitude))
          .toList());

      setState(() {
        _clearDrawing = true;
      });
    }
  }

  _clearPolygons() {
    setState(() {
      _polyLines.clear();
      _polygons.clear();
      _userPolyLinesLatLngList.clear();
    });
    final drawOnMapProvider =
        Provider.of<DrawOnMapProvider>(context, listen: false);
    drawOnMapProvider.addPolyLineLatLng([]);
  }
}
