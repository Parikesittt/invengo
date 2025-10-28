import 'package:auto_route/auto_route.dart';
import 'package:invengo/view/login_page.dart';
import 'package:invengo/view/main_page.dart';
import 'package:invengo/view/register_page.dart';

part 'route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: '/login', initial: true),
    AutoRoute(page: RegisterRoute.page, path: '/register'),
    AutoRoute(page: MainRoute.page, path: '/main'),
  ];
}
