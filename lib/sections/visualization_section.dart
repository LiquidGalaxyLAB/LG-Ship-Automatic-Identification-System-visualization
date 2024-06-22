import 'dart:async';
import 'package:ais_visualizer/components/expansion_panel_component.dart';
import 'package:ais_visualizer/components/vessel_panels_body.dart';
import 'package:ais_visualizer/models/vessel_full_model.dart';
import 'package:ais_visualizer/providers/selected_vessel_provider.dart';
import 'package:ais_visualizer/services/ais_data_service.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VisualizationSection extends StatefulWidget {
  const VisualizationSection({Key? key}) : super(key: key);

  @override
  State<VisualizationSection> createState() => _VisualizationSectionState();
}

class _VisualizationSectionState extends State<VisualizationSection> {
  VesselFull? _currentVessel;
  late SelectedVesselProvider _selectedVesselProvider;
  late StreamSubscription<VesselFull> _streamSubscription;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedVesselProvider = Provider.of<SelectedVesselProvider>(context);
    _selectedVesselProvider.addListener(_onSelectedVesselChanged);
    _fetchLatestData();
  }

  @override
  void dispose() {
    _selectedVesselProvider.removeListener(_onSelectedVesselChanged);
    _streamSubscription.cancel();
    super.dispose();
  }

  void _onSelectedVesselChanged() {
    _fetchLatestData();
  }

  int getSelectedVessel() {
    return _selectedVesselProvider.selectedMMSI;
  }

  void _fetchLatestData() async {
    try {
      final vessel = await AisDataService().fetchVesselData(getSelectedVessel());
      if (mounted && vessel != null) {
        setState(() {
          _currentVessel = vessel;
        });
        _connectToStream(); // Connect to the stream after fetching the latest data
      } else {
        print('No vessel data found');
      }
    } catch (e) {
      print('Exception during latest data fetch: $e');
    }
  }

  void _connectToStream() async {
    _streamSubscription = AisDataService().streamVesselData(getSelectedVessel()).listen(
      (sample) {
        if (mounted) {
          setState(() {
            print('Received new vessel data');
            _currentVessel = sample;
          });
        }
      },
      onError: (error) {
        print('Error occurred: $error');
      },
      cancelOnError: true,
    );
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
                          header: AppTexts.positioningDetails,
                          body: PositioningDetailsExpansionPanelBody(
                              currentVessel: _currentVessel),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ExpansionPanelComponent(
                          header: AppTexts.routeTracker,
                          body: RouteTrackerExpansionPanelBody(
                              currentVessel: _currentVessel),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ExpansionPanelComponent(
                          header: AppTexts.routePrediction,
                          body: Container()
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
