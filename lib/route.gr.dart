// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'route.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    FinanceRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FinancePage(),
      );
    },
    ListCategoryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ListCategoryPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainPage(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    StockCreateRoute.name: (routeData) {
      final args = routeData.argsAs<StockCreateRouteArgs>(
          orElse: () => const StockCreateRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: StockCreatePage(
          key: args.key,
          isUpdate: args.isUpdate,
          item: args.item,
        ),
      );
    },
    StockManagementRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StockManagementPage(),
      );
    },
    StockTransRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StockTransPage(),
      );
    },
  };
}

/// generated route for
/// [FinancePage]
class FinanceRoute extends PageRouteInfo<void> {
  const FinanceRoute({List<PageRouteInfo>? children})
      : super(
          FinanceRoute.name,
          initialChildren: children,
        );

  static const String name = 'FinanceRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ListCategoryPage]
class ListCategoryRoute extends PageRouteInfo<void> {
  const ListCategoryRoute({List<PageRouteInfo>? children})
      : super(
          ListCategoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'ListCategoryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StockCreatePage]
class StockCreateRoute extends PageRouteInfo<StockCreateRouteArgs> {
  StockCreateRoute({
    Key? key,
    bool isUpdate = false,
    ItemModel? item,
    List<PageRouteInfo>? children,
  }) : super(
          StockCreateRoute.name,
          args: StockCreateRouteArgs(
            key: key,
            isUpdate: isUpdate,
            item: item,
          ),
          initialChildren: children,
        );

  static const String name = 'StockCreateRoute';

  static const PageInfo<StockCreateRouteArgs> page =
      PageInfo<StockCreateRouteArgs>(name);
}

class StockCreateRouteArgs {
  const StockCreateRouteArgs({
    this.key,
    this.isUpdate = false,
    this.item,
  });

  final Key? key;

  final bool isUpdate;

  final ItemModel? item;

  @override
  String toString() {
    return 'StockCreateRouteArgs{key: $key, isUpdate: $isUpdate, item: $item}';
  }
}

/// generated route for
/// [StockManagementPage]
class StockManagementRoute extends PageRouteInfo<void> {
  const StockManagementRoute({List<PageRouteInfo>? children})
      : super(
          StockManagementRoute.name,
          initialChildren: children,
        );

  static const String name = 'StockManagementRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StockTransPage]
class StockTransRoute extends PageRouteInfo<void> {
  const StockTransRoute({List<PageRouteInfo>? children})
      : super(
          StockTransRoute.name,
          initialChildren: children,
        );

  static const String name = 'StockTransRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
