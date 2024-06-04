import 'package:ais_visualizer/components/connection_indicator_component.dart';
import 'package:flutter/material.dart';
import 'package:ais_visualizer/components/navbar_item_component.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:ais_visualizer/utils/constants/image_path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OpenedLeftSidebarComponent extends StatelessWidget {
  final List<String> navbarItems;
  final List<IconData> navbarIcons;
  final String selectedItem;
  final Function(String) handleNavbarItemTap;
  final Function() toggleLeftSidebar;

  const OpenedLeftSidebarComponent({
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
      width: 230,
      decoration: const BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softGrey,
            spreadRadius: 3,
            blurRadius: 20,
            offset: Offset(10, 0),
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
                  onPressed: toggleLeftSidebar,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImagePath.appLogoNoname,
                      width: 80,
                    ),
                    Text(
                      'AIS Visualizer',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Image.asset(
                  ImagePath.lgLogo,
                  width: 60,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Center(
                  child: ConnectionIndicatorComponent(isOpened: true),
                ),
              ),
            ],
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
                  iconData: navbarIcons[index],
                  isSelected: selectedItem == navbarItems[index],
                  isSidebarOpen: true,
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
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            ImagePath.aboutIcon,
                            width: 32,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            navbarItems.last,
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
