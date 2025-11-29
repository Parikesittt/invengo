import 'package:auto_route/auto_route.dart';
import 'package:invengo/features/dashboard/presentation/firebase/dashboard_firebase_page.dart';
import 'package:invengo/features/finance/presentation/firebase/finance_firebase_page.dart';
import 'package:invengo/features/profile/presentation/firebase/profile_firebase_page.dart';
import 'package:invengo/features/stock/presentation/firebase/stock_firebase_page.dart';
import 'package:invengo/shared/widgets/gradient_fab.dart';
import 'package:invengo/core/constant/app_color.dart';
import 'package:invengo/core/config/route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

@RoutePage()
class MainFirebaseScaffold extends StatefulWidget {
  const MainFirebaseScaffold({super.key});

  @override
  State<MainFirebaseScaffold> createState() => _MainFirebaseScaffoldState();
}

class _MainFirebaseScaffoldState extends State<MainFirebaseScaffold> {
  int _selectedIndex = 0;
  final List<Widget> _page = [
    DashboardFirebasePage(),
    StockFirebasePage(),
    FinanceFirebasePage(),
    ProfileFirebasePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _page[_selectedIndex],
      floatingActionButton: GradientFab(
        onPressed: () {
          context.pushRoute(const StockTransFirebaseRoute());
        },
        gradientColors: [Color(0xff8C5CF5), Color(0xffEB489A)],
        child: Icon(FontAwesomeIcons.plus, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: null,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: StylishBottomBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        fabLocation: StylishBarFabLocation.center,
        items: [
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.house, size: 20),
            selectedIcon: Icon(
              FontAwesomeIcons.houseChimney,
              size: 20,
              color: AppColor.primary,
            ),
            title: Text("Dashboard"),
            selectedColor: AppColor.primary,
          ),
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.boxOpen, size: 20),
            selectedIcon: Icon(
              FontAwesomeIcons.box,
              size: 20,
              color: AppColor.primary,
            ),
            title: Text("Stock"),
            selectedColor: AppColor.primary,
          ),
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.wallet, size: 20),
            selectedIcon: Icon(
              FontAwesomeIcons.sackDollar,
              size: 20,
              color: AppColor.primary,
            ),
            title: Text("Finance"),
            selectedColor: AppColor.primary,
          ),
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.user, size: 20),
            selectedIcon: Icon(
              FontAwesomeIcons.user,
              size: 20,
              color: AppColor.primary,
            ),
            title: Text("Profile"),
            selectedColor: AppColor.primary,
          ),
        ],
        option: AnimatedBarOptions(
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
          opacity: 0.3,
        ),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        hasNotch: true,
        notchStyle: NotchStyle.circle,
      ),
    );
  }
}
