import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/components/app_container.dart';
import 'package:invengo/components/page_header.dart';
import 'package:invengo/components/spacing_helper.dart';
import 'package:invengo/constant/app_color.dart';
import 'package:invengo/route.dart';
import 'package:standard_searchbar/old/standard_searchbar.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchText = "";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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
                    context.pushRoute(StockManagementRoute());
                  },
                  icon: Icon(FontAwesomeIcons.gear),
                ),
              ),
              h(24),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: AnimatedSearchBar(
                      label: 'Search Something Here',
                      controller: _controller,
                      labelStyle: const TextStyle(fontSize: 16),
                      searchStyle: const TextStyle(
                        color: AppColor.primaryTextLight,
                      ),
                      cursorColor: Colors.white,
                      textInputAction: TextInputAction.done,
                      autoFocus: true,
                      searchDecoration: const InputDecoration(
                        hintText: 'Search',
                        alignLabelWithHint: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        debugPrint('value on Change');
                        setState(() {
                          searchText = value;
                        });
                      },
                      onFieldSubmitted: (value) {
                        debugPrint('value on Field Submitted');
                        setState(() {
                          searchText = value;
                        });
                      },
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
                        "All (6)",
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
                      "Low Stock (2)",
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
                      "Out (1)",
                      style: TextStyle(
                        color: AppColor.primaryTextLightOpacity80,
                      ),
                    ),
                  ),
                ],
              ),
              h(16),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0x208b5cf6)),
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: AlignmentGeometry.topLeft,
                          end: AlignmentGeometry.bottomRight,
                          colors: [Color(0x208B5CF6), Color(0x207C3AED)],
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
                              "6",
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
                                color: AppColor.primaryTextLightOpacity80,
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
                        border: Border.all(color: Color(0x2010b981)),
                        gradient: LinearGradient(
                          begin: AlignmentGeometry.topLeft,
                          end: AlignmentGeometry.bottomRight,
                          colors: [Color(0x2010b981), Color(0x20059669)],
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
                              "3",
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
                                color: AppColor.primaryTextLightOpacity80,
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
                        border: Border.all(color: Color(0x20f59e0b)),
                        gradient: LinearGradient(
                          begin: AlignmentGeometry.topLeft,
                          end: AlignmentGeometry.bottomRight,
                          colors: [Color(0x20f59e0b), Color(0x20d97706)],
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
                              "2",
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
                        border: Border.all(color: Color(0x20ef4444)),
                        gradient: LinearGradient(
                          begin: AlignmentGeometry.topLeft,
                          end: AlignmentGeometry.bottomRight,
                          colors: [Color(0x20ef4444), Color(0x20dc2626)],
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
                              "6",
                              style: TextStyle(
                                fontSize: 24,
                                color: Color(0xff101828),
                              ),
                            ),
                            h(28),
                            Text(
                              "Total",
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
                "Product (6)",
                style: TextStyle(fontSize: 18, color: Color(0xff101828)),
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
          ),
        ),
      ),
    );
  }

  Widget _tabContent(String text) {
    // Scroll masing-masing tab
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 10,
      itemBuilder: (context, index) => Card(
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
                        "Kopi Sachet",
                        style: TextStyle(
                          color: Color(0xff101828),
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Minuman",
                        style: TextStyle(
                          color: Color(0x60101828),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    FontAwesomeIcons.ellipsisVertical,
                    color: Color(0xff99A1AF),
                    size: 20,
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
                            "20",
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
                            "Rp 5.000",
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
                      Text("+12", style: TextStyle(color: Color(0xff00c950))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
