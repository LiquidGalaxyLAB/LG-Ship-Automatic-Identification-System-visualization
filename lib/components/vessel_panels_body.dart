import 'package:ais_visualizer/models/knn_simple_vessel_model.dart';
import 'package:ais_visualizer/models/knn_vessel_model.dart';
import 'package:ais_visualizer/models/vessel_full_model.dart';
import 'package:ais_visualizer/providers/route_prediction_state_provider.dart';
import 'package:ais_visualizer/providers/route_tracker_state_provider.dart';
import 'package:ais_visualizer/services/ais_data_service.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:ais_visualizer/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:ais_visualizer/services/knn_service.dart';

class NavigationExpansionPanelBody extends StatefulWidget {
  VesselFull? currentVessel;

  NavigationExpansionPanelBody({
    super.key,
    required this.currentVessel,
  });

  @override
  _NavigationExpansionPanelBodyState createState() =>
      _NavigationExpansionPanelBodyState();
}

class _NavigationExpansionPanelBodyState
    extends State<NavigationExpansionPanelBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      child: Container(
          decoration: BoxDecoration(
            color: AppColors.textContainerBackground,
            border: Border.all(
              color: AppColors.primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(AppTexts.speedOverGround,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(
                            widget.currentVessel!.speedOverGround.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.courseOverGround,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(
                            widget.currentVessel!.courseOverGround.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.navigationalStatus,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(
                            widget.currentVessel!.navigationalStatus.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.rateOfTurn,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.rateOfTurn.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.heading,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(
                            widget.currentVessel!.trueHeading.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.lastKnownPosition,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(
                            "${widget.currentVessel!.latitude.toString()}, ${widget.currentVessel!.longitude.toString()}",
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class VesselCharacteristicsExpansionPanelBody extends StatefulWidget {
  VesselFull? currentVessel;

  VesselCharacteristicsExpansionPanelBody({
    super.key,
    required this.currentVessel,
  });

  @override
  _VesselCharacteristicsExpansionPanelBodyState createState() =>
      _VesselCharacteristicsExpansionPanelBodyState();
}

class _VesselCharacteristicsExpansionPanelBodyState
    extends State<VesselCharacteristicsExpansionPanelBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      child: Container(
          decoration: BoxDecoration(
            color: AppColors.textContainerBackground,
            border: Border.all(
              color: AppColors.primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(AppTexts.shipType,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.shipType.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.callSign,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.callSign!,
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.destination,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.destination!,
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.estimatedArrival,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.eta!,
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.imoNumber,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.imoNumber.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.draught,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.draught.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class PhysicalDimensionsExpansionPanelBody extends StatefulWidget {
  VesselFull? currentVessel;

  PhysicalDimensionsExpansionPanelBody({
    super.key,
    required this.currentVessel,
  });

  @override
  _PhysicalDimensionsExpansionPanelBodyState createState() =>
      _PhysicalDimensionsExpansionPanelBodyState();
}

class _PhysicalDimensionsExpansionPanelBodyState
    extends State<PhysicalDimensionsExpansionPanelBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      child: Container(
          decoration: BoxDecoration(
            color: AppColors.textContainerBackground,
            border: Border.all(
              color: AppColors.primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(AppTexts.dimensionA,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.dimensionA.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.dimensionB,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.dimensionB.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.dimensionC,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.dimensionC.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.dimensionD,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.dimensionD.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.shipLength,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.shipLength.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.shipWidth,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.shipWidth.toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class PositioningDetailsExpansionPanelBody extends StatefulWidget {
  VesselFull? currentVessel;

  PositioningDetailsExpansionPanelBody({
    super.key,
    required this.currentVessel,
  });

  @override
  _PositioningDetailsExpansionPanelBodyState createState() =>
      _PositioningDetailsExpansionPanelBodyState();
}

class _PositioningDetailsExpansionPanelBodyState
    extends State<PositioningDetailsExpansionPanelBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      child: Container(
          decoration: BoxDecoration(
            color: AppColors.textContainerBackground,
            border: Border.all(
              color: AppColors.primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(AppTexts.positionFixingDeviceType,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(
                            widget.currentVessel!.positionFixingDeviceType
                                .toString(),
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(AppTexts.reportClass,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(width: 10.0),
                    Flexible(
                        child: Text(widget.currentVessel!.reportClass!,
                            style: Theme.of(context).textTheme.bodyLarge)),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class RouteTrackerExpansionPanelBody extends StatefulWidget {
  VesselFull? currentVessel;

  RouteTrackerExpansionPanelBody({
    super.key,
    required this.currentVessel,
  });

  @override
  _RouteTrackerExpansionPanelBodyState createState() =>
      _RouteTrackerExpansionPanelBodyState();
}

class _RouteTrackerExpansionPanelBodyState
    extends State<RouteTrackerExpansionPanelBody> {
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _speedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speedController.text = '1.0';
  }

  @override
  void didUpdateWidget(covariant RouteTrackerExpansionPanelBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentVessel?.mmsi != oldWidget.currentVessel?.mmsi) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<RouteTrackerState>().resetState();
        _dateTimeController.clear();
        _speedController.text = '1.0';
      });
    }
  }

  void handleSpeedInput(String input) {
    double? speed = double.tryParse(input);
    if (speed != null && speed >= 0.5 && speed <= 32.0) {
      context.read<RouteTrackerState>().setPlaybackSpeed(speed);
    } else {
      _speedController.text =
          context.read<RouteTrackerState>().playbackSpeed.toStringAsFixed(1);
    }
  }

  Future<void> _selectDateRange(
    BuildContext context,
    RouteTrackerState state,
  ) async {
    DateTime now = DateTime.now();

    // Pick start date
    DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 14)), // 14 days ago
      lastDate: now,
      helpText: "Start date",
    );

    if (pickedStartDate != null) {
      // Pick start time
      TimeOfDay? pickedStartTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(pickedStartDate));

      if (pickedStartTime != null) {
        pickedStartDate = DateTime(
          pickedStartDate.year,
          pickedStartDate.month,
          pickedStartDate.day,
          pickedStartTime.hour,
          pickedStartTime.minute,
        );

        // Pick end date
        DateTime? pickedEndDate = await showDatePicker(
          context: context,
          initialDate: pickedStartDate,
          firstDate: pickedStartDate,
          lastDate: now,
          helpText: "End date",
        );

        if (pickedEndDate != null) {
          // Pick end time
          TimeOfDay? pickedEndTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(pickedEndDate),
          );

          if (pickedEndTime != null) {
            pickedEndDate = DateTime(
              pickedEndDate.year,
              pickedEndDate.month,
              pickedEndDate.day,
              pickedEndTime.hour,
              pickedEndTime.minute,
            );

            state.updateDates(pickedStartDate, pickedEndDate);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Text(
                  AppTexts.showVesselRoute,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                Consumer<RouteTrackerState>(
                  builder: (context, state, child) {
                    return Checkbox(
                      value: state.showVesselRoute,
                      onChanged: (bool? value) {
                        state.toggleShowRoute(value ?? false);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            decoration: BoxDecoration(
              color: AppColors.textContainerBackground,
              border: Border.all(
                color: AppColors.primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  Text(
                    AppTexts.dateRange,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 5.0),
                  Consumer<RouteTrackerState>(builder: (context, state, child) {
                    return TextField(
                      controller: TextEditingController(
                        text: state.startDate != null && state.endDate != null
                            ? '${state.startDate} - ${state.endDate}'
                            : '',
                      ),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.darkGrey,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.darkGrey,
                          ),
                        ),
                        hintText: AppTexts.chooseDate,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDateRange(context, state);
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            decoration: BoxDecoration(
              color: AppColors.textContainerBackground,
              border: Border.all(
                color: AppColors.primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          AppTexts.simulate,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Consumer<RouteTrackerState>(
                    builder: (context, state, child) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.stop),
                                onPressed: () {
                                  state.toggleIsPlaying(false);
                                  state.setCurrentPosition(-1);
                                },
                              ),
                              IconButton(
                                icon: Icon(state.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow),
                                onPressed: () {
                                  state.toggleIsPlaying(!state.isPlaying);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.replay),
                                onPressed: () {
                                  state.setCurrentPosition(-1);
                                  state.toggleIsPlaying(true);
                                },
                              ),
                            ],
                          ),
                          Slider(
                            value: state.currentPosition,
                            onChanged: (position) {
                              state.setCurrentPosition(position);
                            },
                            activeColor: AppColors.borderHighlighted,
                            inactiveColor: AppColors.grey,
                            min: -1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Speed:'),
                              IconButton(
                                icon: const Icon(Icons.arrow_downward),
                                onPressed: () {
                                  double newSpeed = state.playbackSpeed - 0.5;
                                  if (newSpeed >= 0.5) {
                                    state.setPlaybackSpeed(newSpeed);
                                    _speedController.text =
                                        newSpeed.toStringAsFixed(1);
                                  }
                                },
                              ),
                              Container(
                                width: 70,
                                child: TextFormField(
                                  controller: _speedController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  onFieldSubmitted: handleSpeedInput,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.darkGrey),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_upward),
                                onPressed: () {
                                  double newSpeed = state.playbackSpeed + 0.5;
                                  if (newSpeed <= 32.0) {
                                    state.setPlaybackSpeed(newSpeed);
                                    _speedController.text =
                                        newSpeed.toStringAsFixed(1);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoutePredectionExpansionPanelBody extends StatefulWidget {
  final VesselFull? currentVessel;

  RoutePredectionExpansionPanelBody({
    super.key,
    required this.currentVessel,
  });

  @override
  _RoutePredectionExpansionPanelBodyState createState() =>
      _RoutePredectionExpansionPanelBodyState();
}

class _RoutePredectionExpansionPanelBodyState
    extends State<RoutePredectionExpansionPanelBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RoutePredectionExpansionPanelBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentVessel?.mmsi != oldWidget.currentVessel?.mmsi) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<RoutePredictionState>().resetState();
      });
    }
  }

  void _predictRoute() async {
    // Check if the current speed is less than 1 knot then no calculation should be provided
    if (widget.currentVessel!.speedOverGround! < 1) {
      _showErrorDialogue('Cannot Find Prediction Route',
          'Vessel speed is less than 1 knot and the vessel is not moving. No prediction route could be generated.');
      return;
    }
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Starting Prediction',
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(color: AppColors.success),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'Please wait while we predict the route...',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        );
      },
    );

    // Get bbox
    final bbox = getBoundingBox(widget.currentVessel!.latitude!,
        widget.currentVessel!.longitude!, 2420);

    // Format start and end dates
    final String start =
        formatDateTime(DateTime.now().subtract(const Duration(days: 20)));
    final String end =
        formatDateTime(DateTime.now().subtract(const Duration(days: 4)));
    // fetch data vessels from api
    final List<KnnVesselModel> aisDataList =
        await AisDataService().fetchAisPositionsInArea(
      bbox: bbox,
      start: start,
      end: end,
      minSpeed: 0.5,
    );

    if (aisDataList.isEmpty) {
      _closeDialog();
      _showErrorDialogue('Cannot Find Prediction Route',
          'No AIS data available for prediction.');
      return;
    }

    KnnService knnService = KnnService();
    knnService.train(aisDataList);

    KnnSimpleVesselModel targetVessel = KnnSimpleVesselModel(
      mmsi: widget.currentVessel!.mmsi,
      dateTimeUtc: widget.currentVessel!.msgtime,
      longitude: widget.currentVessel!.longitude!,
      latitude: widget.currentVessel!.latitude!,
      speedOverGround: widget.currentVessel!.speedOverGround!,
      courseOverGround: widget.currentVessel!.courseOverGround!,
    );

    print('Predicting route for vessel: $targetVessel');
    int k = 9;
    List<KnnSimpleVesselModel> similarVessels =
        knnService.predict(targetVessel, k);
    for (var vessel in similarVessels) {
      print(vessel);
      try {
        final result =
            await knnService.predictFutureLocation(targetVessel, vessel);
        // Use the result as needed
        print('Predicted location: $result');
      } catch (e) {
        _closeDialog();
        _showErrorDialogue(
            'An error occurred while predicting future location.',
            'Cannot fetch AIS data, please try again later.');
        print('Error occurred: $e');
        return;
      }
    }

    // try {
    //   final result = await knnService.predictFutureLocation(
    //       targetVessel, similarVessels[0]);
    //   // Use the result as needed
    //   print('Predicted location: $result');
    // } catch (e) {
    //   _closeDialog();
    //   _showErrorDialogue('An error occurred while predicting future location.',
    //       'Cannot fetch AIS data, please try again later.');
    //   print('Error occurred: $e');
    //   return;
    // }

    _closeDialog();
  }

  _closeDialog() {
    Navigator.of(context).pop();
  }

  void _showErrorDialogue(String titleText, String contentText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            titleText,
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(color: AppColors.error),
          ),
          content: Text(
            contentText,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                    const BorderSide(color: AppColors.darkGrey, width: 3.0)),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Text(
                  AppTexts.showPredictionRoute,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                Consumer<RoutePredictionState>(
                  builder: (context, state, child) {
                    return Checkbox(
                      value: state.showVesselRoute,
                      onChanged: (bool? value) {
                        state.toggleShowRoute(value ?? false);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            constraints: const BoxConstraints(
              minWidth: double.infinity,
            ),
            decoration: BoxDecoration(
              color: AppColors.textContainerBackground,
              border: Border.all(
                color: AppColors.primary,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  Text(
                    AppTexts.timeToPredict,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 5.0),
                  Consumer<RoutePredictionState>(
                    builder: (context, state, child) {
                      return DropdownButtonFormField<int>(
                        value: state.timeToPredict,
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            state.setTimeToPredict(newValue);
                          }
                        },
                        items: <int>[10, 20, 30]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value minutes',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.darkGrey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.darkGrey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.darkGrey,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: ElevatedButton(
              onPressed: _predictRoute,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                textStyle: Theme.of(context).textTheme.bodyLarge,
                backgroundColor: AppColors.accent,
              ),
              child: Text(
                'Predict Route',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
