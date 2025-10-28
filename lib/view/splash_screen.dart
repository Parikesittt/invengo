import 'package:invengo/preferences/preference_handler.dart';
import 'package:invengo/view/login_page.dart';
// import 'package:belajar_ppkd/tugas_7/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:invengo/view/main_page.dart';
// import 'package:ppkd_b4/constant/app_image.dart';
// import 'package:ppkd_b4/day_15/drawer.dart';
// import 'package:ppkd_b4/day_18/login_screen_18.dart';
// import 'package:ppkd_b4/preferences/preference_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLoginFunction();
  }

  isLoginFunction() async {
    Future.delayed(Duration(seconds: 3)).then((value) async {
      var isLogin = await PreferenceHandler.getLogin();
      print(isLogin);
      if (isLogin != null && isLogin == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset('assets/images/logo_transaprant.png')),
          SizedBox(height: 12),
          Text(
            "Smart Inventory Management",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
