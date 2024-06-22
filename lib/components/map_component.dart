import 'dart:async';

import 'package:ais_visualizer/models/vessel_sampled_model.dart';
import 'package:ais_visualizer/providers/route_tracker_state_provider.dart';
import 'package:ais_visualizer/providers/selected_vessel_provider.dart';
import 'package:ais_visualizer/services/ais_data_service.dart';
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
            // Update existing sample
            //print("Updated existing vessel with MMSI: ${sample.mmsi}");
            samplesMap[sample.mmsi!] = sample;
            //print("Total vessels: ${samplesMap.length}");
          } else {
            // Add new sample
            samplesMap[sample.mmsi!] = sample;
            //print("Added new vessel with MMSI: ${sample.mmsi}");
            //print(
            //'Latitude: ${sample.latitude}, Longitude: ${sample.longitude}');
            //print count
            //print("Total vessels: ${samplesMap.length}");
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
    try {
      print('Fetched track data for MMSIaaaaaaaaaaaaaaaa: $mmsi');
      final track = await AisDataService().fetchHistoricTrackData(
        mmsi,
        startDate,
        endDate,
      );
      print('Doooooneeeeeeeee');
      setState(() {
        markerIndex = 0;
        selectedVesselTrack = track.reversed.toList();
      });
    } catch (e) {
      print('Exception during track data fetch: $e');
    }
  }

  void updateSelectedVessel(int mmsi) {
    final selectedVesselProvider =
        Provider.of<SelectedVesselProvider>(context, listen: false);
    selectedVesselProvider.updateSelectedVessel(mmsi);
  }

  void startMarkerAnimation() {
    final routeTrackerStateProvider =
        Provider.of<RouteTrackerState>(context, listen: false);

    // Check if a timer is already running and cancel it
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

    // Retrieve current values
    final startDate = routeTrackerStateProvider.startDate;
    final endDate = routeTrackerStateProvider.endDate;

    // Check if the date range has changed
    if (_startDate != startDate || _endDate != endDate) {
      _startDate = startDate;
      _endDate = endDate;

      // Proceed to fetch track data
      if (startDate != null && endDate != null) {
        print('Fetching track data for selected dates');
        final formattedStartDate = startDate.toUtc().toIso8601String();
        final formattedEndDate = endDate.toUtc().toIso8601String();
        fetchTrackDataForSelectedDates(selectedVesselProvider.selectedMMSI,
            formattedStartDate, formattedEndDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteTrackerState>(builder: (context, state, child) {
      fetchTrackDataFromProviderDates();

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
                child: GestureDetector(
                  onTap: () {
                    updateSelectedVessel(sample.mmsi!);
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return AlertDialog(
                    //       title: Text('Vessel Details'),
                    //       content: SingleChildScrollView(
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text('Name: ${sample.name}'),
                    //             Text('MMSI: ${sample.mmsi}'),
                    //             Text('Latitude: ${sample.latitude}'),
                    //             Text('Longitude: ${sample.longitude}'),
                    //             Text('Course Over Ground: ${sample.courseOverGround}'),
                    //             Text('Speed Over Ground: ${sample.speedOverGround}'),
                    //             Text('True Heading: ${sample.trueHeading}'),
                    //             Text('Navigational Status: ${sample.navigationalStatus}'),
                    //           ],
                    //         ),
                    //       ),
                    //       actions: <Widget>[
                    //         TextButton(
                    //           child: Text('Close'),
                    //           onPressed: () {
                    //             Navigator.of(context).pop();
                    //           },
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // );
                  },
                  child: Icon(
                    Icons.directions_boat,
                    color: Colors.blue,
                    size: 40.0,
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
                  child: Icon(
                    Icons.location_on,
                    color: Colors.green,
                    size: 40.0,
                  ),
                ),
              ],
            ),
        ],
      );
    });
  }
}
