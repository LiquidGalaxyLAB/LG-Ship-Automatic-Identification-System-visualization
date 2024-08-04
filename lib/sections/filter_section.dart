import 'package:ais_visualizer/providers/AIS_connection_status_provider.dart';
import 'package:ais_visualizer/providers/selected_types_provider.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class FilterSection extends StatefulWidget {
  FilterSection({Key? key}) : super(key: key);

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  final List<String> items = AppTexts.filterItems;
  List<String> selectedValues = [];
  List<int> selectedIndexes = [];
  List<String> tempSelectedValues = [];
  List<int> tempSelectedIndexes = [];
  String searchText = '';
  bool isPanelOpen = false;
  late AisConnectionStatusProvider _aisConnectionStatusProvider;

  final TextEditingController textEditingController = TextEditingController();

  void _filterData() {
    if (!_aisConnectionStatusProvider.isConnected) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppTexts.error,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: AppColors.error),
            ),
            content: Text(
              "You need to be connected to the AIS server to filter data.",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                    const BorderSide(color: AppColors.darkGrey, width: 3.0),
                  ),
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
      return;
    }
    setState(() {
      selectedValues = List.from(tempSelectedValues);
      selectedIndexes = List.from(tempSelectedIndexes);
    });
    context
        .read<SelectedTypesProvider>()
        .setSelectedTypes(selectedValues, selectedIndexes);
  }

  void _clearFilters() {
    setState(() {
      tempSelectedValues.clear();
      selectedValues.clear();
      selectedIndexes.clear();
      tempSelectedIndexes.clear();
    });
    context
        .read<SelectedTypesProvider>()
        .setSelectedTypes(selectedValues, selectedIndexes);
  }

  @override
  void initState() {
    super.initState();
    final selectedTypesProvider = context.read<SelectedTypesProvider>();
    selectedValues = selectedTypesProvider.selectedTypes;
    selectedIndexes = selectedTypesProvider.selectedTypesIndex;
    tempSelectedValues = List.from(selectedValues);
    tempSelectedIndexes = List.from(selectedIndexes);
    _aisConnectionStatusProvider =
        Provider.of<AisConnectionStatusProvider>(context, listen: false);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredItems = items
        .where((item) => item.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Center(
            child: Text(
              AppTexts.filterTitle,
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
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPanelOpen = !isPanelOpen;
                      if (!isPanelOpen) {
                        tempSelectedValues = List.from(selectedValues);
                        tempSelectedIndexes = List.from(selectedIndexes);
                      }
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isPanelOpen
                              ? 'Hide Filter Options'
                              : 'Show Filter Options',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        Icon(
                          isPanelOpen
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Theme.of(context).hintColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                if (selectedValues.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: tempSelectedValues
                        .map(
                          (value) => Chip(
                            deleteIconColor: AppColors.grey,
                            labelStyle: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    fontSize: 12, color: AppColors.darkGrey),
                            label: Text(value),
                            onDeleted: () {
                              setState(() {
                                int index = tempSelectedValues.indexOf(value);
                                tempSelectedValues.remove(value);
                                tempSelectedIndexes.removeAt(index);
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 10.0),
                if (selectedValues.isNotEmpty)
                  TextButton(
                    onPressed: _clearFilters,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Clear Filters',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(width: 8.0),
                        const Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: _filterData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  child: Text(
                    'Filter Types on Map',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                if (isPanelOpen)
                  Column(
                    children: [
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: textEditingController,
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          hintText: 'Search for a type...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  fontSize: 14, color: AppColors.darkerGrey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.darkerGrey,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.darkerGrey,
                              width: 1.0,
                            ),
                          ),
                          suffixIcon: const Icon(
                            Icons.search,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: filteredItems.map((item) {
                            int itemIndex = items.indexOf(item);
                            return CheckboxListTile(
                              title: Text(
                                item,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              value: tempSelectedIndexes.contains(itemIndex),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    tempSelectedValues.add(item);
                                    tempSelectedIndexes.add(itemIndex);
                                  } else {
                                    int index =
                                        tempSelectedValues.indexOf(item);
                                    tempSelectedValues.removeAt(index);
                                    tempSelectedIndexes.removeAt(index);
                                  }
                                });
                              },
                              checkColor: Colors.white,
                              activeColor: Colors.green,
                              tileColor: Colors.lightGreen.shade50,
                              contentPadding: const EdgeInsets.all(8.0),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
