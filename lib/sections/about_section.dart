import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Center(
            child: Text(
              AppTexts.aboutAIS,
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColors.textContainerBackground,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTexts.aboutDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20.0),
                Text(
                  AppTexts.keyFeatures,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10.0),
                for (var feature in AppTexts.features) _buildFeatureItem(feature, context),
                const SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement onPressed logic here
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      backgroundColor: AppColors.accent,
                    ),
                    child: Text(
                      AppTexts.getStarted,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          const Icon(Icons.circle, color: AppColors.textSecondary, size: 10),
          const SizedBox(width: 10.0),
          Flexible(
          child: Text(
            feature,
            style: Theme.of(context).textTheme.bodyLarge,
            softWrap: true,
          ),
        ),
        ],
      ),
    );
  }
}
