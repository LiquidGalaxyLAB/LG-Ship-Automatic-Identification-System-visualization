import 'dart:convert';

import 'package:ais_visualizer/components/expansion_panel_component.dart';
import 'package:ais_visualizer/components/vessel_panels_body.dart';
import 'package:ais_visualizer/models/vessel_full_model.dart';
import 'package:ais_visualizer/providers/selected_vessel_provider.dart';
import 'package:ais_visualizer/services/auth_service.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class VisualizationSection extends StatefulWidget {
  const VisualizationSection({Key? key}) : super(key: key);

  @override
  State<VisualizationSection> createState() => _VisualizationSectionState();
}

class _VisualizationSectionState extends State<VisualizationSection> {
  VesselFull? _currentVessel;
  late http.Client _client;
  late SelectedVesselProvider _selectedVesselProvider;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    _fetchLatestData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedVesselProvider = Provider.of<SelectedVesselProvider>(context);
    _selectedVesselProvider.addListener(_onSelectedVesselChanged);
  }

  @override
  void dispose() {
    _selectedVesselProvider.removeListener(_onSelectedVesselChanged);
    _client.close();
    super.dispose();
  }

  void _onSelectedVesselChanged() {
    _fetchLatestData();
  }

  int getSelectedVessel() {
    return _selectedVesselProvider.selectedMMSI;
  }

  void _fetchLatestData() async {
    final token = await AuthService.getToken();
    final url = Uri.parse('https://live.ais.barentswatch.no/v1/latest/combined');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "mmsi": [getSelectedVessel()],
      "modelType": "Full",
      "downsample": true
    });

    try {
      final response = await _client.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        if (jsonList.isNotEmpty) {
          setState(() {
            _currentVessel = VesselFull.fromJson(jsonList[0]);
          });
        }
        _connectToStream(); // Connect to the stream after fetching the latest data
      } else {
        print('Failed to load latest data');
      }
    } catch (e) {
      print('Exception during latest data fetch: $e');
    }
  }

  void _connectToStream() async {
    final token = await AuthService.getToken();
    final url =
        Uri.parse('https://live.ais.barentswatch.no/live/v1/sse/combined');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'accept': 'text/event-stream'
    };
    final body = jsonEncode({
      "mmsi": [getSelectedVessel()],
      "downsample": true,
      "modelType": "Full"
    });

    final request = http.Request('POST', url)
      ..headers.addAll(headers)
      ..body = body;

    try {
      final response = await _client.send(request);
      final stream = response.stream;
      stream.transform(utf8.decoder).transform(const LineSplitter()).listen(
        (String event) {
          if (event.startsWith('data: ')) {
            // Remove 'data: ' prefix
            String jsonData = event.substring(6);
            Map<String, dynamic> jsonMap = jsonDecode(jsonData);
            VesselFull sample = VesselFull.fromJson(jsonMap);
            print('Received vessel: ${sample.name}');
            setState(() {
              _currentVessel = sample;
            });
          }
        },
        onError: (error) {
          print('Error occurred: $error');
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('Exception during SSE connection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          _currentVessel == null
              ? const Center(child: CircularProgressIndicator())
              : Column(children: [
                  Text(
                    textAlign: TextAlign.center,
                    _currentVessel!.name!,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Image.asset(
                        "assets/img/app_logo.png",
                        width: 30.0,
                        height: 30.0,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        "${_currentVessel!.destination!} | ${_currentVessel!.shipType!}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    height: 3,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            AppTexts.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            textAlign: TextAlign.center,
                            _currentVessel!.name!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            AppTexts.mmsi,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            textAlign: TextAlign.center,
                            _currentVessel!.mmsi.toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            textAlign: TextAlign.start,
                            AppTexts.signalReceived,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            textAlign: TextAlign.end,
                            _currentVessel!.msgtime.toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ExpansionPanelComponent(
                          header: AppTexts.navigationDetails,
                          body: NavigationExpansionPanelBody(
                              currentVessel: _currentVessel),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ExpansionPanelComponent(
                          header: AppTexts.vesselCharacteristics,
                          body: VesselCharacteristicsExpansionPanelBody(
                              currentVessel: _currentVessel),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ExpansionPanelComponent(
                          header: AppTexts.physicalDimensions,
                          body: PhysicalDimensionsExpansionPanelBody(
                              currentVessel: _currentVessel),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ExpansionPanelComponent(
                          header: AppTexts.physicalDimensions,
                          body: PositioningDetailsExpansionPanelBody(
                              currentVessel: _currentVessel),
                        ),
                      ),
                    ],
                  )
                ])
        ],
      ),
    );
  }
}
