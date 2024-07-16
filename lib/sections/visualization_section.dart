import 'dart:async';
import 'package:ais_visualizer/components/expansion_panel_component.dart';
import 'package:ais_visualizer/components/orbit_button_component.dart';
import 'package:ais_visualizer/components/vessel_panels_body.dart';
import 'package:ais_visualizer/models/kml/multi_polygone_kml_model.dart';
import 'package:ais_visualizer/models/kml/orbit_path_kml_model.dart';
import 'package:ais_visualizer/models/kml/vessel_info_ballon_kml_model.dart';
import 'package:ais_visualizer/models/vessel_full_model.dart';
import 'package:ais_visualizer/providers/AIS_connection_status_provider.dart';
import 'package:ais_visualizer/providers/selected_kml_file_provider.dart';
import 'package:ais_visualizer/providers/selected_nav_item_provider.dart';
import 'package:ais_visualizer/providers/selected_vessel_provider.dart';
import 'package:ais_visualizer/services/ais_data_service.dart';
import 'package:ais_visualizer/services/lg_service.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/image_path.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:ais_visualizer/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  late AisConnectionStatusProvider _aisConnectionStatusProvider;
  final TextEditingController _mmsiController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _streamSubscription = null;
    _aisConnectionStatusProvider =
        Provider.of<AisConnectionStatusProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedVesselProvider = Provider.of<SelectedVesselProvider>(context);
    _selectedVesselProvider.addListener(_onSelectedVesselChanged);
    _onSelectedVesselChanged();
  }

  @override
  void dispose() {
    _selectedVesselProvider.removeListener(_onSelectedVesselChanged);
    _mmsiController.dispose();
    _cancelStreamSubscription();
    super.dispose();
  }

  void _onSelectedVesselChanged() {
    _currentVessel = null;
    _fetchLatestData();
  }

  int _getSelectedVessel() {
    return _selectedVesselProvider.selectedMMSI;
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
        setState(() {
          _fetchingNewVessel = false;
        });
        print('No vessel data found');
      }
    } catch (e) {
      setState(() {
        _fetchingNewVessel = false;
      });
      print('Exception during latest data fetch: $e');
    }
  }

  // To see if the mmsi exists
  Future<bool> _checkValidSearch(int mmsi) async {
    try {
      final vessel = await AisDataService().fetchVesselData(mmsi);
      if (mounted && vessel != null) {
        return true;
      } else {
        print('No vessel data found');
        return false;
      }
    } catch (e) {
      print('Exception during latest data fetch: $e');
      return false;
    }
  }

  void _connectToStream() async {
    // Ensure any existing stream subscription is cancelled before creating a new one
    await _cancelStreamSubscription();

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

  Future<void> _cancelStreamSubscription() async {
    if (_streamSubscription != null) {
      await _streamSubscription!.cancel();
      _streamSubscription = null;
    }
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

  void _navigateToCredentials() {
    final selectedNavItemProvider =
        Provider.of<SelectedNavItemProvider>(context, listen: false);
    selectedNavItemProvider.updateNavItem(AppTexts.aisCrendentials);
  }

  void _searchByMMSI() async {
    if (_formKey.currentState!.validate()) {
      final mmsi = int.tryParse(_mmsiController.text);
      if (mmsi != null) {
        bool isMMSIValid = await _checkValidSearch(mmsi);
        if (!isMMSIValid) {
          _showInvalidMmsiDialog();
          return;
        }
        _selectedVesselProvider.updateSelectedVessel(mmsi);
        // _onSelectedVesselChanged();
        // print('Searching for MMSI: $mmsi');
        _mmsiController.clear();
      }
    }
  }

  void _showInvalidMmsiDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Invalid MMSI",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: AppColors.error)),
          content: Text(
              "The entered MMSI is not valid. Please enter a correct MMSI.",
              style: Theme.of(context).textTheme.headlineSmall),
          actions: [
            TextButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                    const BorderSide(color: AppColors.darkGrey, width: 3.0)),
              ),
              onPressed: () {
                _selectedVesselProvider.updateSelectedVessel(-1);
                Navigator.pop(context);
              },
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

  void _showAllVesselsOnLG() {
    final selectedFileProvider =
        Provider.of<SelectedKmlFileProvider>(context, listen: false);
    selectedFileProvider.updateConnectionStatus("vesselsAis.kml");
  }

  void _showOrbitSelectedVessel() {
    final selectedFileProvider =
        Provider.of<SelectedKmlFileProvider>(context, listen: false);
    selectedFileProvider.updateConnectionStatus("Orbit.kml");
  }

  Future<void> _stopOrbit() async {
    await LgService().stopTour();
  }

  Future<void> _tourAisArea() async {
    String polygoneFlyContent =
        await OrbitPathKmlModel.generatePolygonOrbitContentArea(
            'assets/data/open_ais_area.json');
    MultiPolygonKmlModel multiPolygon = MultiPolygonKmlModel(coordinates: []);
    String polygoneContent = await multiPolygon.getPolylineContent();
    String orbitContent =
        OrbitPathKmlModel.buildPathOrbit(polygoneFlyContent, polygoneContent);

    await LgService().cleanBeforeTour();
    await LgService().uploadKml4(orbitContent, 'AisOrbit.kml');
    // Adding a delay of 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    await LgService().startTour('AisOrbit');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          _aisConnectionStatusProvider.isConnected == false
              // Case for no connection to AIS
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 40.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.secondary, width: 2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "You are not connected to NAIS",
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(width: 10.0),
                            const FaIcon(
                              FontAwesomeIcons.exclamation,
                              color: AppColors.error,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.textContainerBackground,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "The app utilizes BarentsWatch service for NAIS to stream and fetch data. To see vessels on the map, you need to have a registered client and add it in the credentials section.",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: _navigateToCredentials,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 0.0),
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            backgroundColor: AppColors.accent,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Go to credentials section",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(width: 8.0),
                              const FaIcon(
                                FontAwesomeIcons.arrowRight,
                                size: 18.0,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : _currentVessel == null &&
                      _selectedVesselProvider.selectedMMSI == -1
                  // Case for no vessel selected
                  ? Column(
                      children: [
                        ElevatedButton(
                          onPressed: _showAllVesselsOnLG,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 0),
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            backgroundColor: AppColors.textContainerBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                ImagePath.lgLogo,
                                width: 30.0,
                                height: 30.0,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Show all vessels on LG',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(color: AppColors.darkerGrey),
                              ),
                            ],
                          ),
                        ),
                        OrbitButton(
                          startText: 'Tour AIS area on LG',
                          stopText: 'Stop Tour',
                          startOrbit: _tourAisArea,
                          stopOrbit: _stopOrbit,
                        ),
                        const SizedBox(height: 20.0),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 40.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.secondary, width: 2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "No vessel selected",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge,
                                    ),
                                    const SizedBox(width: 10.0),
                                    const FaIcon(
                                      FontAwesomeIcons.exclamation,
                                      color: AppColors.error,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.textContainerBackground,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    "Choose a vessel from the map, or enter its MMSI to show details and visualize its journey on the map.",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _mmsiController,
                                        decoration: const InputDecoration(
                                          labelText: "Enter MMSI",
                                          hintText: "258117000",
                                        ),
                                        keyboardType: TextInputType.number,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: AppColors.darkGrey),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter an MMSI';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10.0),
                                      ElevatedButton(
                                        onPressed: _searchByMMSI,
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30.0, vertical: 15.0),
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          backgroundColor: AppColors.accent,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Search",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                            const SizedBox(width: 8.0),
                                            const Icon(
                                              Icons.search,
                                              size: 18.0,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : _fetchingNewVessel && _currentVessel == null
                      ? const Center(child: CircularProgressIndicator())
                      : Column(children: [
                          ElevatedButton(
                            onPressed: _showAllVesselsOnLG,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 0),
                              textStyle: Theme.of(context).textTheme.bodySmall,
                              backgroundColor:
                                  AppColors.textContainerBackground,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  ImagePath.lgLogo,
                                  width: 30.0,
                                  height: 30.0,
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  'Show all vessels on LG',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(color: AppColors.darkerGrey),
                                ),
                              ],
                            ),
                          ),
                          OrbitButton(
                            startText: 'Tour AIS area on LG',
                            stopText: 'Stop Tour',
                            startOrbit: _tourAisArea,
                            stopOrbit: _stopOrbit,
                          ),
                          OrbitButton(
                            startText: 'Show and orbit selected vessel on LG',
                            stopText: 'Stop orbit',
                            startOrbit: _showOrbitSelectedVessel,
                            stopOrbit: _stopOrbit,
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            textAlign: TextAlign.center,
                            _currentVessel!.name!,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
                              // Image.asset(
                              //   "assets/img/app_logo.png",
                              //   width: 30.0,
                              //   height: 30.0,
                              // ),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(
                                    textAlign: TextAlign.center,
                                    _currentVessel!.name!,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    AppTexts.mmsi,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(
                                    textAlign: TextAlign.center,
                                    _currentVessel!.mmsi.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    textAlign: TextAlign.start,
                                    AppTexts.signalReceived,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    textAlign: TextAlign.end,
                                    _currentVessel!.msgtime.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
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
