import 'package:ais_visualizer/providers/selected_nav_item_provider.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NavbarItemComponent extends StatefulWidget {
  final String label;
  final IconData iconData;
  final bool isSidebarOpen;

  NavbarItemComponent({
    Key? key,
    required this.label,
    required this.iconData,
    this.isSidebarOpen = true,
  }) : super(key: key);

  @override
  _NavbarItemComponentState createState() => _NavbarItemComponentState();
}

class _NavbarItemComponentState extends State<NavbarItemComponent> {
  void _handleNavbarItemTap() {
    final selectedNavItemProvider =
        Provider.of<SelectedNavItemProvider>(context, listen: false);
    selectedNavItemProvider.updateNavItem(widget.label);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedNavItemProvider>(
      builder: (context, selectedNavItemProvider, child) {
        return TextButton(
          onPressed: _handleNavbarItemTap,
          style: TextButton.styleFrom(
            backgroundColor:
                selectedNavItemProvider.selectedItem == widget.label ? AppColors.accent : AppColors.primaryBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
            child: Row(
              children: [
                FaIcon(widget.iconData,
                    size: widget.isSidebarOpen ? 20 : 20,
                    color: selectedNavItemProvider.selectedItem == widget.label
                        ? AppColors.lightGrey
                        : AppColors.secondary),
                if (widget.isSidebarOpen) ...[
                  const SizedBox(width: 8),
                  Text(
                    widget.label,
                    style: selectedNavItemProvider.selectedItem == widget.label
                        ? Theme.of(context).textTheme.labelLarge
                        : Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ],
            ),
          ),
        );
      }
    );
  }
}
