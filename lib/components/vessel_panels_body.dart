import 'package:ais_visualizer/models/vessel_full_model.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';

class NavigationExpansionPanelBody extends StatefulWidget {
  VesselFull? currentVessel;

  NavigationExpansionPanelBody({
    super.key,
    required this.currentVessel,
  });

  @override
  _NavigationExpansionPanelBodyState createState() => _NavigationExpansionPanelBodyState();
}

class _NavigationExpansionPanelBodyState extends State<NavigationExpansionPanelBody> {
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
                  Text(AppTexts.speedOverGround, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.speedOverGround.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.courseOverGround, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.courseOverGround.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.navigationalStatus, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.navigationalStatus.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.rateOfTurn, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.rateOfTurn.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.heading, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.trueHeading.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.lastKnownPosition, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text("${widget.currentVessel!.latitude.toString()}, ${widget.currentVessel!.longitude.toString()}", style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
            ],
            ),
        )
      ),
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
  _VesselCharacteristicsExpansionPanelBodyState createState() => _VesselCharacteristicsExpansionPanelBodyState();
}

class _VesselCharacteristicsExpansionPanelBodyState extends State<VesselCharacteristicsExpansionPanelBody> {
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
                  Text(AppTexts.shipType, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.shipType.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.callSign, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.callSign!, style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.destination, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.destination!, style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.estimatedArrival, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.eta!, style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.imoNumber, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.imoNumber.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.draught, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.draught.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
            ],
            ),
        )
      ),
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
  _PhysicalDimensionsExpansionPanelBodyState createState() => _PhysicalDimensionsExpansionPanelBodyState();
}

class _PhysicalDimensionsExpansionPanelBodyState extends State<PhysicalDimensionsExpansionPanelBody> {
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
                  Text(AppTexts.dimensionA, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.dimensionA.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.dimensionB, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.dimensionB.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.dimensionC, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.dimensionC.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.dimensionD, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.dimensionD.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.shipLength, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.shipLength.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.shipWidth, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.shipWidth.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
            ],
            ),
        )
      ),
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
  _PositioningDetailsExpansionPanelBodyState createState() => _PositioningDetailsExpansionPanelBodyState();
}

class _PositioningDetailsExpansionPanelBodyState extends State<PositioningDetailsExpansionPanelBody> {
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
                  Text(AppTexts.positionFixingDeviceType, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.positionFixingDeviceType.toString(), style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(AppTexts.reportClass, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(width: 10.0),
                  Flexible(child: Text(widget.currentVessel!.reportClass!, style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
            ],
            ),
        )
      ),
    );
  }
}