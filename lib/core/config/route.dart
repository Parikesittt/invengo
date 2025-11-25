import 'package:auto_route/auto_route.dart';
import 'package:invengo/features/auth/presentation/sqflite/login_page.dart';
import 'package:invengo/features/auth/presentation/firebase/login_page_firebase.dart';
import 'package:invengo/ui/shell/sqflite/main_scaffold.dart';
import 'package:invengo/ui/shell/firebase/main_firebase_scaffold.dart';
import 'package:invengo/features/auth/presentation/sqflite/register_page.dart';
import 'package:invengo/features/auth/presentation/firebase/register_page_firebase.dart';
import 'package:invengo/features/finance/presentation/sqflite/finance_page.dart';
import 'package:invengo/features/finance/presentation/firebase/finance_firebase_page.dart';
import 'package:invengo/view/splash_page.dart';
import 'package:invengo/features/stock/presentation/sqflite/stock_trans_page.dart';
import 'package:invengo/features/stock/presentation/firebase/stock_trans_firebase_page.dart';
import 'package:invengo/features/stock/presentation/sqflite/stock_management_page.dart';
import 'package:invengo/features/stock/presentation/firebase/stock_management_firebase_page.dart';
import 'package:invengo/features/stock/presentation/sqflite/stock_create_page.dart';
import 'package:invengo/features/stock/presentation/firebase/stock_create_firebase_page.dart';
import 'package:invengo/view/list_user.dart';
import 'package:invengo/features/profile/presentation/sqflite/profile_page.dart';
import 'package:invengo/features/profile/presentation/firebase/profile_firebase_page.dart';
import 'package:invengo/features/profile/presentation/sqflite/edit_profile.dart';
import 'package:invengo/features/profile/presentation/firebase/edit_profile_firebase_page.dart';
import 'package:flutter/material.dart';
import 'package:invengo/data/models/item_model.dart';
import 'package:invengo/data/models/item_firebase_model.dart';
import 'package:invengo/features/dashboard/presentation/firebase/dashboard_firebase_page.dart';

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
    AutoRoute(page: MainFirebaseRoute.page, path: '/main-firebase'),
    AutoRoute(page: FinanceRoute.page, path: '/finance'),
    AutoRoute(page: FinanceFirebaseRoute.page, path: '/finance-firebase'),
    AutoRoute(page: StockTransRoute.page, path: '/stock_trans'),
    AutoRoute(
      page: StockTransFirebaseRoute.page,
      path: '/stock-trans-firebase',
    ),
    AutoRoute(page: SplashRoute.page, path: '/splash', initial: true),
    AutoRoute(page: StockManagementRoute.page, path: '/stock_management'),
    AutoRoute(
      page: StockManagementFirebaseRoute.page,
      path: '/stock-management-firebase',
    ),
    AutoRoute(page: StockCreateRoute.page, path: '/stock_create'),
    AutoRoute(
      page: StockCreateFirebaseRoute.page,
      path: '/stock-create-firebase',
    ),
    AutoRoute(page: ListCategoryRoute.page, path: '/list'),
    AutoRoute(page: ProfileRoute.page, path: '/profile'),
    AutoRoute(page: ProfileFirebaseRoute.page, path: '/profile-firebase'),
    AutoRoute(page: EditProfileRoute.page, path: '/edit-profile'),
    AutoRoute(
      page: EditProfileFirebaseRoute.page,
      path: '/edit-profile-firebase',
    ),
  ];
}
