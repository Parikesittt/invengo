import 'package:auto_route/auto_route.dart';
import 'package:invengo/features/auth/presentation/sqflite/login_page.dart';
import 'package:invengo/features/auth/presentation/firebase/login_page_firebase.dart';
import 'package:invengo/ui/shell/main_scaffold.dart';
import 'package:invengo/features/auth/presentation/sqflite/register_page.dart';
import 'package:invengo/features/auth/presentation/firebase/register_page_firebase.dart';
import 'package:invengo/view/finance_page.dart';
import 'package:invengo/view/splash_page.dart';
import 'package:invengo/view/stock_trans_page.dart';
import 'package:invengo/view/stock_management_page.dart';
import 'package:invengo/view/stock_create_page.dart';
import 'package:invengo/view/list_user.dart';
import 'package:invengo/view/profile_page.dart';
import 'package:invengo/view/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:invengo/data/models/item_model.dart';

part 'route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Scaffold|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: LoginRouteFirebase.page, path: '/login-firebase'),
    AutoRoute(page: RegisterRoute.page, path: '/register'),
    AutoRoute(page: RegisterRouteFirebase.page, path: '/register-firebase'),
    AutoRoute(page: MainRoute.page, path: '/main'),
    AutoRoute(page: FinanceRoute.page, path: '/finance'),
    AutoRoute(page: StockTransRoute.page, path: '/stock_trans'),
    AutoRoute(page: SplashRoute.page, path: '/splash', initial: true),
    AutoRoute(page: StockManagementRoute.page, path: '/stock_management'),
    AutoRoute(page: StockCreateRoute.page, path: '/stock_create'),
    AutoRoute(page: ListCategoryRoute.page, path: '/list'),
    AutoRoute(page: ProfileRoute.page, path: '/profile'),
    AutoRoute(page: EditProfileRoute.page, path: '/edit-profile'),
  ];
}
