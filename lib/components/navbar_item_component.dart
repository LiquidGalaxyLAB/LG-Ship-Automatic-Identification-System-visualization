import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavbarItemComponent extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData iconData;
  final bool isSelected;
  final bool isSidebarOpen;

  NavbarItemComponent({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.iconData,
    this.isSelected = false,
    this.isSidebarOpen = true,
  }) : super(key: key);

  @override
  _NavbarItemComponentState createState() => _NavbarItemComponentState();
}

class _NavbarItemComponentState extends State<NavbarItemComponent> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      style: TextButton.styleFrom(
        backgroundColor: widget.isSelected ? AppColors.accent : AppColors.primaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        child: Row(
          children: [
            FaIcon(
              widget.iconData,
              size: widget.isSidebarOpen ? 24 : 28,
              color: widget.isSelected ? AppColors.lightGrey : AppColors.secondary
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