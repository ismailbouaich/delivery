import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/config/app_icons.dart';
import 'package:my_app/views/components/bottom_navigation_item.dart';
import 'package:my_app/models/user.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;
  final Widget? floatingActionButton; 
  final User ?user;


  MainLayout({
    Key? key, 
    required this.child, 
    required this.title,
    this.actions,
     this.floatingActionButton,
     this.user,  // Add this line

  }) : super(key: key);

  final Rx<Menus> _currentIndex = Menus.home.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: child,
      bottomNavigationBar: _buildBottomNavigationBar(),
            floatingActionButton: floatingActionButton,  // Add this line

    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 87,
      margin: EdgeInsets.all(24),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            top: 17,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Row(
                children: [
                  _buildNavItem(Menus.home, AppIcons.icHome),
                  _buildNavItem(Menus.map, AppIcons.icLocation),
                  Spacer(),
                  _buildNavItem(Menus.orders, AppIcons.icLocation),
                  _buildNavItem(Menus.profile, AppIcons.icUser),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () => _currentIndex.value = Menus.add,
              child: Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(AppIcons.icUser),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(Menus menu, String icon) {
    return Expanded(
      child: BottomNavigationItem(
        onPressed: () {
          _currentIndex.value = menu;
          switch (menu) {
            case Menus.home:
              Get.offNamed('/home');
              break;
            case Menus.map:
              // Since map requires an order argument, we can't navigate directly.
              // You might want to handle this differently.
              break;
            case Menus.orders:
              Get.offNamed('/orders');
              break;
            case Menus.profile:
              Get.toNamed('/profile', arguments: user!.id);
              break;
            default:
              break;
          }
        },
        icon: icon,
        current: _currentIndex.value,
        name: menu,
      ),
    );
  }
}

enum Menus {
  home,
  map,
  add,
  orders,
  profile,
}