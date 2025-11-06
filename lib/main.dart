import 'package:flutter/material.dart';
import 'package:invengo/route.dart';
import 'package:invengo/theme/theme.dart';
import 'package:invengo/theme/theme_provider.dart';
import 'package:invengo/view/login_page.dart';
import 'package:invengo/view/main_page.dart';
import 'package:invengo/view/register_page.dart';
import 'package:invengo/view/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: themeProvider.themeData,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.config(),
    );
  }
}
