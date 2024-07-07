import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:ais_visualizer/models/kml/look_at_kml_model.dart';
import 'package:ais_visualizer/models/kml/vessels_kml_model.dart';
import 'package:ais_visualizer/models/vessel_sampled_model.dart';
import 'package:ais_visualizer/providers/lg_connection_status_provider.dart';
import 'package:ais_visualizer/providers/route_tracker_state_provider.dart';
import 'package:ais_visualizer/providers/selected_vessel_provider.dart';
import 'package:ais_visualizer/services/ais_data_service.dart';
import 'package:ais_visualizer/services/lg_service.dart';
import 'package:ais_visualizer/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart'
    as cluster_manager;

class MapComponent extends StatefulWidget {
  @override
  State<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  Map<int, VesselSampled> samplesMap = {};
  List<VesselSampled> selectedVesselTrack = [];
  Timer? markerTimer;
  int markerIndex = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isUplaoding = false;
  double _selectedLat = 0.0;
  double _selectedLng = 0.0;
  double _selectedCog = 0.0;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  late GoogleMapController _mapController;
  double _zoomvalue = 591657550.500000 / pow(2, 13.15393352508545);
  late double _latvalue;
  late double _longvalue;
  late double _tiltvalue;
  late double _bearingvalue;
  late LatLng _center;

