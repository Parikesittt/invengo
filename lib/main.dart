import 'package:flutter/material.dart';
import 'package:invengo/route.dart';
import 'package:invengo/theme/theme.dart';
import 'package:invengo/view/login_page.dart';
import 'package:invengo/view/main_page.dart';
import 'package:invengo/view/register_page.dart';
import 'package:invengo/view/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // initialRoute: '/splash',
      // routes: {
      //   '/': (context) => const MainPage(),
      //   '/splash': (context) => const SplashScreen(),
      //   '/login': (context) => const LoginPage(),
      //   '/register': (context) => const RegisterPage(),
      //   // '/': (context) => const MainPage(),
      //   // '/': (context) => const MainPage(),
      // },
      routerConfig: _appRouter.config(),
    );
  }
}
