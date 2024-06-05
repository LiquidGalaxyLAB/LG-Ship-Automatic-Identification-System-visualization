import 'package:ais_visualizer/components/expansion_panel_component.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';

class VisualizationSection extends StatefulWidget {
  const VisualizationSection({Key? key}) : super(key: key);

  @override
  State<VisualizationSection> createState() => _VisualizationSectionState();
}

class _VisualizationSectionState extends State<VisualizationSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Text(
            textAlign: TextAlign.center,
            "Vessel Name",
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
                "Country Name | Vessel Type",
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
                    "Name:",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    textAlign: TextAlign.center,
                    "Auto",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    "MMSI:",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    textAlign: TextAlign.center,
                    "Auto",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    "Signal Received:",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    textAlign: TextAlign.end,
                    "Monday, March 11, 2024",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    textAlign: TextAlign.end,
                    "At 06:05 AM",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ExpansionPanelComponent(
                  header: AppTexts.navigationDetails,
                  body: "myBody",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ExpansionPanelComponent(
                  header: AppTexts.vesselCharacteristics,
                  body: "myBody",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ExpansionPanelComponent(
                  header: AppTexts.physicalDimensions,
                  body: "myBody",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ExpansionPanelComponent(
                  header: AppTexts.positioningDetails,
                  body: "myBody",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ExpansionPanelComponent(
                  header: AppTexts.routeTracker,
                  body: "myBody",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ExpansionPanelComponent(
                  header: AppTexts.routePrediction,
                  body: "myBody",
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
