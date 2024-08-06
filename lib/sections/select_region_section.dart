import 'package:ais_visualizer/providers/draw_on_map_provider.dart';
import 'package:ais_visualizer/providers/filter_region_provider.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectRegionSection extends StatefulWidget {
  const SelectRegionSection({Key? key}) : super(key: key);

  @override
  State<SelectRegionSection> createState() => _SelectRegionSectionState();
}

class _SelectRegionSectionState extends State<SelectRegionSection> {
  FilterRegionProvider _filterRegionProvider = FilterRegionProvider();

  @override
  void initState() {
    super.initState();
    _filterRegionProvider =
        Provider.of<FilterRegionProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawOnMapProvider>(
      builder: (context, drawOnMapProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  AppTexts.drawRegion,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 20.0),
              drawOnMapProvider.isDrawing
                  ? ElevatedButton(
                      onPressed: () {
                        drawOnMapProvider.toggleDrawing();
                        _filterRegionProvider.setEnableFilterMap(false);
                        // cancel drawing, ensure that the filter region is not set and clear the drawing
                        drawOnMapProvider.clearDrawing();
                        _filterRegionProvider.setFilterRegion(false);
                      },
                      child: const Icon(Icons.clear),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        drawOnMapProvider.toggleDrawing();
                        _filterRegionProvider.setEnableFilterMap(true);
                      },
                      child: const Icon(Icons.edit),
                    ),
              const SizedBox(height: 30.0),
              if (drawOnMapProvider.isDrawing)
                ElevatedButton(
                  onPressed: () {
                    // check if the user has selected no region
                    if (drawOnMapProvider.polyLinesLatLngList.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "No specific region selected",
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Color.fromARGB(173, 255, 0, 0),
                        ),
                      );
                      return;
                    }
                    drawOnMapProvider.toggleDrawing();
                    _filterRegionProvider.setEnableFilterMap(false);
                    _filterRegionProvider.setFilterRegion(true);
                  },
                  child: const Icon(Icons.check),
                ),
              const SizedBox(height: 10.0),
              drawOnMapProvider.polyLinesLatLngList.isEmpty &&
                      !drawOnMapProvider.isDrawing
                  ? Center(
                      child: Text(
                        "No specific region selected",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 12.0,
                                  color: Colors.red,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : !drawOnMapProvider.isDrawing
                      ? ElevatedButton(
                          onPressed: () {
                            drawOnMapProvider.clearDrawing();
                          },
                          child: Text("Clear Selection"),
                        )
                      : Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: AppColors.textContainerBackground,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Drawing instructions",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.red,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                "- Move the map first to your specific location \n - Press the floating button \n \n Now, you can draw...",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: AppColors.darkGrey),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
            ],
          ),
        );
      },
    );
  }
}
