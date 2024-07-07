import 'package:ais_visualizer/providers/lg_connection_status_provider.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionIndicatorComponent extends StatelessWidget {
  final bool isOpened;

  ConnectionIndicatorComponent({
    required this.isOpened,
  });

  @override
  Widget build(BuildContext context) {
    final connectionStatusProvider =
        Provider.of<LgConnectionStatusProvider>(context);
    final isConnected = connectionStatusProvider.isConnected;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isConnected ? Icons.wifi : Icons.signal_wifi_off_outlined,
          color: isConnected ? Colors.green : Colors.red,
          size: 20.0,
        ),
        if (isOpened) ...[
          const SizedBox(width: 10),
          Text(
            isConnected ? AppTexts.connected : AppTexts.disconnected,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: AppColors.darkGrey),
          ),
        ],
      ],
    );
  }
}
