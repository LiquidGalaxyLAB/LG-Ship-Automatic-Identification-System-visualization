import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ExpansionPanelComponent extends StatefulWidget {
  final String header;
  final Widget body;

  const ExpansionPanelComponent({
    super.key,
    required this.header,
    required this.body,
  });

  @override
  State<ExpansionPanelComponent> createState() =>
      _ExpansionPanelComponentState();
}

class _ExpansionPanelComponentState extends State<ExpansionPanelComponent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.softGrey,
            spreadRadius: 0,
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExpansionPanelList(
          elevation: 3,
          expansionCallback: (int index, bool isExpanded) =>
              setState(() => _isExpanded = isExpanded),
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(widget.header, style: Theme.of(context).textTheme.headlineMedium),
                );
              },
              body: widget.body,
              isExpanded: _isExpanded,
              backgroundColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
