import 'package:flutter/material.dart';
import 'package:ais_visualizer/utils/constants/image_path.dart'; // Make sure the ImagePath contains paths for the indicator icons

class ConnectionIndicatorComponent extends StatelessWidget {
  final bool isConnected;
  final bool isOpened;

  ConnectionIndicatorComponent({
    required this.isConnected,
    required this.isOpened,
  });

  @override
  Widget build(BuildContext context) {
    String indicatorImage = isConnected
        ? ImagePath.connectedIcon
        : ImagePath.disconnectedIcon;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          indicatorImage,
          width: 25,
        ),
        if (isOpened) ...[
          const SizedBox(width: 10),
          Text(
            isConnected ? 'Connected' : 'Disconnected',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
