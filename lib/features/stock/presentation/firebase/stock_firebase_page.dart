import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:invengo/shared/widgets/page_header.dart';
import 'package:invengo/core/constant/spacing_helper.dart';
import 'package:invengo/core/constant/app_color.dart';
import 'package:invengo/refresh_notifier.dart';
import 'package:invengo/core/config/route.dart';

import 'package:invengo/core/services/firebase.dart';
import 'package:invengo/data/models/item_firebase_model.dart';

class StockFirebasePage extends StatefulWidget {
  const StockFirebasePage({super.key});

  @override
  State<StockFirebasePage> createState() => _StockFirebasePageState();
}

class _StockFirebasePageState extends State<StockFirebasePage>
    with
        SingleTickerProviderStateMixin,
        AutoRouteAwareStateMixin<StockFirebasePage> {
  late TabController _tabController;
  final NumberFormat formatter = NumberFormat("#,###", "id_ID");
  String searchText = "";
  final TextEditingController search = TextEditingController();
  late Future<List<ItemFirebaseModel>> _listItems;
  late VoidCallback _refreshListener;

  Map<String, dynamic> _dataTotal = {
    'Total Product': 0,
    'Low Stock': 0,
    'In Stock': 0,
    'Out of Stock': 0,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    _listItems = FirebaseService.getAllItems();
    _loadTotalsSafely();

    _refreshListener = () {
      if (refreshStockNotifier.value) {
        _refreshFromNotifier();
        refreshStockNotifier.value = false;
      }
    };
    refreshStockNotifier.addListener(_refreshListener);
  }

  Future<void> _refreshFromNotifier() async {
    _listItems = FirebaseService.getAllItems();
    await _loadTotalsSafely();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadTotalsSafely() async {
    try {
      final totals = await FirebaseService.getItemsTotal();
      if (!mounted) return;
      setState(() {
        _dataTotal = totals;
      });
    } catch (e) {
    }
  }

  @override
  void didPopNext() {
    _listItems = FirebaseService.getAllItems();
    _loadTotalsSafely();
    if (mounted) setState(() {});
    super.didPopNext();
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    refreshStockNotifier.removeListener(_refreshListener);
    search.dispose();
    super.dispose();
  }

  bool _isTabSelected(int idx) => _tabController.index == idx;

  Widget _buildTabButton({
    required int index,
    required String label,
    required int count,
    required VoidCallback onTap,
  }) {
    final bool selected = _isTabSelected(index);
    if (selected) {
      return Container(
        width: 120,
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(colors: AppColor.primaryGradient),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryGradient.first.withOpacity(0.18),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: TextButton(
          onPressed: onTap,
          child: Text(
            "$label ($count)",
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 38,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: Text(
            "$label ($count)",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24),
          child: Column(
            children: [
              PageHeader(
                title: "Stock Management",
                subtitle: "Manage your inventory",
                trailing: IconButton(
                  iconSize: 20,
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                  ),
                  onPressed: () {
                    context.pushRoute(StockCreateFirebaseRoute());
                  },
                  icon: const Icon(FontAwesomeIcons.plus),
                ),
              ),
              h(24),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: CupertinoSearchTextField(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      prefixInsets: const EdgeInsets.all(12),
                      borderRadius: BorderRadius.circular(12),
                      controller: search,
                      onChanged: (v) {
                        searchText = v;
                        if (mounted) setState(() {});
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(
                      FontAwesomeIcons.filter,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              h(16),
              FutureBuilder<List<ItemFirebaseModel>>(
                future: _listItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Tidak ada data"));
                  } else {
                    final origData = snapshot.data!;
                    final data = searchText.trim().isEmpty
                        ? origData
                        : origData
                              .where(
                                (i) =>
                                    i.name.toLowerCase().contains(
                                      searchText.toLowerCase(),
                                    ) ||
                                    (i.categoryName ?? '')
                                        .toLowerCase()
                                        .contains(searchText.toLowerCase()),
                              )
                              .toList();

                    final totalProducts =
                        (_dataTotal['Total Product'] ?? origData.length) as int;
                    final lowCount = (_dataTotal['Low Stock'] ?? 0) as int;
                    final outCount = (_dataTotal['Out of Stock'] ?? 0) as int;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            _buildTabButton(
                              index: 0,
                              label: "All",
                              count: totalProducts,
                              onTap: () {
                                _tabController.animateTo(0);
                                setState(
                                  () {},
                                ); 
                              },
                            ),
                            _buildTabButton(
                              index: 1,
                              label: "Low Stock",
                              count: lowCount,
                              onTap: () {
                                _tabController.animateTo(1);
                                setState(() {});
                              },
                            ),
                            _buildTabButton(
                              index: 2,
                              label: "Out",
                              count: outCount,
                              onTap: () {
                                _tabController.animateTo(2);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        h(16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 8,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0x208b5cf6),
                                      ),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0x208B5CF6),
                                          Color(0x207C3AED),
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            totalProducts.toString(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                          ),
                                          h(28),
                                          Text(
                                            "Total",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0x2010b981),
                                      ),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0x2010b981),
                                          Color(0x20059669),
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            _dataTotal['In Stock'].toString(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                          ),
                                          h(28),
                                          Text(
                                            "In Stock",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0x20f59e0b),
                                      ),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0x20f59e0b),
                                          Color(0x20d97706),
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            _dataTotal['Low Stock'].toString(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                          ),
                                          h(28),
                                          Text(
                                            "Low",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0x20ef4444),
                                      ),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0x20ef4444),
                                          Color(0x20dc2626),
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            _dataTotal['Out of Stock']
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                          ),
                                          h(28),
                                          Text(
                                            "Out Stock",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            h(24),
                            Text(
                              "Product (${data.length})",
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.4,
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              _tabContent(data, 0),
                              _tabContent(
                                data
                                    .where(
                                      (e) =>
                                          (e.stock) < 5 &&
                                          (e.stock) > 0,
                                    )
                                    .toList(),
                                1,
                              ),
                              _tabContent(
                                data.where((e) => (e.stock) == 0).toList(),
                                2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabContent(List<ItemFirebaseModel> data, int tabIndex) {
    final list = data;
    if (list.isEmpty) return const Center(child: Text("Tidak ada data"));

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Card(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 12,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          item.categoryName ?? '-',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    PopupMenuButton<int>(
                      padding: EdgeInsets.zero,
                      onSelected: (int v) {
                        if (v == 0) {
                          context
                              .pushRoute(
                                StockCreateFirebaseRoute(
                                  isUpdate: true,
                                  item: item,
                                ),
                              )
                              .then((_) {
                                if (mounted) {
                                  _listItems = FirebaseService.getAllItems();
                                  _loadTotalsSafely();
                                  setState(() {});
                                }
                              });
                        } else if (v == 1) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Konfirmasi"),
                                content: const Text(
                                  "Anda yakin ingin menghapus item ini?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pop(); 
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(
                                        context,
                                      ).pop(); 
                                      await FirebaseService.deleteItem(
                                        item.id!,
                                      );
                                      refreshStockNotifier.value = true;
                                      _listItems =
                                          FirebaseService.getAllItems();
                                      await _loadTotalsSafely();
                                      if (mounted) setState(() {});
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (context) => const <PopupMenuEntry<int>>[
                        PopupMenuItem<int>(value: 0, child: Text('Edit Item')),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text('Delete Item'),
                        ),
                      ],
                      icon: const Icon(
                        FontAwesomeIcons.ellipsisVertical,
                        color: Color(0xff99A1AF),
                        size: 20,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 16,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Stock",
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              (item.stock).toString(),
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Price",
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              "Rp ${formatter.format(item.sellingPrice)}",
                              style: const TextStyle(color: Color(0xff8B5CF6)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
