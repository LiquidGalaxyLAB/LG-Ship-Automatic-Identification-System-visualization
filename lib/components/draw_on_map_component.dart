import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart' as latlong2;
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
    // To start draw new polygon every time.
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

      // Round the x and y.
      int xCoordinate = x!.round();
      int yCoordinate = y!.round();

      // Check if the distance between last point is not too far.
      // to prevent two fingers drawing.
      if (_lastXCoordinate != null && _lastYCoordinate != null) {
        var distance = math.sqrt(math.pow(xCoordinate - _lastXCoordinate!, 2) +
            math.pow(yCoordinate - _lastYCoordinate!, 2));
        // Check if the distance of point and point is large.
        if (distance > 80.0) return;
      }

      // Cached the coordinate.
      _lastXCoordinate = xCoordinate;
      _lastYCoordinate = yCoordinate;

      ScreenCoordinate screenCoordinate =
          ScreenCoordinate(x: xCoordinate, y: yCoordinate);

      final GoogleMapController controller = await _controller.future;
      LatLng latLng = await controller.getLatLng(screenCoordinate);

      try {
        // Add new point to list.
        _userPolyLinesLatLngList.add(latLng);

        _polyLines.removeWhere(
            (polyline) => polyline.polylineId.value == 'user_polyline');
        _polyLines.add(
          Polyline(
            polylineId: PolylineId('user_polyline'),
            points: _userPolyLinesLatLngList,
            width: 5,
            color: Colors.red,
          ),
        );
      } catch (e) {
        print(" error painting $e");
      }
      setState(() {});
    }
  }

  _onPanEnd(DragEndDetails details) async {
    // Reset last cached coordinate
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
          strokeColor: Colors.red,
          fillColor: Colors.red.withOpacity(0.4),
        ),
      );

      final drawOnMapProvider =
          Provider.of<DrawOnMapProvider>(context, listen: false);
      drawOnMapProvider.addPolyLineLatLng(_userPolyLinesLatLngList
          .map((latLng) => latlong2.LatLng(latLng.latitude, latLng.longitude))
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
