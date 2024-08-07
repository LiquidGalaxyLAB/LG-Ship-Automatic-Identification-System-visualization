import 'package:ais_visualizer/models/kml/collision_ballon_kml_model.dart';
import 'package:ais_visualizer/models/kml/collision_kml_model.dart';
import 'package:ais_visualizer/providers/collision_provider.dart';
import 'package:ais_visualizer/providers/selected_vessel_provider.dart';
import 'package:ais_visualizer/services/collision_service.dart';
import 'package:ais_visualizer/services/lg_service.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class CollisionSection extends StatefulWidget {
  const CollisionSection({Key? key}) : super(key: key);

  @override
  State<CollisionSection> createState() => _CollisionSectionState();
}

class _CollisionSectionState extends State<CollisionSection> {
  late SelectedVesselProvider _selectedVesselProvider;
  late CollisionProvider _collisionProvider;
  bool _isCalculating = false;
  double _cpa = 0.0;
  double _tcpa = 0.0;
  bool _willCollide = false;
  LatLng? _collisionPoint;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedVesselProvider = Provider.of<SelectedVesselProvider>(context);
    _collisionProvider = Provider.of<CollisionProvider>(context);

    _selectedVesselProvider.addListener(_onVesselChanged);
  }

  void _onVesselChanged() {
    _collisionProvider.reset();
  }

  Future<void> _simulateCollisionOnLG() async {
    if (_isUploading) {
      return;
    }
    setState(() {
      _isUploading = true;
    });
    CollisionKmlModel collisionKmlModel = CollisionKmlModel(
      ownVessel: _collisionProvider.ownVessel!,
      targetVessel: _collisionProvider.targetVessel!,
      collisionPoint: _collisionPoint!,
    );

    // send ballon having the information about the collision
    CollisionBallonKmlModel kmlModel = CollisionBallonKmlModel(
      ownVessel: _collisionProvider.ownVessel!,
      targetVessel: _collisionProvider.targetVessel!,
      cpa: _cpa,
      tcpa: _tcpa,
      isCollision: _willCollide,
    );
    String kml = kmlModel.generateKml();
    await LgService().sendBallonKml(kml);

    String kmlContent = await collisionKmlModel.generateKmlCollision();
    await LgService().cleanBeforeTour();
    LgService().cleanBeforKmlResend();
    await LgService().uploadKml4(kmlContent, 'collisionSimulation.kml');
    // Adding a delay of 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    await LgService().startTour('VesselCollisionTour');

    setState(() {
      _isUploading = false;
    });
  }

  void _calculateCPAandTCPA() {
    setState(() {
      _isCalculating = true;
    });

    final result = CollisionService().cpaTcpa(
      _collisionProvider.ownVessel!,
      _collisionProvider.targetVessel!,
    );

    setState(() {
      _cpa = result['cpa']!;
      _tcpa = result['tcpa']!;
      _isCalculating = false;
      _collisionPoint = result['collisionPoint'];
      // vessels will collide if the CPA is less than 1.0 and tcpa is less than 6 minutes and tcpa is not 0
      _willCollide = _cpa < 1.0 && _tcpa < 6.0 && _tcpa != 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20.0),
          Center(
            child: Text(
              textAlign: TextAlign.center,
              AppTexts.collisionRisk,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 20.0),
          _selectedVesselProvider.selectedMMSI == -1
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
                              "No vessel selected",
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
                            "Choose the Own Ship on the map to see its collision risk",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 40.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.secondary, width: 2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        if (_collisionProvider.targetVessel == null ||
                            _collisionProvider.isInCollision) ...[
                          Row(
                            children: [
                              Text(
                                "Selected MMSI: ${_selectedVesselProvider.selectedMMSI}",
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
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
                            child: Text.rich(
                              TextSpan(
                                text:
                                    "Choose another vessel to see the calculated ",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                children: const [
                                  TextSpan(
                                    text: "Closest Point of Approach ",
                                  ),
                                  TextSpan(
                                    text: "CPA",
                                    style:
                                        TextStyle(color: AppColors.secondary),
                                  ),
                                  TextSpan(
                                    text:
                                        " and Time to Closest Point of Approach ",
                                  ),
                                  TextSpan(
                                    text: "TCPA",
                                    style:
                                        TextStyle(color: AppColors.secondary),
                                  ),
                                  TextSpan(
                                    text:
                                        ". These values help you understand how close and when another vessel will get near you.",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (_collisionProvider.targetVessel != null &&
                            _collisionProvider.isInCollision == false) ...[
                          Row(
                            children: [
                              Text(
                                "Own Vessel MMSI: ${_collisionProvider.ownVessel!.mmsi}",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Text(
                                "Target Vessel MMSI: ${_collisionProvider.targetVessel!.mmsi}",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: AppColors.textContainerBackground,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Closest Point of Approach (CPA): ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                    _isCalculating
                                        ? const SizedBox(
                                            width: 15.0,
                                            height: 15.0,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2.0),
                                          )
                                        : Flexible(
                                            child: Text(
                                              _tcpa == 0.0
                                                  ? "___"
                                                  : "${_cpa.toStringAsFixed(3)} km",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                            ),
                                          ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Time to Closest Point of Approach (TCPA): ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                    _isCalculating
                                        ? const SizedBox(
                                            width: 15.0,
                                            height: 15.0,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2.0),
                                          )
                                        : Flexible(
                                            child: Text(
                                              _tcpa == 0.0
                                                  ? "___"
                                                  : "${_tcpa.toStringAsFixed(3)} minutes",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                            ),
                                          ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                if (!_isCalculating) ...[
                                  _willCollide
                                      ? Text(
                                          "Warning: Collision Risk Detected",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                color: AppColors.error,
                                              ),
                                        )
                                      : Text(
                                          "No Collision Risk Detected",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                color: AppColors.success,
                                              ),
                                        ),
                                  const SizedBox(height: 10.0),
                                  _tcpa != 0.0
                                      ? ElevatedButton(
                                          onPressed: () {
                                            _simulateCollisionOnLG();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30.0,
                                                vertical: 10.0),
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            backgroundColor: AppColors.accent,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  "Simulate CPA on LG",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              const FaIcon(
                                                FontAwesomeIcons.video,
                                                size: 18.0,
                                                color: AppColors.white,
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  _tcpa == 0.0
                                      ? Text(
                                          "Vessels are on parallel or diverging paths",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                color: AppColors.success,
                                              ),
                                          textAlign: TextAlign.center,
                                        )
                                      : const SizedBox.shrink(),
                                ]
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              _collisionProvider.setIsInCollision(false);
                              _collisionProvider.setTargetVessel(null);
                              _collisionProvider.setOwnVessel(null);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              backgroundColor: AppColors.accent,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Change Target Vessel",
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                const Icon(
                                  Icons.edit,
                                  size: 18.0,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Collision Avoidance Thresholds Explanation',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8.0),
                                RichText(
                                  text: TextSpan(
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: Colors.black87,
                                        ),
                                    children: [
                                      const TextSpan(text: 'A '),
                                      TextSpan(
                                          text: 'CPA distance',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      const TextSpan(
                                          text:
                                              ' of less than 0.5 nautical miles (NM) or 1 kilometer (km) is often considered a critical threshold indicating a high risk of collision.\n'),
                                      const TextSpan(text: '\n \nA '),
                                      TextSpan(
                                          text: 'TCPA',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      const TextSpan(
                                          text:
                                              ' of less than 6 minutes is generally considered a critical threshold, especially for vessels traveling at higher speeds.\n'),
                                      TextSpan(
                                          text: '\n \nTCPA ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      const TextSpan(
                                          text:
                                              'is meaningful only if the vessels are moving towards each other. If it is equal to zero, then no collision risk exists.\n'),
                                      const TextSpan(
                                          text:
                                              '\n \nCPA and TCPA calculations typically assume that both vessels will maintain constant speed and course until the CPA.'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                        const SizedBox(height: 20.0),
                        if (!_collisionProvider.isInCollision &&
                            _collisionProvider.targetVessel == null)
                          ElevatedButton(
                            onPressed: () {
                              _collisionProvider.setIsInCollision(true);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              backgroundColor: AppColors.accent,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Start Selecting Your Target Vessel On The Map",
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                const FaIcon(
                                  FontAwesomeIcons.handPointer,
                                  size: 18.0,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                        if (_collisionProvider.isInCollision)
                          ElevatedButton(
                            onPressed: () {
                              _collisionProvider.setIsInCollision(false);
                              _collisionProvider.setTargetVessel(null);
                              _collisionProvider.setOwnVessel(null);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              backgroundColor: AppColors.error,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Stop Selecting Target Vessel",
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                const FaIcon(
                                  FontAwesomeIcons.stop,
                                  size: 18.0,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20.0),
                        if (_collisionProvider.ownVessel != null &&
                            _collisionProvider.targetVessel != null &&
                            _collisionProvider.isInCollision)
                          ElevatedButton(
                            onPressed: () {
                              _collisionProvider.setIsInCollision(false);
                              _calculateCPAandTCPA();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              backgroundColor: AppColors.accent,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Start Calculationss",
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                const Icon(
                                  Icons.check,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
