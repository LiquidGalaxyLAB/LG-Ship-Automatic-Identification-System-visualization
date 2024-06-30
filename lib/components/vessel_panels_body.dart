import 'package:ais_visualizer/models/vessel_full_model.dart';
import 'package:ais_visualizer/providers/route_tracker_state_provider.dart';
import 'package:ais_visualizer/providers/selected_vessel_provider.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

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
    print("Old MMSI: ${oldWidget.currentVessel?.mmsi}");
    print("New MMSI: ${widget.currentVessel?.mmsi}");
    final selectedVesselProvider = Provider.of<SelectedVesselProvider>(context);
    if (selectedVesselProvider.selectedMMSI != selectedVesselProvider.previousMMSI) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<RouteTrackerState>().resetState();
        print("Resetting stateaaaaaaaaaaaaaaaaaaa");
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
                          onPressed: () async {
                            DateTime now = DateTime.now();
                            DateTime sevenDaysAgo =
                                now.subtract(const Duration(days: 14));
                            List<DateTime>? dateTimeList =
                                await showOmniDateTimeRangePicker(
                              context: context,
                              startInitialDate: now,
                              startFirstDate: sevenDaysAgo,
                              startLastDate: now,
                              endInitialDate: now,
                              endFirstDate: sevenDaysAgo,
                              endLastDate: now,
                              is24HourMode: false,
                              isShowSeconds: false,
                              minutesInterval: 1,
                              secondsInterval: 1,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              constraints: const BoxConstraints(
                                maxWidth: 350,
                                maxHeight: 650,
                              ),
                              transitionBuilder:
                                  (context, anim1, anim2, child) {
                                return FadeTransition(
                                  opacity: anim1.drive(
                                    Tween(
                                      begin: 0,
                                      end: 1,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              barrierDismissible: true,
                              endSelectableDayPredicate: (dateTime) {
                                return dateTime != DateTime(2023, 2, 25);
                              },
                            );

                            if (dateTimeList != null &&
                                dateTimeList.length == 2) {
                              state.updateDates(
                                  dateTimeList[0], dateTimeList[1]);
                            }
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
