import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:invengo/components/gradient_fab.dart';
import 'package:invengo/route.dart';
import 'package:invengo/view/dashboard_page.dart';
import 'package:invengo/view/finance_page.dart';
import 'package:invengo/view/grid.dart';
import 'package:invengo/view/profile_page.dart';
import 'package:invengo/view/stock_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/view/tugas2.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _page = [
    DashboardPage(),
    StockPage(),
    FinancePage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[_selectedIndex],
      floatingActionButton: GradientFab(
        onPressed: () {
          context.pushRoute(const StockTransRoute());
        },
        gradientColors: [Color(0xff8C5CF5), Color(0xffEB489A)],
        child: Icon(FontAwesomeIcons.plus, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: null,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: StylishBottomBar(
        fabLocation: StylishBarFabLocation.center,
        items: [
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.house, size: 20),
            title: Text("Dashboard"),
          ),
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.boxOpen, size: 20),
            title: Text("Stock"),
          ),
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.wallet, size: 20),
            title: Text("Finance"),
          ),
          BottomBarItem(
            icon: Icon(FontAwesomeIcons.user, size: 20),
            title: Text("Profile"),
          ),
        ],
        option: AnimatedBarOptions(
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
          opacity: 0.3,
          // dotStyle: DotStyle.tile,
          // gradient: const LinearGradient(
          //   colors: [Colors.deepPurple, Colors.pink],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
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
