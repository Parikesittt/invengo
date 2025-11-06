
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/components/page_header.dart';
import 'package:invengo/components/spacing_helper.dart';
import 'package:invengo/constant/app_color.dart';
import 'package:invengo/database/db_helper.dart';
import 'package:invengo/model/item_model.dart';
import 'package:invengo/refresh_notifier.dart';
import 'package:invengo/route.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage>
    with SingleTickerProviderStateMixin, AutoRouteAwareStateMixin<StockPage> {
  late TabController _tabController;
  String searchText = "";
  final TextEditingController search = TextEditingController();
  late Future<List<ItemModel>> _listItems;
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
    getData();
    _refreshListener = () {
      if (refreshStockNotifier.value) {
        getData();
        refreshStockNotifier.value = false;
      }
    };

    refreshStockNotifier.addListener(_refreshListener);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didPopNext() {
    // Dipanggil setiap kali user balik ke halaman ini dari halaman lain
    getData();
    super.didPopNext();
  }

  getData() async {
    _listItems = DBHelper.getAllItems();
    _dataTotal = await DBHelper.getItemsTotal();
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    refreshStockNotifier.removeListener(_refreshListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
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
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                    backgroundColor: AppColor.surfaceLight,
                  ),
                  onPressed: () {
                    context.pushRoute(StockCreateRoute());
                  },
                  icon: Icon(FontAwesomeIcons.gear),
                ),
              ),
              h(24),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: CupertinoSearchTextField(
                      backgroundColor: AppColor.surfaceLight,
                      prefixInsets: EdgeInsetsGeometry.all(12),
                      borderRadius: BorderRadius.circular(12),
                      controller: search,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(
                      FontAwesomeIcons.filter,
                      size: 20,
                      color: AppColor.primaryTextLight,
                    ),
                  ),
                ],
              ),
              h(16),
              FutureBuilder(
                future: _listItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData ||
                      (snapshot.data as List).isEmpty) {
                    return const Center(child: Text("Tidak ada data"));
                  } else {
                    final data = snapshot.data as List<ItemModel>;
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
                                gradient: LinearGradient(
                                  colors: AppColor.primaryGradient,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  _tabController.animateTo(0);
                                },

                                child: Text(
                                  "All (${_dataTotal['Total Product'].toString()})",
                                  style: TextStyle(color: Color(0xffffffff)),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _tabController.animateTo(1);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.surfaceLight,
                                side: BorderSide(color: AppColor.borderLight),
                              ),
                              child: Text(
                                "Low Stock (${_dataTotal['Low Stock'].toString()})",
                                style: TextStyle(
                                  color: AppColor.primaryTextLightOpacity80,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _tabController.animateTo(2);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.surfaceLight,
                                side: BorderSide(color: AppColor.borderLight),
                              ),
                              child: Text(
                                "Out (${_dataTotal['Low Stock'].toString()})",
                                style: TextStyle(
                                  color: AppColor.primaryTextLightOpacity80,
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
                                        color: Color(0x208b5cf6),
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        begin: AlignmentGeometry.topLeft,
                                        end: AlignmentGeometry.bottomRight,
                                        colors: [
                                          Color(0x208B5CF6),
                                          Color(0x207C3AED),
                                        ],
                                      ),
                                    ),
                                    // color: Color(0x207c3aed),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        // horizontal: 24,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            data.length.toString(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: AppColor.primaryTextLight,
                                            ),
                                          ),
                                          h(28),
                                          Text(
                                            "Total",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor
                                                  .primaryTextLightOpacity80,
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
                                        color: Color(0x2010b981),
                                      ),
                                      gradient: LinearGradient(
                                        begin: AlignmentGeometry.topLeft,
                                        end: AlignmentGeometry.bottomRight,
                                        colors: [
                                          Color(0x2010b981),
                                          Color(0x20059669),
                                        ],
                                      ),
                                    ),
                                    // color: Color(0x207c3aed),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        // horizontal: 24,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            _dataTotal['In Stock'].toString(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: AppColor.primaryTextLight,
                                            ),
                                          ),
                                          h(28),
                                          Text(
                                            "In Stock",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor
                                                  .primaryTextLightOpacity80,
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
                                        color: Color(0x20f59e0b),
                                      ),
                                      gradient: LinearGradient(
                                        begin: AlignmentGeometry.topLeft,
                                        end: AlignmentGeometry.bottomRight,
                                        colors: [
                                          Color(0x20f59e0b),
                                          Color(0x20d97706),
                                        ],
                                      ),
                                    ),
                                    // color: Color(0x207c3aed),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        // horizontal: 24,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            _dataTotal['Low Stock'].toString(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Color(0xff101828),
                                            ),
                                          ),
                                          h(28),
                                          Text(
                                            "Low",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0x80101828),
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
                                        color: Color(0x20ef4444),
                                      ),
                                      gradient: LinearGradient(
                                        begin: AlignmentGeometry.topLeft,
                                        end: AlignmentGeometry.bottomRight,
                                        colors: [
                                          Color(0x20ef4444),
                                          Color(0x20dc2626),
                                        ],
                                      ),
                                    ),
                                    // color: Color(0x207c3aed),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        // horizontal: 24,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            _dataTotal['Out of Stock']
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Color(0xff101828),
                                            ),
                                          ),
                                          h(28),
                                          Text(
                                            "Out Stock",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0x80101828),
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
                                color: Color(0xff101828),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.4, // misal 70% tinggi layar
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              _tabContent("Tab 1 Content"),
                              _tabContent("Tab 2 Content"),
                              _tabContent("Tab 3 Content"),
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

  Widget _tabContent(String text) {
    // Scroll masing-masing tab
    return FutureBuilder(
      future: _listItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Center(child: Text("Tidak ada data"));
        } else {
          final data = snapshot.data as List<ItemModel>;
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                color: Colors.white,
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
                                  color: Color(0xff101828),
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                item.categoryName!,
                                style: TextStyle(
                                  color: Color(0x60101828),
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
                                      StockCreateRoute(
                                        isUpdate: true,
                                        item: item,
                                      ),
                                    )
                                    .then((_) {
                                      if (mounted) getData();
                                    });
                              } else if (v == 1) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Konfirmasi"),
                                      content: Text(
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
                                          onPressed: () {
                                            // Perform action on confirmation
                                            DBHelper.deleteItems(item.id!);
                                            refreshStockNotifier.value = true;
                                            Navigator.of(
                                              context,
                                            ).pop(); // Dismiss the dialog
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            itemBuilder: (context) => <PopupMenuEntry<int>>[
                              const PopupMenuItem<int>(
                                value: 0,
                                child: Text('Edit Item'),
                              ),
                              const PopupMenuItem<int>(
                                value: 1,
                                child: Text('Delete Item'),
                              ),
                            ],
                            icon: Icon(
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
                                      color: Color(0x60101828),
                                    ),
                                  ),
                                  Text(
                                    item.stock.toString(),
                                    style: TextStyle(color: Color(0xff101828)),
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
                                      color: Color(0x60101828),
                                    ),
                                  ),
                                  Text(
                                    "Rp ${item.sellingPrice}",
                                    style: TextStyle(color: Color(0xff8B5CF6)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              Icon(
                                FontAwesomeIcons.arrowTrendUp,
                                color: Color(0xff00c950),
                                size: 16,
                              ),
                              Text(
                                "+12",
                                style: TextStyle(color: Color(0xff00c950)),
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
      },
    );
  }
}
