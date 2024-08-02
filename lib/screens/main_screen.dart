import 'package:ais_visualizer/components/collapsed_left_sidebar_component.dart';
import 'package:ais_visualizer/components/map_component.dart';
import 'package:ais_visualizer/components/opened_left_sidebar_component.dart';
import 'package:ais_visualizer/providers/route_tracker_state_provider.dart';
import 'package:ais_visualizer/providers/selected_nav_item_provider.dart';
import 'package:ais_visualizer/sections/about_section.dart';
import 'package:ais_visualizer/sections/connection_section.dart';
import 'package:ais_visualizer/sections/lg_services_section.dart';
import 'package:ais_visualizer/sections/token_section.dart';
import 'package:ais_visualizer/sections/visualization_section.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:ais_visualizer/components/floating_arrow.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<String> _navbarItems;
  late List<IconData> _navbarIcons;
  bool _isRightSidebarOpen = true;
  bool _isLeftSidebarOpen = true;
  bool _dialogShown = false;
  late BuildContext _dialogContext;

  @override
  void initState() {
    super.initState();
    _navbarItems = AppTexts.navBarItems;
    _navbarIcons = [
      FontAwesomeIcons.earthAmericas,
      FontAwesomeIcons.downLeftAndUpRightToCenter,
      //FontAwesomeIcons.drawPolygon,
      FontAwesomeIcons.filter,
      FontAwesomeIcons.link,
      FontAwesomeIcons.gears,
      FontAwesomeIcons.key,
    ];
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

  Widget _getSelectedItemWidget(selectedItem) {
    switch (selectedItem) {
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
      case AppTexts.aisCrendentials:
        return const TokenSection();
      case AppTexts.about:
        return const AboutSection();
      default:
        return const Text('Select an item to view details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeTrackerState = Provider.of<RouteTrackerState>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (routeTrackerState.isFetching && !_dialogShown) {
        _dialogShown = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            _dialogContext = context;
            return AlertDialog(
              title: Text(
                AppTexts.dialogueTrackResponse,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: AppColors.success),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    AppTexts.waitTrackResponse,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    AppTexts.cancel,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: AppColors.darkGrey),
                  ),
                  onPressed: () {
                    print("Cancel pressed");
                    routeTrackerState.toggleIsFetching(false);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ).then((_) {
          setState(() {
            _dialogShown = false;
          });
        });
      } else if (!routeTrackerState.isFetching && _dialogShown) {
        Navigator.of(_dialogContext).pop();
        setState(() {
          _dialogShown = false;
        });
      }
    });

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
                        toggleLeftSidebar: _toggleLeftSidebar,
                      )
                    : CollapsedLeftSidebarComponent(
                        navbarItems: _navbarItems,
                        navbarIcons: _navbarIcons,
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
    return Consumer<SelectedNavItemProvider>(
        builder: (context, selectedNavItemProvider, child) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.only(
            topLeft: selectedNavItemProvider.selectedItem == AppTexts.about
                ? const Radius.circular(0.0)
                : const Radius.circular(40.0),
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.softGrey,
              spreadRadius: 3,
              blurRadius: 20,
              offset: Offset(10, 10),
            ),
          ],
        ),
        width:
            selectedNavItemProvider.selectedItem == AppTexts.about ? 600 : 400,
        child: Column(
          children: [
            Expanded(
              child:
                  _getSelectedItemWidget(selectedNavItemProvider.selectedItem),
            ),
          ],
        ),
      );
    });
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
