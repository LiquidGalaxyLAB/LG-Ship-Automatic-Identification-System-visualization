import 'package:ais_visualizer/components/connection_indicator.dart';
import 'package:flutter/material.dart';
import 'package:ais_visualizer/components/navbar_item_component.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/image_path.dart';

class CollapsedLeftSidebarComponent extends StatelessWidget {
  final List<String> navbarItems;
  final List<String> navbarIcons;
  final String selectedItem;
  final Function(String) handleNavbarItemTap;
  final Function() toggleLeftSidebar;

  const CollapsedLeftSidebarComponent({
    Key? key,
    required this.navbarItems,
    required this.navbarIcons,
    required this.selectedItem,
    required this.handleNavbarItemTap,
    required this.toggleLeftSidebar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(1, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: toggleLeftSidebar,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImagePath.appLogoNoname,
                  width: 80,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Image.asset(
              ImagePath.lgLogo,
              width: 40,
            ),
          ),
          Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Center(
                  child: ConnectionIndicatorComponent(isConnected: false, isOpened: false),
                ),
              ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: AppColors.borderPrimary,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: navbarItems.length - 1,
              itemBuilder: (context, index) {
                return NavbarItemComponent(
                  onPressed: () => handleNavbarItemTap(navbarItems[index]),
                  label: navbarItems[index],
                  icon: navbarIcons[index],
                  isSelected: selectedItem == navbarItems[index],
                  isSidebarOpen: false,
                );
              },
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
                      handleNavbarItemTap(navbarItems.last);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.softGrey,
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            navbarIcons.last,
                            width: 32,
                            height: 32,
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
