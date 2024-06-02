import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class NavbarItemComponent extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final String icon;
  final bool isSelected;
  final bool isSidebarOpen;

  NavbarItemComponent({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.isSelected = false,
    this.isSidebarOpen = true,
  }) : super(key: key);

  @override
  _NavbarItemComponentState createState() => _NavbarItemComponentState();
}

class _NavbarItemComponentState extends State<NavbarItemComponent> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.isSelected ? AppColors.accent : AppColors.primaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: Row(
          children: [
            Image.asset(
              widget.icon,
              width: widget.isSidebarOpen ? 28 : 36,
            ),
            if (widget.isSidebarOpen) ...[
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: widget.isSelected
                    ? Theme.of(context).textTheme.labelLarge
                    : Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}