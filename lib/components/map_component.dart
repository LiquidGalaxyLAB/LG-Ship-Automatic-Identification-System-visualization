import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:ais_visualizer/models/kml/about_ballon_kml_model.dart';
import 'package:ais_visualizer/models/kml/look_at_kml_model.dart';
import 'package:ais_visualizer/models/kml/multi_polygone_kml_model.dart';
import 'package:ais_visualizer/models/kml/orbit_path_placemark_kml_model.dart';
import 'package:ais_visualizer/models/kml/selected_vessel_kml_model.dart';
import 'package:ais_visualizer/models/kml/vessels_kml_model.dart';
import 'package:ais_visualizer/models/vessel_sampled_model.dart';
import 'package:ais_visualizer/providers/AIS_connection_status_provider.dart';
import 'package:ais_visualizer/providers/collision_provider.dart';
import 'package:ais_visualizer/providers/draw_on_map_provider.dart';
import 'package:ais_visualizer/providers/filter_region_provider.dart';
import 'package:ais_visualizer/providers/lg_connection_status_provider.dart';
import 'package:ais_visualizer/providers/route_prediction_state_provider.dart';
import 'package:ais_visualizer/providers/route_tracker_state_provider.dart';
import 'package:ais_visualizer/providers/selected_kml_file_provider.dart';
import 'package:ais_visualizer/providers/selected_types_provider.dart';
import 'package:ais_visualizer/providers/selected_vessel_provider.dart';
import 'package:ais_visualizer/services/ais_data_service.dart';
import 'package:ais_visualizer/services/lg_service.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
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
  bool _isUploading = false;
  bool _isFetching = false;
  double _selectedLat = 0.0;
  double _selectedLng = 0.0;
  double _selectedCog = 0.0;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  Set<Polyline> _polyLines = HashSet<Polyline>();

  late GoogleMapController _mapController;
  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

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
  late AisConnectionStatusProvider _aisConnectionStatusProvider;
  late LgConnectionStatusProvider _lgConnectionStatusProvider;
  late SelectedKmlFileProvider _selectedKmlFileProvider;
  late SelectedTypesProvider _selectedTypesProvider;
  late FilterRegionProvider _filterRegionProvider;
  late DrawOnMapProvider _drawOnMapProvider;
  late CollisionProvider _collisionProvider;
  bool _skipFlyTo = false;
  int _trackOrbitTimeInMilliseconds = 0;

  @override
  void initState() {
    super.initState();
    addCustomIcon();
    _initClusterManager();
    //_loadPolygons();
    _latvalue = 67.26;
    _longvalue = 18.38;
    _tiltvalue = 0;
    _bearingvalue = 0;
    _center = LatLng(_latvalue, _longvalue);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _aisConnectionStatusProvider =
          Provider.of<AisConnectionStatusProvider>(context, listen: false);
      _lgConnectionStatusProvider =
          Provider.of<LgConnectionStatusProvider>(context, listen: false);
      _selectedKmlFileProvider =
          Provider.of<SelectedKmlFileProvider>(context, listen: false);
      _selectedTypesProvider =
          Provider.of<SelectedTypesProvider>(context, listen: false);
      _filterRegionProvider =
          Provider.of<FilterRegionProvider>(context, listen: false);
      _drawOnMapProvider =
          Provider.of<DrawOnMapProvider>(context, listen: false);
      _collisionProvider =
          Provider.of<CollisionProvider>(context, listen: false);

      _aisConnectionStatusProvider.addListener(_onAisConnectionChange);
      _lgConnectionStatusProvider.addListener(_onLgConnectionChange);
      _selectedKmlFileProvider.addListener(_onKmlFileChange);
      _selectedTypesProvider.addListener(_onFilterChange);
      _filterRegionProvider.addListener(_onRegionChange);
      _collisionProvider.addListener(_onCollisionSelection);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _drawOnMapProvider = Provider.of<DrawOnMapProvider>(context, listen: false);
    _aisConnectionStatusProvider =
        Provider.of<AisConnectionStatusProvider>(context, listen: false);
    _lgConnectionStatusProvider =
        Provider.of<LgConnectionStatusProvider>(context, listen: false);
    _selectedKmlFileProvider =
        Provider.of<SelectedKmlFileProvider>(context, listen: false);
    _selectedTypesProvider =
        Provider.of<SelectedTypesProvider>(context, listen: false);
    _filterRegionProvider =
        Provider.of<FilterRegionProvider>(context, listen: false);
    _collisionProvider = Provider.of<CollisionProvider>(context, listen: false);

    _aisConnectionStatusProvider.addListener(_onAisConnectionChange);
    _lgConnectionStatusProvider.addListener(_onLgConnectionChange);
    _selectedKmlFileProvider.addListener(_onKmlFileChange);
    _selectedTypesProvider.addListener(_onFilterChange);
    _filterRegionProvider.addListener(_onRegionChange);
    _collisionProvider.addListener(_onCollisionSelection);
  }

  Future<void> _onAisConnectionChange() async {
    if (_aisConnectionStatusProvider.isConnected && !_isFetching) {
      await fetchInitialData();
      _zoomToLevel(3.344121217727661);
      // add delay 2 seconds to wait for the data to be fetched
      await Future.delayed(const Duration(seconds: 2));
      await _onClusterUpdate();
      if (_lgConnectionStatusProvider.isConnected && !_isUploading) {
        await showVesselsOnLGFirstConnect();
      }
    }
  }

  Future<void> _onLgConnectionChange() async {
    if (_lgConnectionStatusProvider.isConnected) {
      if (_aisConnectionStatusProvider.isConnected &&
          !_isUploading &&
          samplesMap.isNotEmpty) {
        await showVesselsOnLGFirstConnect();
      } else {
        showLogos();
      }
    }
  }

  Future<void> _onKmlFileChange() async {
    if (_lgConnectionStatusProvider.isConnected) {
      if (_selectedKmlFileProvider.selectedKmlFile == 'vesselsAis.kml' &&
          !_isUploading &&
          samplesMap.isNotEmpty) {
        await showVesselsOnLG();
      } else if (_selectedKmlFileProvider.selectedKmlFile == 'Orbit.kml' &&
          !_isUploading) {
        await showSelectedVesselOnLG();
      } else if (_selectedKmlFileProvider.selectedKmlFile == 'PathOrbit.kml' &&
          !_isUploading) {
        await showVesselTrackOnLG();
      }
    }
  }

  Future<void> _onFilterChange() async {
    samplesMap.clear();
    _markers.clear();
    _clusterdMarkers.clear();
    List<int> filter =
        _processIndexTypes(_selectedTypesProvider.selectedTypesIndex);
    await fetchFilteredData(filter, _drawOnMapProvider.polyLinesLatLngList);
    _zoomToLevel(3.344121217727661);
    await _onClusterUpdate();
    if (_lgConnectionStatusProvider.isConnected && !_isUploading) {
      await showVesselsOnLG();
    }
  }

  Future<void> _onRegionChange() async {
    _markers.clear();
    _clusterdMarkers.clear();
    samplesMap.clear();
    List<int> filter =
        _processIndexTypes(_selectedTypesProvider.selectedTypesIndex);
    await fetchFilteredData(filter, _drawOnMapProvider.polyLinesLatLngList);
    _zoomToLevel(3.344121217727661);
    await _onClusterUpdate();
    setState(() {
      _polygons.clear();
    });
    if (_lgConnectionStatusProvider.isConnected && !_isUploading) {
      await showVesselsOnLG();
    }
  }

  Future<void> _onCollisionSelection() async {
    if (!_collisionProvider.isInCollision) {
      return;
    }
    final selectedVesselProvider =
        Provider.of<SelectedVesselProvider>(context, listen: false);
    _collisionProvider
        .setOwnVessel(samplesMap[selectedVesselProvider.selectedMMSI]);
  }

  List<int> _processIndexTypes(List<int> indexTypes) {
    List<int> processedIndexes = [];

    for (int index in indexTypes) {
      if (index == 0) {
        processedIndexes.add(index);
      } else if (index == 1) {
        processedIndexes.addAll(List<int>.generate(19, (i) => i + 1));
      } else if (index >= 2) {
        processedIndexes.add(index + 18);
      }
    }

    return processedIndexes;
  }

  Future<void> _loadPolygons() async {
    List<List<LatLng>> polygons = await drawAisAreaPolygone();

    setState(() {
      _polygons.clear();
      _polygons.addAll(polygons
          .map((points) => Polygon(
                polygonId: PolygonId('polygon_id_${polygons.indexOf(points)}'),
                points: points,
                strokeWidth: 2,
                strokeColor: const Color.fromARGB(255, 243, 33, 107),
                fillColor: Color.fromARGB(0, 0, 0, 0).withOpacity(0.3),
              ))
          .toSet());
    });
  }

  Future<List<List<LatLng>>> drawAisAreaPolygone() async {
    String jsonContent =
        await rootBundle.loadString('assets/data/open_ais_area.json');
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
    print('Updating markers with ${markers.length} items');
    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  Future<void> _onClusterUpdate() async {
    _manager.setItems(samplesMap.values.toList());
  }

  Future<Marker> Function(dynamic) get _markerBuilder =>
      (dynamic cluster) async {
        final c = cluster as cluster_manager.Cluster<VesselSampled>;
        return Marker(
          markerId: MarkerId(c.getId()),
          position: c.location,
          icon: await _getMarkerBitmap(c.isMultiple ? 50 : 50,
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
    if (_clusterdMarkers.isEmpty) {
      _clusterdMarkers.addAll(_markers);
    }

    setState(() {
      _markers.clear();
      _markers.addAll(newMarkers);
      _markers.addAll(_clusterdMarkers);
      _markers.removeWhere((marker) => marker.markerId == MarkerId(c.getId()));
    });
    _zoomToLevelWithLatLong(6, c.location.latitude, c.location.longitude);
    final selectedVesselProvider =
        Provider.of<SelectedVesselProvider>(context, listen: false);
    selectedVesselProvider.updateSelectedVessel(-1);
    final trackSatateProvider =
        Provider.of<RouteTrackerState>(context, listen: false);
    trackSatateProvider.resetState();
    final predictStateProvider =
        Provider.of<RoutePredictionState>(context, listen: false);
    predictStateProvider.resetState();
  }

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Color.fromARGB(255, 154, 60, 52);

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

  Future<void> fetchInitialData() async {
    try {
      if (_isFetching) {
        return;
      }
      _isFetching = true;
      final vessels = await AisDataService().fetchInitialData();
      setState(() {
        for (var sample in vessels) {
          samplesMap[sample.mmsi!] = sample;
        }
      });
      await _onClusterUpdate();
      // connectToSSE();
      _isFetching = false;
    } catch (e) {
      _isFetching = false;
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

  Future<void> fetchFilteredData(List<int> filter, List<LatLng> region) async {
    try {
      if (_isFetching) {
        return;
      }
      _isFetching = true;
      List<bool> exceptions = [false];
      final vessels = await AisDataService().fetchFilteredData(
          filter, region, samplesMap.values.toList(), exceptions);
      if (!exceptions[0]) {
        setState(() {
          for (var sample in vessels) {
            samplesMap[sample.mmsi!] = sample;
          }
        });
      } else {
        // this is the case where the draw region is not valid, it has intersected multiple regions
        _showErrorRegionDialog();
        _drawOnMapProvider.clearDrawing();
        _isFetching = false;
        _onFilterChange();
      }
      await _onClusterUpdate();
      _isFetching = false;
    } catch (e) {
      _isFetching = false;
      print('Exception during initial data fetch: $e');
    }
  }

  void _showErrorRegionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "The region you have drawn is not valid.",
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(color: AppColors.error),
          ),
          content: Text(
            "Please draw a valid region that does not intersect.",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                side: MaterialStateProperty.all(
                  const BorderSide(color: AppColors.darkGrey, width: 3.0),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppTexts.ok,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: AppColors.darkGrey),
              ),
            ),
          ],
        );
      },
    );
  }

  // for map sync
  motionControls(double updownflag, double rightleftflag, double zoomflag,
      double tiltflag, double bearingflag) async {
    final connectionStatusProvider =
        Provider.of<LgConnectionStatusProvider>(context, listen: false);
    if (!connectionStatusProvider.isConnected) {
      return;
    }
    LookAtKmlModel flyto = LookAtKmlModel(
      lng: rightleftflag,
      lat: updownflag,
      range: zoomflag.toString(),
      tilt: tiltflag.toString(),
      heading: bearingflag.toString(),
    );
    try {
      if (_skipFlyTo) {
        _skipFlyTo = false;
        return;
      }
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

  void _zoomToLevel(double zoomLevel) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: const LatLng(72.64001277596665, 28.69204211980104),
        zoom: zoomLevel,
        bearing: _bearingvalue,
        tilt: _tiltvalue,
      ),
    ));
  }

  void _zoomToLevelWithLatLong(double zoomLevel, double lat, double long) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(lat, long),
        zoom: zoomLevel,
        bearing: _bearingvalue,
        tilt: _tiltvalue,
      ),
    ));
  }

  int _computeOrbitTimeInMilliseconds(int size, {int stepSize = 1}) {
    double updateDurationInSeconds = 0.2; // Duration for gx:AnimatedUpdate
    double waitDurationInSeconds = 0.3; // Duration for gx:Wait

    int numberOfSegments = (size / stepSize).ceil();
    double totalDurationInSeconds =
        numberOfSegments * (updateDurationInSeconds + waitDurationInSeconds);

    _trackOrbitTimeInMilliseconds = (totalDurationInSeconds * 1000).toInt();
    return _trackOrbitTimeInMilliseconds;
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
      // Preprocess the track data to remove consecutive points with the same lat and long
      final processedTrack = removeConsecutiveDuplicatePoints(track);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        routeTrackerStateProvider.toggleIsFetching(false);

        final filteredRoute = selectedVesselTrack
            .map((sample) => LatLng(sample.latitude!, sample.longitude!))
            .toList();
        // Set the time in milliseconds for the orbit
        routeTrackerStateProvider.setTimeInMilliSeconds(
            _computeOrbitTimeInMilliseconds(
                filterClosePoints(filteredRoute, 30).length));
        // show the button of LG
        routeTrackerStateProvider.toggleShowLGBotton(true);
      });
      setState(() {
        markerIndex = 0;
        selectedVesselTrack = processedTrack.reversed.toList();
      });
      print('Generated KML Content:');
    } catch (e) {
      print('Exception during track data fetch: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        routeTrackerStateProvider.toggleIsFetching(false);
      });
    }
  }

  List<VesselSampled> removeConsecutiveDuplicatePoints(
      List<VesselSampled> track) {
    if (track.isEmpty) return track;

    List<VesselSampled> filteredTrack = [track.first];

    for (int i = 1; i < track.length; i++) {
      if (track[i].latitude != track[i - 1].latitude ||
          track[i].longitude != track[i - 1].longitude) {
        filteredTrack.add(track[i]);
      }
    }

    return filteredTrack;
  }

  void updateSelectedVessel(int mmsi) {
    if (_collisionProvider.isInCollision) {
      _collisionProvider.setTargetVessel(samplesMap[mmsi]);
      return;
    }
    resetMapComponents();
    final selectedVesselProvider =
        Provider.of<SelectedVesselProvider>(context, listen: false);
    selectedVesselProvider.updateSelectedVessel(mmsi);
    final trackSatateProvider =
        Provider.of<RouteTrackerState>(context, listen: false);
    trackSatateProvider.resetState();
    final predictStateProvider =
        Provider.of<RoutePredictionState>(context, listen: false);
    predictStateProvider.resetState();
    _selectedLat = samplesMap[mmsi]!.latitude!;
    _selectedLng = samplesMap[mmsi]!.longitude!;
    _selectedCog = samplesMap[mmsi]!.courseOverGround!;
    _skipFlyTo = true;
    showVesselsOnLG();
    _zoomToLevelWithLatLong(11, _selectedLat, _selectedLng);
    flyToSelectedVessel();
  }

  Future<void> flyToSelectedVessel() async {
    LookAtKmlModel lookAtModel = LookAtKmlModel(
      lat: _selectedLat,
      lng: _selectedLng,
      range: '5000',
      tilt: '0',
      heading: '0',
      altitude: 100,
      altitudeMode: 'relativeToSeaFloor',
    );
    await LgService().flyTo(lookAtModel.linearTag);
    await Future.delayed(const Duration(seconds: 1));
    lookAtModel = LookAtKmlModel(
      lat: _selectedLat,
      lng: _selectedLng,
      range: '5000',
      tilt: '60',
      heading: '0',
      altitude: 100,
      altitudeMode: 'relativeToSeaFloor',
    );
    await LgService().flyTo(lookAtModel.linearTag);
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

  Future<void> showLogos() async {
    if (_isUploading) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    await LgService().cleanKMLsAndVisualization(true);
    await LgService().sendLogo();

    AboutBalloonKmlModel aboutModel = AboutBalloonKmlModel.fromAppTexts(
      id: '1',
      name: 'About AIS Visualization Tool',
      lat: 54.623032,
      lng: 6.640915,
    );
    String aboutKml = aboutModel.generateStaticKml();
    await LgService().sendBallonKml(aboutKml);

    LookAtKmlModel lookAtModel = LookAtKmlModel(
      lat: 67.623032,
      lng: 11.640915,
      range: '1600000',
      tilt: '0',
      heading: '0',
      altitude: 200000,
      altitudeMode: 'relativeToSeaFloor',
    );
    await LgService().flyTo(lookAtModel.linearTag);

    MultiPolygonKmlModel multiPolygon = MultiPolygonKmlModel(coordinates: []);
    String kml = multiPolygon.generateKml();
    await LgService().uploadKml(kml, 'area.kml');

    setState(() {
      _isUploading = false;
    });
  }

  Future<void> showVesselsOnLGFirstConnect() async {
    if (_isUploading) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    await LgService().cleanKMLsAndVisualization(true);
    await LgService().sendLogo();

    AboutBalloonKmlModel aboutModel = AboutBalloonKmlModel.fromAppTexts(
      id: '1',
      name: 'About AIS Visualization Tool',
      lat: 54.623032,
      lng: 6.640915,
    );
    String aboutKml = aboutModel.generateStaticKml();
    await LgService().sendBallonKml(aboutKml);

    LookAtKmlModel lookAtModel = LookAtKmlModel(
      lat: 67.623032,
      lng: 11.640915,
      range: '1600000',
      tilt: '0',
      heading: '0',
      altitude: 200000,
      altitudeMode: 'relativeToSeaFloor',
    );
    await LgService().flyTo(lookAtModel.linearTag);
    VesselKmlModel kmlModel =
        VesselKmlModel(vessels: samplesMap.values.toList());
    String kmlContent = await kmlModel.generateKmlWithArea();

    await LgService().uploadKml(kmlContent, 'vesselsAis.kml');
    setState(() {
      _isUploading = false;
    });
  }

  Future<void> showVesselsOnLG() async {
    if (_isUploading) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    LookAtKmlModel lookAtModel = LookAtKmlModel(
      lat: 67.623032,
      lng: 11.640915,
      range: '1600000',
      tilt: '0',
      heading: '0',
      altitude: 200000,
      altitudeMode: 'relativeToSeaFloor',
    );
    await LgService().flyTo(lookAtModel.linearTag);
    VesselKmlModel kmlModel =
        VesselKmlModel(vessels: samplesMap.values.toList());
    String kmlContent = '';

    if (_drawOnMapProvider.polyLinesLatLngList.isNotEmpty) {
      kmlContent = await kmlModel
          .generateKmlWithAreaAndRegion(_drawOnMapProvider.polyLinesLatLngList);
    } else {
      kmlContent = await kmlModel.generateKmlWithArea();
    }
    LgService().cleanBeforKmlResend();
    await LgService().uploadKml(kmlContent, 'vesselsAis.kml');
    setState(() {
      _isUploading = false;
    });
  }

  Future<void> showVesselTrackOnLG() async {
    // Generate the KML content with the processed track data
    List<List<double>> pathCoordinates = selectedVesselTrack
        .map((point) =>
            [point.longitude!, point.latitude!, point.courseOverGround ?? 0])
        .toList();
    String kmlContent =
        await OrbitPathPlacemarkKmlModel.buildPathOrbit(pathCoordinates);
    await LgService().cleanBeforeTour();
    await LgService().uploadKml(kmlContent, 'PathOrbit.kml');
    // Adding a delay of 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    await LgService().startTour('PathOrbit');
  }

  Future<void> showSelectedVesselOnLG() async {
    if (_isUploading) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final selectedVesselProvider =
        Provider.of<SelectedVesselProvider>(context, listen: false);

    SelectedVesselKmlModel kmlModel = SelectedVesselKmlModel(
        vessel: samplesMap[selectedVesselProvider.selectedMMSI]!);
    String kmlContent = await kmlModel.generateKmlWithAreaAndOrbit();
    await LgService().cleanBeforeTour();
    await LgService().uploadKml(kmlContent, 'Orbit.kml');
    // Adding a delay of 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    await LgService().startTour('Orbit');
    setState(() {
      _isUploading = false;
    });
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

  Set<Polyline> _buildPolylines() {
    final routeTrackerStateProvider =
        Provider.of<RouteTrackerState>(context, listen: false);

    final routePredictionStateProvider =
        Provider.of<RoutePredictionState>(context, listen: false);

    Set<Polyline> polylines = {};

    // Add the region polyline if it exists
    if (_drawOnMapProvider.polyLinesLatLngList.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('region_polyline'),
          points: _drawOnMapProvider.polyLinesLatLngList,
          width: 5,
          color: Colors.blue,
        ),
      );
      // set the polygone too
      _polygons.add(
        Polygon(
          polygonId: PolygonId('region_polygon'),
          points: _drawOnMapProvider.polyLinesLatLngList,
          strokeWidth: 5,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.4),
        ),
      );
    }

    if (routeTrackerStateProvider.showVesselRoute &&
        selectedVesselTrack.isNotEmpty) {
      print("Building polylines");
      List<LatLng> originalPoints = selectedVesselTrack
          .map((sample) => LatLng(sample.latitude!, sample.longitude!))
          .toList();

      // Filter out points that are too close to each other
      List<LatLng> filteredPoints = filterClosePoints(
          originalPoints, 10.0); // Adjust the distance as needed

      polylines.add(
        Polyline(
          polylineId: const PolylineId('track route'),
          points: filteredPoints,
          width: 4,
          color: Colors.green,
          zIndex: 1,
          startCap: Cap.roundCap,
          endCap: Cap.buttCap,
        ),
      );
    }

    if (routePredictionStateProvider.showVesselRoute &&
        routePredictionStateProvider.predictedPoints.isNotEmpty) {
      print("Building predicted polylines");
      polylines.add(
        Polyline(
          polylineId: PolylineId('predicted_route'),
          points: routePredictionStateProvider.predictedPoints
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList(),
          width: 6,
          color: Colors.red,
          zIndex: 1,
          startCap: Cap.roundCap,
          endCap: Cap.buttCap,
        ),
      );
    }

    return polylines;
  }

  double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000; // Radius of Earth in meters
    double dLat = (lat2 - lat1) * pi / 180.0;
    double dLon = (lon2 - lon1) * pi / 180.0;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180.0) *
            cos(lat2 * pi / 180.0) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  List<LatLng> filterClosePoints(List<LatLng> points, double minDistance) {
    if (points.isEmpty) return [];

    List<LatLng> filteredPoints = [points[0]];

    for (int i = 1; i < points.length; i++) {
      LatLng lastPoint = filteredPoints.last;
      LatLng currentPoint = points[i];

      double distance = haversineDistance(
        lastPoint.latitude,
        lastPoint.longitude,
        currentPoint.latitude,
        currentPoint.longitude,
      );

      if (distance >= minDistance) {
        filteredPoints.add(currentPoint);
      }
    }

    return filteredPoints;
  }

  Marker? _buildSelectedVesselPositionMarker() {
    final routeTrackerStateProvider =
        Provider.of<RouteTrackerState>(context, listen: false);

    if (routeTrackerStateProvider.showVesselRoute &&
        selectedVesselTrack.isNotEmpty) {
      return Marker(
        markerId: const MarkerId('last_position_vessel'),
        position: LatLng(selectedVesselTrack[markerIndex].latitude!,
            selectedVesselTrack[markerIndex].longitude!),
        rotation: selectedVesselTrack[markerIndex].courseOverGround ?? 0,
        icon: markerIcon,
      );
    }
    _markers.removeWhere(
        (marker) => marker.markerId == const MarkerId('last_position_vessel'));
    return null;
  }

  @override
  void dispose() {
    _mapController.dispose();
    _aisConnectionStatusProvider.removeListener(_onAisConnectionChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutePredictionState>(
        builder: (context, predictionState, child) {
      return Consumer<RouteTrackerState>(builder: (context, trackState, child) {
        fetchTrackDataFromProviderDates();

        if (trackState.isPlaying) {
          startMarkerAnimation();
        } else {
          stopMarkerAnimation();
        }
        if (trackState.currentPosition == -1) {
          resetMarkerAnimation();
        }

        _polyLines = _buildPolylines();

        final selectedVesselMarker = _buildSelectedVesselPositionMarker();
        if (selectedVesselMarker != null) {
          _markers.add(selectedVesselMarker);
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 6,
            bearing: _bearingvalue,
            tilt: _tiltvalue,
          ),
          polylines: _polyLines,
          polygons: _polygons,
          markers: _markers,
          circles: {
            Circle(
              circleId: CircleId('selected_vessel'),
              center: LatLng(_selectedLat, _selectedLng),
              radius: 5000,
              fillColor: const Color.fromARGB(182, 0, 0, 0).withOpacity(0.1),
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
    });
  }
}
