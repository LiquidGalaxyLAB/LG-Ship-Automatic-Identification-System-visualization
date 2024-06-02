import 'package:ais_visualizer/components/collapsed_left_sidebar_component.dart';
import 'package:ais_visualizer/components/map_component.dart';
import 'package:ais_visualizer/components/opened_left_sidebar_component.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/image_path.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:ais_visualizer/components/floating_arrow.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<String> _navbarItems;
  late List<String> _navbarIcons;
  late String _selectedItem;
  bool _isRightSidebarOpen = true;
  bool _isLeftSidebarOpen = true;

  @override
  void initState() {
    super.initState();
    _navbarItems = AppTexts.navBarItems;
    _navbarIcons = [
      ImagePath.visualizationIcon,
      ImagePath.collisionIcon,
      ImagePath.selectRegionIcon,
      ImagePath.filterIcon,
      ImagePath.connectIcon,
      ImagePath.lgServicesIcon,
      ImagePath.aboutIcon
    ];
    _selectedItem = _navbarItems[_navbarItems.length - 1];
  }

  void _toggleRightSidebar() {
    setState(() {
      _isRightSidebarOpen = !_isRightSidebarOpen;
    });
  }

  void _toggleLeftSidebar() {
    setState(() {
      _isLeftSidebarOpen = !_isLeftSidebarOpen;
    });
  }

  void _handleNavbarItemTap(String selectedItem) {
    setState(() {
      _selectedItem = selectedItem;
    });
  }

  Widget _getSelectedItemWidget() {
    switch (_selectedItem) {
      case 'Visualization':
        return const Text('Content for Visualization');
      case 'Collision':
        return const Text('Content for Collision');
      case 'Select region':
        return const Text('Content for Select region');
      case 'Filter':
        return const Text('Content for Filter');
      case 'Connect':
        return const Text('Content for Connect');
      case 'LG Services':
        return const Text('Content for LG Services');
      case 'About':
        return const Text('Content for About');
      default:
        return const Text('Select an item to view details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
      ),
      body: Stack(
        children: [
          MapComponent(),
          FloatingArrow(
            isOpen: _isRightSidebarOpen,
            onTap: _toggleRightSidebar,
          ),
          Row(
            children: [
              // Left Sidebar
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLeftSidebarOpen
                    ? OpenedLeftSidebarComponent(
                        navbarItems: _navbarItems,
                        navbarIcons: _navbarIcons,
                        selectedItem: _selectedItem,
                        handleNavbarItemTap: _handleNavbarItemTap,
                        toggleLeftSidebar: _toggleLeftSidebar,
                      )
                    : CollapsedLeftSidebarComponent(
                        navbarItems: _navbarItems,
                        navbarIcons: _navbarIcons,
                        selectedItem: _selectedItem,
                        handleNavbarItemTap: _handleNavbarItemTap,
                        toggleLeftSidebar: _toggleLeftSidebar,
                      ),
              ),
              const Spacer(),
              // Right Sidebar
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isRightSidebarOpen
                    ? _buildRightSidebar()
                    : _buildCollapsedRightSidebar(),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildRightSidebar() {
    return Container(
      width: 450,
      color: AppColors.primaryBackground,
      child: Column(
        children: [
          Expanded(
            child: _getSelectedItemWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedRightSidebar() {
    return Container(
      width: 40,
      color: AppColors.primaryBackground,
    );
  }
}