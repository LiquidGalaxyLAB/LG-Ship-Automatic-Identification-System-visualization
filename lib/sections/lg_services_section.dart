import 'package:ais_visualizer/components/lg_service_button_component.dart';
import 'package:ais_visualizer/providers/lg_connection_status_provider.dart';
import 'package:ais_visualizer/services/lg_service.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LgServiceSection extends StatefulWidget {
  const LgServiceSection({Key? key}) : super(key: key);

  @override
  State<LgServiceSection> createState() => _LgServiceSectionState();
}

class _LgServiceSectionState extends State<LgServiceSection> {

  bool _isLoading = false;

  Future<void> executeService(String service) async {

    setState(() {
      _isLoading = true;
    });

    bool success = false;

    if (checkConnectionStatus()) {
      if (service == AppTexts.shutdown) {
        success = await LgService().shutdown();
      } else if (service == AppTexts.relaunch) {
        success = await LgService().relaunchLG();
      } else if (service == AppTexts.clearKML) {
        success = await LgService().clearKML();
      } else if (service == AppTexts.reboot) {
        success = await LgService().reboot();
      }

      if(success){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppTexts.success,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: AppColors.success)),
            content: Text(AppTexts.executeServiceSuccess,
                style: Theme.of(context).textTheme.headlineSmall),
            actions: [
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppTexts.error,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: AppColors.error)),
            content: Text(AppTexts.executeServiceFailed,
                style: Theme.of(context).textTheme.headlineSmall),
            actions: [
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

    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppTexts.error,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: AppColors.error)),
            content: Text(AppTexts.notConnectedError,
                style: Theme.of(context).textTheme.headlineSmall),
            actions: [
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
    setState(() {
      _isLoading = false;
    });
  }

  bool checkConnectionStatus() {
    final connectionStatusProvider =
        Provider.of<LgConnectionStatusProvider>(context, listen: false);
    return connectionStatusProvider.isConnected;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30.0),
          Center(
            child: Text(
              textAlign: TextAlign.center,
              AppTexts.lgServices,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 20.0),
          Center(
            child: Text(
              textAlign: TextAlign.center,
              AppTexts.lgServicesDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 20.0),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          Column(
            children: [
              LgServiceButtonComponent(
                  text: AppTexts.shutdown,
                  icon: Icons.power_settings_new,
                  executeService: executeService),
              const SizedBox(height: 10.0),
              LgServiceButtonComponent(
                  text: AppTexts.relaunch,
                  icon: Icons.refresh,
                  executeService: executeService),
              const SizedBox(height: 10.0),
              LgServiceButtonComponent(
                  text: AppTexts.clearKML,
                  icon: Icons.delete_sweep_outlined,
                  executeService: executeService),
              const SizedBox(height: 10.0),
              LgServiceButtonComponent(
                  text: AppTexts.reboot,
                  icon: Icons.restart_alt,
                  executeService: executeService),
            ],
          ),
        ],
      ),
    );
  }
}
