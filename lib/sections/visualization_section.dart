import 'dart:async';
import 'package:ais_visualizer/components/expansion_panel_component.dart';
import 'package:ais_visualizer/components/vessel_panels_body.dart';
import 'package:ais_visualizer/models/kml/vessel_info_ballon_kml_model.dart';
import 'package:ais_visualizer/models/vessel_full_model.dart';
import 'package:ais_visualizer/providers/selected_vessel_provider.dart';
import 'package:ais_visualizer/services/ais_data_service.dart';
import 'package:ais_visualizer/services/lg_service.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:ais_visualizer/utils/helpers.dart';
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
  late StreamSubscription<VesselFull>? _streamSubscription;
  bool _isUplaoding = false;
  bool _fetchingNewVessel = false;

  @override
  void initState() {
    super.initState();
    _streamSubscription = null;
    if (_getSelectedVessel() != -1) {
      _fetchLatestData();
    }
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
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _onSelectedVesselChanged() {
    final currentSelectedVessel = _getSelectedVessel();
    final previousSelectedVessel = _getPerviousSelectedVessel();
    print('Selected vessel changed to: $currentSelectedVessel');
    print('Previous selected vessel: $previousSelectedVessel');
    if (previousSelectedVessel != currentSelectedVessel) {
      _fetchLatestData();
    }
  }

  int _getSelectedVessel() {
    return _selectedVesselProvider.selectedMMSI;
  }

  int _getPerviousSelectedVessel() {
    return _selectedVesselProvider.previousMMSI;
  }

  void _fetchLatestData() async {
    try {
      if (!mounted) return;
      setState(() {
        _fetchingNewVessel = true;
      });

      final vessel =
          await AisDataService().fetchVesselData(_getSelectedVessel());
      if (mounted && vessel != null) {
        setState(() {
          _currentVessel = vessel;
          _fetchingNewVessel = false;
          if (!_isUplaoding) {
            _isUplaoding = true;
            showVesselsOnLG();
          }
        });
        _connectToStream();
      } else {
        print('No vessel data found');
      }
    } catch (e) {
      print('Exception during latest data fetch: $e');
    }
  }

  void _connectToStream() async {
    _streamSubscription =
        AisDataService().streamVesselData(_getSelectedVessel()).listen(
      (sample) {
        if (mounted) {
          setState(() {
            print('Received new vessel data');
            _currentVessel = sample;
            if (!_isUplaoding) {
              _isUplaoding = true;
              showVesselsOnLG();
            }
          });
        }
      },
      onError: (error) {
        print('Error occurred: $error');
      },
      cancelOnError: true,
    );
  }

  Future<void> showVesselsOnLG() async {
    if (mounted && _currentVessel == null) {
      _isUplaoding = false;
      return;
    }
    VesselInfoBalloonKmlModel kmlModel =
        VesselInfoBalloonKmlModel(vessel: _currentVessel!);
    String kml = kmlModel.generateKml();
    await LgService().sendBallonKml(kml);
    _isUplaoding = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          _currentVessel == null || _fetchingNewVessel
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
                            body: Container()),
                      ),
                    ],
                  )
                ])
        ],
      ),
    );
  }
}
