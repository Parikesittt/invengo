import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/components/app_container.dart';
import 'package:invengo/components/custom_button.dart';
import 'package:invengo/components/spacing_helper.dart';
import 'package:invengo/constant/app_color.dart';
import 'package:invengo/constant/app_text_style.dart';
import 'package:invengo/database/db_helper.dart';
import 'package:invengo/model/item_model.dart';
import 'package:invengo/route.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:standard_searchbar/old/standard_searchbar.dart';

@RoutePage()
class StockManagementPage extends StatefulWidget {
  const StockManagementPage({super.key});

  @override
  State<StockManagementPage> createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  late Future<List<ItemModel>> _listItems;
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    _listItems = DBHelper.getAllItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kelola Barang",
              style: TextStyle(color: AppColor.primaryTextLight, fontSize: 14),
            ),
            Text(
              "5 produk terdaftar",
              style: TextStyle(
                color: AppColor.primaryTextLightOpacity80,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: AppContainer(
              gradient: LinearGradient(colors: AppColor.primaryGradient),
              padding: EdgeInsets.zero,
              height: 40,
              width: 40,
              child: InkWell(
                onTap: () {
                  context.router.pushNamed('/stock_create');
                },
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: AppColor.surfaceLight,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoSearchTextField(
                backgroundColor: AppColor.surfaceLight,
                prefixInsets: EdgeInsetsGeometry.all(12),
                borderRadius: BorderRadius.circular(12),
                controller: search,
              ),
              h(24),
              SizedBox(
                height: screenHeight * 0.8,
                child: FutureBuilder(
                  future: _listItems,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData ||
                        (snapshot.data as List).isEmpty) {
                      return const Center(child: Text("Tidak ada data"));
                    } else {
                      final data = snapshot.data as List<ItemModel>;
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = data[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: AppTextStyle.h4),
                                  h(4),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF3F4F6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item.categoryName!,
                                      style: AppTextStyle.label,
                                    ),
                                  ),
                                  h(12),
                                  Row(
                                    spacing: 32,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Stock", style: AppTextStyle.p),
                                          Text(
                                            item.stock.toString(),
                                            style: AppTextStyle.p,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Price", style: AppTextStyle.p),
                                          Text(
                                            "Rp ${item.sellingPrice.toString()}",
                                            style: AppTextStyle.pPrice,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            // context.router.push(StockCreateRoute())
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              gradient: LinearGradient(
                                                colors:
                                                    AppColor.primaryGradient,
                                              ),
                                            ),
                                            child: Row(
                                              spacing: 12,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.pencil,
                                                  color: AppColor.surfaceLight,
                                                  size: 16,
                                                ),
                                                Text(
                                                  "Edit",
                                                  style: AppTextStyle.button,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        color: Colors.red,
                                        onPressed: () {},
                                        icon: Icon(FontAwesomeIcons.trashCan),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
