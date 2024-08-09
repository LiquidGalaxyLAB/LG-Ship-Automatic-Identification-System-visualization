import 'package:ais_visualizer/components/connection_indicator_component.dart';
import 'package:ais_visualizer/providers/selected_nav_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:ais_visualizer/components/navbar_item_component.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/image_path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OpenedLeftSidebarComponent extends StatefulWidget {
  final List<String> navbarItems;
  final List<IconData> navbarIcons;
  final Function() toggleLeftSidebar;

  const OpenedLeftSidebarComponent({
    Key? key,
    required this.navbarItems,
    required this.navbarIcons,
    required this.toggleLeftSidebar,
  }) : super(key: key);

  @override
  State<OpenedLeftSidebarComponent> createState() =>
      _OpenedLeftSidebarComponentState();
}

class _OpenedLeftSidebarComponentState
    extends State<OpenedLeftSidebarComponent> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedNavItemProvider =
        Provider.of<SelectedNavItemProvider>(context, listen: false);
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkerGrey,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.softGrey,
                    size: 20.0,
                  ),
                  onPressed: widget.toggleLeftSidebar,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImagePath.appLogoNoname,
                      width: 60,
                    ),
                    Text(
                      'AIS Visualizer',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 10.0),
              //   child: Image.asset(
              //     ImagePath.lgLogo,
              //     width: 60,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: ConnectionIndicatorComponent(isOpened: true),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: AppColors.borderPrimary,
            ),
          ),
          Expanded(
            child: Consumer<SelectedNavItemProvider>(
              builder: (context, selectedNavItemProvider, child) {
                // // Get the selected index
                // final int selectedIndex = widget.navbarItems.indexOf(
                //     selectedNavItemProvider.selectedItem);

                // // Scroll to the position if the selectedIndex is valid
                // if (selectedIndex >= 0 && selectedIndex < widget.navbarItems.length - 1) {
                //   const double itemHeight = 60.0;
                //   WidgetsBinding.instance.addPostFrameCallback((_) {
                //     _scrollController.animateTo(
                //       selectedIndex * itemHeight,
                //       duration: const Duration(milliseconds: 300),
                //       curve: Curves.easeInOut,
                //     );
                //   });
                // }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.navbarItems.length - 1,
                  itemBuilder: (context, index) {
                    return NavbarItemComponent(
                      label: widget.navbarItems[index],
                      iconData: widget.navbarIcons[index],
                      isSidebarOpen: true,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: AppColors.borderPrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      selectedNavItemProvider.updateNavItem(
                          widget.navbarItems[widget.navbarItems.length - 1]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.softGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.circleInfo,
                            size: 24,
                            color: AppColors.darkGrey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.navbarItems.last,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
