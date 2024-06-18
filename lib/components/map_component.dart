import 'package:ais_visualizer/models/vessel_sampled_model.dart';
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
            print("Updated existing vessel with MMSI: ${sample.mmsi}");
            samplesMap[sample.mmsi!] = sample;
            print("Total vessels: ${samplesMap.length}");
          } else {
            // Add new sample
            samplesMap[sample.mmsi!] = sample;
            print("Added new vessel with MMSI: ${sample.mmsi}");
            print(
                'Latitude: ${sample.latitude}, Longitude: ${sample.longitude}');
            //print count
            print("Total vessels: ${samplesMap.length}");
          }
        });
      },
      onError: (error) {
        print('Error occurred: $error');
      },
      cancelOnError: true,
    );
  }

  void updateSelectedVessel(int mmsi) {
    final selectedVesselProvider =
        Provider.of<SelectedVesselProvider>(context, listen: false);
    selectedVesselProvider.updateSelectedVessel(mmsi);
  }

  @override
  Widget build(BuildContext context) {
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
      ],
    );
  }
}
