import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:woofme/screens/public_screens/favorites_screen.dart';
import 'package:woofme/screens/public_screens/home_screen.dart';
import 'package:woofme/screens/public_screens/settings_screen.dart';
import 'package:woofme/screens/public_screens/swipe_screen.dart';
import 'package:woofme/screens/public_screens/user_profile_screen.dart';

class PublicNavigation extends StatelessWidget {
  const PublicNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> buildScreens() {
      return [
        const HomeScreen(),
        const FavoritesScreen(),
        const SwipeScreen(),
        const UserProfileScreen(),
        const SettingsScreen(),
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: ("Home"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.favorite_border_rounded),
          title: ("Favorite"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.pets,
            color: Colors.white,
          ),
          title: ("Pets"),
          inactiveIcon: const Icon(
            Icons.pets_outlined,
            color: Colors.white,
          ),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.account_circle_outlined),
          title: ("Profile"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings_outlined),
          title: ("Setting"),
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    }

    PersistentTabController controller;

    controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(
      context,
      screens: buildScreens(),
      items: navBarsItems(),
      controller: controller,
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style16,
    );
  }
}
