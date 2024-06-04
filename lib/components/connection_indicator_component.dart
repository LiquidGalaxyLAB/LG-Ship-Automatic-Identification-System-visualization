import 'package:ais_visualizer/providers.dart/lg_connection_status_provider.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:ais_visualizer/utils/constants/image_path.dart';
import 'package:provider/provider.dart';

class ConnectionIndicatorComponent extends StatelessWidget {
  final bool isOpened;

  ConnectionIndicatorComponent({
    required this.isOpened,
  });

  @override
  Widget build(BuildContext context) {
    final connectionStatusProvider = Provider.of<LgConnectionStatusProvider>(context);
    final isConnected = connectionStatusProvider.isConnected;
    
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
            isConnected ? AppTexts.connected : AppTexts.disconnected,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
