import 'package:ais_visualizer/components/collapsed_left_sidebar_component.dart';
import 'package:ais_visualizer/components/map_component.dart';
import 'package:ais_visualizer/components/opened_left_sidebar_component.dart';
import 'package:ais_visualizer/sections/about_section.dart';
import 'package:ais_visualizer/sections/connection_section.dart';
import 'package:ais_visualizer/sections/lg_services_section.dart';
import 'package:ais_visualizer/sections/visualization_section.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  late List<IconData> _navbarIcons;
  late String _selectedItem;
  bool _isRightSidebarOpen = true;
  bool _isLeftSidebarOpen = true;

  @override
  void initState() {
    super.initState();
    _navbarItems = AppTexts.navBarItems;
    _navbarIcons = [
      FontAwesomeIcons.earthAmericas,
      FontAwesomeIcons.downLeftAndUpRightToCenter,
      FontAwesomeIcons.drawPolygon,
      FontAwesomeIcons.filter,
      FontAwesomeIcons.link,
      FontAwesomeIcons.gears,
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
      case AppTexts.visualization:
        return const VisualizationSection();
      case AppTexts.collision:
        return const Text('Content for Collision');
      case AppTexts.selectRegion:
        return const Text('Content for Select region');
      case AppTexts.filter:
        return const Text('Content for Filter');
      case AppTexts.lgConnection:
        return const ConnectionSection();
      case AppTexts.lgServices:
        return const LgServiceSection();
      case AppTexts.about:
        return const AboutSection();
      default:
        return const Text('Select an item to view details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(5.0),
        child: AppBar(
          backgroundColor: AppColors.primaryBackground,
        ),
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
      decoration: const BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softGrey,
            spreadRadius: 3,
            blurRadius: 20,
            offset: Offset(10, 10),
          ),
        ],
      ),
      width: 450,
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
      decoration: const BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softGrey,
            spreadRadius: 3,
            blurRadius: 20,
            offset: Offset(10, 10),
          ),
        ],
      ),
    );
  }
}
