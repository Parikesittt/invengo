// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'route.dart';

/// generated route for
/// [DashboardFirebasePage]
class DashboardFirebaseRoute extends PageRouteInfo<void> {
  const DashboardFirebaseRoute({List<PageRouteInfo>? children})
    : super(DashboardFirebaseRoute.name, initialChildren: children);

  static const String name = 'DashboardFirebaseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardFirebasePage();
    },
  );
}

/// generated route for
/// [EditProfileFirebasePage]
class EditProfileFirebaseRoute extends PageRouteInfo<void> {
  const EditProfileFirebaseRoute({List<PageRouteInfo>? children})
    : super(EditProfileFirebaseRoute.name, initialChildren: children);

  static const String name = 'EditProfileFirebaseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EditProfileFirebasePage();
    },
  );
}

/// generated route for
/// [EditProfilePage]
class EditProfileRoute extends PageRouteInfo<void> {
  const EditProfileRoute({List<PageRouteInfo>? children})
    : super(EditProfileRoute.name, initialChildren: children);

  static const String name = 'EditProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EditProfilePage();
    },
  );
}

/// generated route for
/// [FinanceFirebasePage]
class FinanceFirebaseRoute extends PageRouteInfo<void> {
  const FinanceFirebaseRoute({List<PageRouteInfo>? children})
    : super(FinanceFirebaseRoute.name, initialChildren: children);

  static const String name = 'FinanceFirebaseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FinanceFirebasePage();
    },
  );
}

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
/// [LoginPageFirebase]
class LoginRouteFirebase extends PageRouteInfo<void> {
  const LoginRouteFirebase({List<PageRouteInfo>? children})
    : super(LoginRouteFirebase.name, initialChildren: children);

  static const String name = 'LoginRouteFirebase';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPageFirebase();
    },
  );
}

/// generated route for
/// [MainFirebaseScaffold]
class MainFirebaseRoute extends PageRouteInfo<void> {
  const MainFirebaseRoute({List<PageRouteInfo>? children})
    : super(MainFirebaseRoute.name, initialChildren: children);

  static const String name = 'MainFirebaseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainFirebaseScaffold();
    },
  );
}

/// generated route for
/// [MainScaffold]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainScaffold();
    },
  );
}

/// generated route for
/// [ProfileFirebasePage]
class ProfileFirebaseRoute extends PageRouteInfo<void> {
  const ProfileFirebaseRoute({List<PageRouteInfo>? children})
    : super(ProfileFirebaseRoute.name, initialChildren: children);

  static const String name = 'ProfileFirebaseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileFirebasePage();
    },
  );
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
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
/// [RegisterPageFirebase]
class RegisterRouteFirebase extends PageRouteInfo<void> {
  const RegisterRouteFirebase({List<PageRouteInfo>? children})
    : super(RegisterRouteFirebase.name, initialChildren: children);

  static const String name = 'RegisterRouteFirebase';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterPageFirebase();
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
/// [StockCreateFirebasePage]
class StockCreateFirebaseRoute
    extends PageRouteInfo<StockCreateFirebaseRouteArgs> {
  StockCreateFirebaseRoute({
    Key? key,
    bool isUpdate = false,
    ItemFirebaseModel? item,
    List<PageRouteInfo>? children,
  }) : super(
         StockCreateFirebaseRoute.name,
         args: StockCreateFirebaseRouteArgs(
           key: key,
           isUpdate: isUpdate,
           item: item,
         ),
         initialChildren: children,
       );

  static const String name = 'StockCreateFirebaseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StockCreateFirebaseRouteArgs>(
        orElse: () => const StockCreateFirebaseRouteArgs(),
      );
      return StockCreateFirebasePage(
        key: args.key,
        isUpdate: args.isUpdate,
        item: args.item,
      );
    },
  );
}

class StockCreateFirebaseRouteArgs {
  const StockCreateFirebaseRouteArgs({
    this.key,
    this.isUpdate = false,
    this.item,
  });

  final Key? key;

  final bool isUpdate;

  final ItemFirebaseModel? item;

  @override
  String toString() {
    return 'StockCreateFirebaseRouteArgs{key: $key, isUpdate: $isUpdate, item: $item}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! StockCreateFirebaseRouteArgs) return false;
    return key == other.key && isUpdate == other.isUpdate && item == other.item;
  }

  @override
  int get hashCode => key.hashCode ^ isUpdate.hashCode ^ item.hashCode;
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
/// [StockManagementFirebasePage]
class StockManagementFirebaseRoute extends PageRouteInfo<void> {
  const StockManagementFirebaseRoute({List<PageRouteInfo>? children})
    : super(StockManagementFirebaseRoute.name, initialChildren: children);

  static const String name = 'StockManagementFirebaseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StockManagementFirebasePage();
    },
  );
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
/// [StockTransFirebasePage]
class StockTransFirebaseRoute extends PageRouteInfo<void> {
  const StockTransFirebaseRoute({List<PageRouteInfo>? children})
    : super(StockTransFirebaseRoute.name, initialChildren: children);

  static const String name = 'StockTransFirebaseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StockTransFirebasePage();
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
