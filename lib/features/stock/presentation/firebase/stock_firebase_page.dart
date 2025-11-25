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

// Firebase service + models
import 'package:invengo/core/services/firebase.dart';
import 'package:invengo/data/models/item_firebase_model.dart';
import 'package:invengo/data/models/transaction_firebase_model.dart';

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

    // start loading data
    _listItems = FirebaseService.getAllItems();
    _loadTotalsSafely();

    // refresh listener
    _refreshListener = () {
      if (refreshStockNotifier.value) {
        _refreshFromNotifier();
        refreshStockNotifier.value = false;
      }
    };
    refreshStockNotifier.addListener(_refreshListener);
  }

  Future<void> _refreshFromNotifier() async {
    // refresh both list and totals
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
      // optionally log error
      // print('Failed to load totals: $e');
    }
  }

  @override
  void didPopNext() {
    // called when user comes back to this page
    _listItems = FirebaseService.getAllItems();
    _loadTotalsSafely();
    if (mounted) setState(() {});
    super.didPopNext();
  }

  @override
  void dispose() {
    _tabController.dispose();
    refreshStockNotifier.removeListener(_refreshListener);
    search.dispose();
    super.dispose();
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
                      // prefixInsets/borderRadius getters require concrete types
                      prefixInsets: const EdgeInsets.all(12),
                      borderRadius: BorderRadius.circular(12),
                      controller: search,
                      onChanged: (v) {
                        // simple local filter: update searchText and rebuild
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
                    // apply simple search filter if provided
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

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            Container(
                              width: 66,
                              height: 38,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                gradient: const LinearGradient(
                                  colors: AppColor.primaryGradient,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  _tabController.animateTo(0);
                                },
                                child: Text(
                                  "All (${_dataTotal['Total Product'].toString()})",
                                  style: const TextStyle(
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _tabController.animateTo(1);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surface,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              child: Text(
                                "Low Stock (${_dataTotal['Low Stock'].toString()})",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _tabController.animateTo(2);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surface,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              child: Text(
                                "Out (${_dataTotal['Out of Stock'].toString()})",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
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
                                      border: Border.all(
                                        color: const Color(0x208b5cf6),
                                      ),
                                      borderRadius: BorderRadius.circular(12),
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
                                            data.length.toString(),
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
                                          (e.stock ?? 0) < 5 &&
                                          (e.stock ?? 0) > 0,
                                    )
                                    .toList(),
                                1,
                              ),
                              _tabContent(
                                data.where((e) => (e.stock ?? 0) == 0).toList(),
                                2,
                              ),
                            ],
                          ),
                        ),
                        // h(24),
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
    // Scroll masing-masing tab
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
                                // refresh after returning from edit
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
                                      ).pop(); // Dismiss the dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // delete item from firebase
                                      Navigator.of(
                                        context,
                                      ).pop(); // close dialog first
                                      await FirebaseService.deleteItem(
                                        item.id!,
                                      );
                                      // trigger the notifier so other pages can respond
                                      refreshStockNotifier.value = true;
                                      // local refresh
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
                              (item.stock ?? 0).toString(),
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
                              "Rp ${formatter.format(item.sellingPrice ?? 0)}",
                              style: const TextStyle(color: Color(0xff8B5CF6)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      spacing: 4,
                      children: const [
                        Icon(
                          FontAwesomeIcons.arrowTrendUp,
                          color: Color(0xff00c950),
                          size: 16,
                        ),
                        Text("+12", style: TextStyle(color: Color(0xff00c950))),
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
