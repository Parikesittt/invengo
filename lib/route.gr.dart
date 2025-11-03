// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'route.dart';

/// generated route for
/// [FinancePage]
class FinanceRoute extends PageRouteInfo<void> {
  const FinanceRoute({List<PageRouteInfo>? children})
    : super(FinanceRoute.name, initialChildren: children);

  static const String name = 'FinanceRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FinancePage();
    },
  );
}

/// generated route for
/// [ListCategoryPage]
class ListCategoryRoute extends PageRouteInfo<void> {
  const ListCategoryRoute({List<PageRouteInfo>? children})
    : super(ListCategoryRoute.name, initialChildren: children);

  static const String name = 'ListCategoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ListCategoryPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainPage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterPage();
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
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
         args: StockCreateRouteArgs(key: key, isUpdate: isUpdate, item: item),
         initialChildren: children,
       );

  static const String name = 'StockCreateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StockCreateRouteArgs>(
        orElse: () => const StockCreateRouteArgs(),
      );
      return StockCreatePage(
        key: args.key,
        isUpdate: args.isUpdate,
        item: args.item,
      );
    },
  );
}

class StockCreateRouteArgs {
  const StockCreateRouteArgs({this.key, this.isUpdate = false, this.item});

  final Key? key;

  final bool isUpdate;

  final ItemModel? item;

  @override
  String toString() {
    return 'StockCreateRouteArgs{key: $key, isUpdate: $isUpdate, item: $item}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! StockCreateRouteArgs) return false;
    return key == other.key && isUpdate == other.isUpdate && item == other.item;
  }

  @override
  int get hashCode => key.hashCode ^ isUpdate.hashCode ^ item.hashCode;
}

/// generated route for
/// [StockManagementPage]
class StockManagementRoute extends PageRouteInfo<void> {
  const StockManagementRoute({List<PageRouteInfo>? children})
    : super(StockManagementRoute.name, initialChildren: children);

  static const String name = 'StockManagementRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StockManagementPage();
    },
  );
}

/// generated route for
/// [StockTransPage]
class StockTransRoute extends PageRouteInfo<void> {
  const StockTransRoute({List<PageRouteInfo>? children})
    : super(StockTransRoute.name, initialChildren: children);

  static const String name = 'StockTransRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StockTransPage();
    },
  );
}