  late cluster_manager.ClusterManager _manager;
  Set<Marker> _markers = {};
  Set<Marker> _clusterdMarkers = {};
  Set<Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();
    addCustomIcon();
    _initClusterManager();
    fetchInitialData();
    //_loadPolygons();
    _latvalue = 65.26;
    _longvalue = 23.38;
    _tiltvalue = 0;
    _bearingvalue = 0;
    _center = LatLng(_latvalue, _longvalue);
  }

  Future<void> _loadPolygons() async {
    List<List<LatLng>> polygons = await drawAisAreaPolygone();
    
    setState(() {
      _polygons.clear();
      _polygons.addAll(polygons.map((points) => Polygon(
        polygonId: PolygonId('polygon_id_${polygons.indexOf(points)}'),
        points: points,
        strokeWidth: 2,
        strokeColor: const Color.fromARGB(255, 243, 33, 107),
        fillColor: Color.fromARGB(0, 0, 0, 0).withOpacity(0.3),
      )).toSet());
    });
  }

  Future<List<List<LatLng>>> drawAisAreaPolygone() async {
    String jsonContent = await rootBundle.loadString('assets/data/open_ais_area.json');
    Map<String, dynamic> jsonData = json.decode(jsonContent);
    
    List<dynamic> coordinates = jsonData['coordinates'][0][0];
    List<List<LatLng>> polygons = [];
    
    for (var polygonCoordinates in coordinates) {
      double lat = polygonCoordinates[1].toDouble();
      double lng = polygonCoordinates[0].toDouble();
      polygons.add([LatLng(lat, lng)]);
    }
    
    return polygons;
  }

  void _initClusterManager() {
    _manager = cluster_manager.ClusterManager<VesselSampled>(
      [],
      _updateMarkers,
      markerBuilder: _markerBuilder,
    );
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  void _onClusterUpdate() {
    _manager.setItems(samplesMap.values.toList());
  }

  Future<Marker> Function(dynamic) get _markerBuilder =>
      (dynamic cluster) async {
        final c = cluster as cluster_manager.Cluster<VesselSampled>;
        return Marker(
          markerId: MarkerId(c.getId()),
          position: c.location,
          icon: await _getMarkerBitmap(c.isMultiple ? 75 : 50,
              text: c.isMultiple ? c.count.toString() : '1'),
          onTap: () {
            if (c.isMultiple) {
              // Show all items in the cluster
              _showClusterItems(c.items, c);
            } else {
              // Handle single item tap
              updateSelectedVessel(c.items.first.mmsi!);
            }
          },
        );
      };

  void _showClusterItems(Iterable<VesselSampled> items, dynamic c) {
    Set<Marker> newMarkers = {};
    for (var item in items) {
      newMarkers.add(Marker(
        markerId: MarkerId(item.mmsi.toString()),
        position: LatLng(item.latitude!, item.longitude!),
        rotation: item.courseOverGround ?? 0,
        icon: markerIcon,
        onTap: () => updateSelectedVessel(item.mmsi!),
      ));
    }
    if(_clusterdMarkers.isEmpty) {
      _clusterdMarkers.addAll(_markers);
    }
    setState(() {
      _markers.clear();
      _markers.addAll(newMarkers);
      _markers.addAll(_clusterdMarkers);
      _markers.removeWhere((marker) => marker.markerId == MarkerId(c.getId()));
    });
  }

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Color.fromARGB(255, 154,60,52);

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(canvas,
          Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2));
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/img/vessel_marker_large.png")
        .then(
      (icon) {
        setState(() {
          print("Icon added");
          markerIcon = icon;
        });
      },
    );
  }

  void fetchInitialData() async {
    try {
      final vessels = await AisDataService().fetchInitialData();
      print("DOOOOOOOOOOOOONEEEEEEEEEEEEEEEEE FEEEEEEETCHHHHHHIIIIIINGGGGGGG");
      setState(() {
        for (var sample in vessels) {
          samplesMap[sample.mmsi!] = sample;
        }
      });
      _onClusterUpdate();
      connectToSSE();
    } catch (e) {
      print('Exception during initial data fetch: $e');
    }
  }

  void connectToSSE() {
    AisDataService().streamVesselsData().listen(
      (sample) {
        setState(() {
          samplesMap[sample.mmsi!] = sample;
        });
      },
      onError: (error) {
        print('Error occurred: $error');
      },
      cancelOnError: true,
    );
  }

  // for map sync
  motionControls(double updownflag, double rightleftflag, double zoomflag,
      double tiltflag, double bearingflag) async {
    LookAtKmlModel flyto = LookAtKmlModel(
      lng: rightleftflag,
      lat: updownflag,
      range: zoomflag.toString(),
      tilt: tiltflag.toString(),
      heading: bearingflag.toString(),
    );
    try {
      await LgService().flyTo(flyto.linearTag);
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  void _onCameraMove(CameraPosition position) {
    _bearingvalue = position.bearing;
    _longvalue = position.target.longitude;
    _latvalue = position.target.latitude;
    _tiltvalue = position.tilt;
    _zoomvalue = 591657550.500000 / pow(2, position.zoom);
    _manager.onCameraMove;
  }

  void _onCameraIdle() {
    int rigcount = LgService().getScreenNumber();
    motionControls(_latvalue, _longvalue, _zoomvalue / rigcount, _tiltvalue,
        _bearingvalue);
    _manager.updateMap;
  }

  void _onMapCreated(GoogleMapController mapController) {
    _mapController = mapController;
    _manager.setMapId(mapController.mapId);
  }

  Future<void> fetchTrackDataForSelectedDates(
    int mmsi,
    String startDate,
    String endDate,
  ) async {
    final routeTrackerStateProvider =
        Provider.of<RouteTrackerState>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      routeTrackerStateProvider.toggleIsFetching(true);
    });
    try {
      print('Fetched track data for MMSI: $mmsi');
      final track = await AisDataService().fetchHistoricTrackData(
        mmsi,
        startDate,
        endDate,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        routeTrackerStateProvider.toggleIsFetching(false);
        print('Doooooneeeeeeeee for state provider!!!!!!!!');
      });
      print('Doooooneeeeeeeee');
      setState(() {
        markerIndex = 0;
        selectedVesselTrack = track.reversed.toList();
      });
    } catch (e) {
      print('Exception during track data fetch: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        routeTrackerStateProvider.toggleIsFetching(false);
      });
    }
  }

  void updateSelectedVessel(int mmsi) {
    resetMapComponents();
    final selectedVesselProvider =
        Provider.of<SelectedVesselProvider>(context, listen: false);
    selectedVesselProvider.updateSelectedVessel(mmsi);
    final trackSatateProvider =
        Provider.of<RouteTrackerState>(context, listen: false);
    trackSatateProvider.resetState();
    _selectedLat = samplesMap[mmsi]!.latitude!;
    _selectedLng = samplesMap[mmsi]!.longitude!;
    _selectedCog = samplesMap[mmsi]!.courseOverGround!;
  }

  void startMarkerAnimation() {
    final routeTrackerStateProvider =
        Provider.of<RouteTrackerState>(context, listen: false);

    if (markerTimer != null && markerTimer!.isActive) {
      markerTimer!.cancel();
    }

    const markerUpdateInterval = Duration(milliseconds: 20);
    markerTimer = Timer.periodic(markerUpdateInterval, (timer) {
      setState(() {
        if (selectedVesselTrack.isNotEmpty &&
            routeTrackerStateProvider.isPlaying) {
          markerIndex = (markerIndex + 1) % selectedVesselTrack.length;
          double normalizedPosition =
              -1.0 + (2.0 * markerIndex / (selectedVesselTrack.length - 1));
          routeTrackerStateProvider.setCurrentPosition(normalizedPosition);
          print(
              'Marker index: $markerIndex, Normalized position: $normalizedPosition');
        }
      });
    });
  }

  void stopMarkerAnimation() {
    if (markerTimer != null && markerTimer!.isActive) {
      markerTimer!.cancel();
    }
  }

  void resetMarkerAnimation() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      print('Resetting marker animation or stopping');
      setState(() {
        markerIndex = 0;
      });
    });
  }

  void fetchTrackDataFromProviderDates() {
    final routeTrackerStateProvider =
        Provider.of<RouteTrackerState>(context, listen: false);
    final selectedVesselProvider =
        Provider.of<SelectedVesselProvider>(context, listen: false);

    final startDate = routeTrackerStateProvider.startDate;
    final endDate = routeTrackerStateProvider.endDate;

    if (_startDate != startDate || _endDate != endDate) {
      _startDate = startDate;
      _endDate = endDate;

      if (startDate != null && endDate != null) {
        print('Fetching track data for selected dates');
        final formattedStartDate = startDate.toUtc().toIso8601String();
        final formattedEndDate = endDate.toUtc().toIso8601String();
        fetchTrackDataForSelectedDates(selectedVesselProvider.selectedMMSI,
            formattedStartDate, formattedEndDate);
      }
    }
  }

  Future<void> showVesselsOnLG() async {
    print('Uploading vessels to LG from map');
    if (samplesMap.isEmpty) {
      _isUplaoding = false;
      return;
    }
    VesselKmlModel kmlModel =
        VesselKmlModel(vessels: samplesMap.values.toList());
    final kmlFile = await createFile('vessels.kml', kmlModel.generateKml());
    await LgService().uploadKml(kmlFile, 'vessels.kml');
    print("UHGHHH");
    _isUplaoding = false;
  }

  void resetMapComponents() {
    setState(() {
      selectedVesselTrack.clear();
      markerIndex = 0;
      _startDate = null;
      _endDate = null;
      if (markerTimer != null && markerTimer!.isActive) {
        markerTimer!.cancel();
      }
    });
  }

  Set<Marker> _buildMarkers() {
    final routeTrackerStateProvider =
        Provider.of<RouteTrackerState>(context, listen: false);

    if (routeTrackerStateProvider.showVesselRoute) {
      final selectedVesselMarker = _buildSelectedVesselMarker();
      final lastPositionMarker = _buildSelectedVesselPositionMarker();
      return selectedVesselMarker != null
          ? {selectedVesselMarker, lastPositionMarker!}
          : {lastPositionMarker!};
    } else {
      return samplesMap.values.map((sample) {
        return Marker(
          markerId: MarkerId(sample.mmsi.toString()),
          position: LatLng(sample.latitude!, sample.longitude!),
          rotation: sample.courseOverGround ?? 0,
          zIndex: 0.0,
          onTap: () {
            updateSelectedVessel(sample.mmsi!);
          },
          //icon: markerIcon,
        );
      }).toSet();
    }
  }

  Set<Polyline> _buildPolylines() {
    final routeTrackerStateProvider =
        Provider.of<RouteTrackerState>(context, listen: false);

    if (routeTrackerStateProvider.showVesselRoute &&
        selectedVesselTrack.isNotEmpty) {
      print("Building polylines");
      return {
        Polyline(
          polylineId: PolylineId('route'),
          points: selectedVesselTrack
              .map((sample) => LatLng(sample.latitude!, sample.longitude!))
              .toList(),
          width: 4,
          zIndex: 1,
          startCap: Cap.roundCap,
          endCap: Cap.buttCap,
        ),
      };
    }
    return {};
  }

  Marker? _buildSelectedVesselMarker() {
    if (selectedVesselTrack.isEmpty) {
      return null;
    }
    final selectedSample = selectedVesselTrack[markerIndex];
    return Marker(
      markerId: MarkerId('selected_vessel'),
      position: LatLng(selectedSample.latitude!, selectedSample.longitude!),
      rotation: selectedSample.courseOverGround ?? 0,
      //icon: markerIcon,
    );
  }

  Marker? _buildSelectedVesselPositionMarker() {
    return Marker(
      markerId: MarkerId('last_position_vessel'),
      position: LatLng(_selectedLat, _selectedLng),
      rotation: _selectedCog,
      //icon: markerIcon,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectionStatusProvider =
        Provider.of<LgConnectionStatusProvider>(context);
    final isConnected = connectionStatusProvider.isConnected;

    return Consumer<RouteTrackerState>(builder: (context, state, child) {
      fetchTrackDataFromProviderDates();

      if (isConnected && !_isUplaoding) {
        print("hiiiiiiiiiiii");
        _isUplaoding = true;
        showVesselsOnLG();
      }

      if (state.isPlaying) {
        startMarkerAnimation();
      } else {
        stopMarkerAnimation();
      }
      if (state.currentPosition == -1) {
        resetMarkerAnimation();
      }

      //final markers = _buildMarkers();
      if (_markers.isEmpty == false) print(_markers.first.mapsId);
      final polylines = _buildPolylines();

      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 5,
          bearing: _bearingvalue,
          tilt: _tiltvalue,
        ),
        polylines: polylines,
        markers: _markers,
        //polygons: _polygons,
        circles: {
          Circle(
            circleId: CircleId('selected_vessel'),
            center: LatLng(_selectedLat, _selectedLng),
            radius: 430,
            fillColor: Color.fromARGB(182, 0, 0, 0).withOpacity(0.1),
            strokeWidth: 0,
          ),
        },
        tiltGesturesEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        onCameraMove: _onCameraMove,
        onCameraIdle: _onCameraIdle,
        onMapCreated: _onMapCreated,
      );
    });
  }
}
