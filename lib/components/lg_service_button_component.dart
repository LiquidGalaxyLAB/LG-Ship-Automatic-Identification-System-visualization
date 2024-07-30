import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class LgServiceButtonComponent extends StatelessWidget {
  final String text;
  final IconData icon;
  final Future<void> Function(String) executeService;

  LgServiceButtonComponent({
    Key? key,
    required this.text,
    required this.icon,
    required this.executeService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        executeService(text);
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(210.0, 65.0),
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        backgroundColor: AppColors.accent,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.secondary, size: 30.0),
            const SizedBox(width: 10.0),
            Expanded( 
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}