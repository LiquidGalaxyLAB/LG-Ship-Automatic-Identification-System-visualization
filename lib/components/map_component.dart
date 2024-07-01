import 'dart:async';
import 'package:ais_visualizer/models/kml/vessels_kml_model.dart';
import 'package:ais_visualizer/models/vessel_sampled_model.dart';
import 'package:ais_visualizer/providers/lg_connection_status_provider.dart';
import 'package:ais_visualizer/providers/route_tracker_state_provider.dart';
import 'package:ais_visualizer/providers/selected_vessel_provider.dart';
import 'package:ais_visualizer/services/ais_data_service.dart';
import 'package:ais_visualizer/services/lg_service.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:ais_visualizer/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

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


  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  void fetchInitialData() async {
    try {
      final vessels = await AisDataService().fetchInitialData();
      setState(() {
        for (var sample in vessels) {
          samplesMap[sample.mmsi!] = sample;
        }
      });
      connectToSSE();
    } catch (e) {
      print('Exception during initial data fetch: $e');
    }
  }

  void connectToSSE() {
    AisDataService().streamVesselsData().listen(
      (sample) {
        setState(() {
          if (samplesMap.containsKey(sample.mmsi)) {
            samplesMap[sample.mmsi!] = sample;
          } else {
            samplesMap[sample.mmsi!] = sample;
          }
        });
      },
      onError: (error) {
        print('Error occurred: $error');
      },
      cancelOnError: true,
    );
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
    if(samplesMap.isEmpty) {
      _isUplaoding = false;
      return;
    }
    VesselKmlModel kmlModel =
        VesselKmlModel(vessels: samplesMap.values.toList().sublist(0, 4));
    final kmlFile = await createFile('vessels.kml', kmlModel.generateKml());
    await LgService().uploadKml(kmlFile, 'vessels.kml');
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

  @override
  Widget build(BuildContext context) {
    final connectionStatusProvider =
        Provider.of<LgConnectionStatusProvider>(context);
    final isConnected = connectionStatusProvider.isConnected;

    return Consumer<RouteTrackerState>(builder: (context, state, child) {
      fetchTrackDataFromProviderDates();

      if (isConnected && !_isUplaoding) {
        _isUplaoding = true;
        //showVesselsOnLG();
      }

      if (state.isPlaying) {
        startMarkerAnimation();
      } else {
        stopMarkerAnimation();
      }
      if (state.currentPosition == -1) {
        resetMarkerAnimation();
      }

      return FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(60.38, 3.26),
          initialZoom: 5.0,
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          MarkerLayer(
            markers: samplesMap.values.map((sample) {
              return Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(sample.latitude!, sample.longitude!),
                rotate: true,
                child: Transform.rotate(
                  angle: (sample.courseOverGround ?? 0) *
                      (3.141592653589793 / 180),
                  child: GestureDetector(
                    onTap: () {
                      updateSelectedVessel(sample.mmsi!);
                    },
                    child: Icon(
                      Icons.directions_boat,
                      color: Colors.blue,
                      size: 40.0,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (state.showVesselRoute && selectedVesselTrack.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: selectedVesselTrack
                      .map((sample) =>
                          LatLng(sample.latitude!, sample.longitude!))
                      .toList(),
                  color: const Color.fromARGB(255, 243, 33, 33),
                  strokeWidth: 3.0,
                ),
              ],
            ),
          if (state.showVesselRoute && selectedVesselTrack.isNotEmpty)
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(selectedVesselTrack[markerIndex].latitude!,
                      selectedVesselTrack[markerIndex].longitude!),
                  rotate: true,
                  child: Transform.rotate(
                    angle: (selectedVesselTrack[markerIndex].courseOverGround ??
                            0) *
                        (3.141592653589793 / 180),
                    child: Icon(
                      Icons.directions_boat,
                      color: Colors.green,
                      size: 40.0,
                    ),
                  ),
                ),
              ],
            ),
        ],
      );
    });
  }
}
