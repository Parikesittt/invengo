import 'package:auto_route/auto_route.dart';
import 'package:invengo/view/login_page.dart';
import 'package:invengo/view/main_page.dart';
import 'package:invengo/view/register_page.dart';
import 'package:invengo/view/finance_page.dart';
import 'package:invengo/view/splash_screen.dart';
import 'package:invengo/view/stock_trans_page.dart';
import 'package:invengo/view/stock_management_page.dart';
import 'package:invengo/view/stock_create_page.dart';
import 'package:invengo/view/list_user.dart';
import 'package:flutter/material.dart';
import 'package:invengo/model/item_model.dart';

part 'route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: RegisterRoute.page, path: '/register'),
    AutoRoute(page: MainRoute.page, path: '/main'),
    AutoRoute(page: FinanceRoute.page, path: '/finance'),
    AutoRoute(page: StockTransRoute.page, path: '/stock_trans'),
    AutoRoute(page: SplashRoute.page, path: '/splash', initial: true),
    AutoRoute(page: StockManagementRoute.page, path: '/stock_management'),
    AutoRoute(page: StockCreateRoute.page, path: '/stock_create'),
    AutoRoute(page: ListCategoryRoute.page, path: '/list'),
  ];
}
