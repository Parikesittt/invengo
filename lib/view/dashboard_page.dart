import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:invengo/components/dashboard/activity_tile.dart';
import 'package:invengo/components/dashboard/info_card.dart';
import 'package:invengo/components/dashboard/low_stock_card.dart';
import 'package:invengo/components/page_header.dart';
import 'package:invengo/components/spacing_helper.dart';
import 'package:invengo/constant/app_color.dart';
import 'package:invengo/constant/app_text_style.dart';
import 'package:invengo/database/db_helper.dart';
import 'package:invengo/model/transaction_model.dart';
import 'package:invengo/preferences/preference_handler.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int? totalProduct;
  int? lowStock;
  int? outStock;
  String? username;
  Map<String, dynamic>? stockData;
  Map<String, dynamic>? financeData;
  late Future<List<TransactionModel>> transactionFuture;
  final NumberFormat formatter = NumberFormat("#,###", "id_ID");

  @override
  void initState() {
    super.initState();
    PreferenceHandler.getUsername().then((value) {
      setState(() {
        username = value ?? 'Guest';
      });
    });
    getData();
  }

  getUserData() async {
    username = await PreferenceHandler.getUsername();
  }

  Future<void> getData() async {
    transactionFuture = DBHelper.getAllTransaction();
    final data = await DBHelper.getItemsTotal();
    final finance = await DBHelper.getTotalTransaction();
    setState(() {
      stockData = data;
      financeData = finance;
      print(financeData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 48.0,
            left: 24,
            right: 24,
            bottom: 120,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PageHeader(
                title: "Invengo",
                subtitle: "Welcome back, $username",
                trailing: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: AppColor.primaryGradient),
                  ),
                  alignment: AlignmentGeometry.center,
                  child: Text(
                    (username ?? 'Guest')[0].toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              h(32),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: InfoCard(
                      icon: FontAwesomeIcons.boxOpen,
                      iconBgColor: AppColor.primary,
                      value: stockData?['Total Product']?.toString() ?? '0',
                      label: "Total Product",
                      percentage: "+12%",
                      percentageColor: AppColor.iconTrendUp,
                    ),
                  ),
                  Expanded(
                    child: InfoCard(
                      icon: FontAwesomeIcons.triangleExclamation,
                      iconBgColor: Color(0xffEF9509),
                      value: stockData?['Low Stock']?.toString() ?? '0',
                      label: "Low Stock",
                      percentage: "+12%",
                      percentageColor: AppColor.iconTrendUp,
                    ),
                  ),
                  Expanded(
                    child: InfoCard(
                      icon: FontAwesomeIcons.rupiahSign,
                      iconBgColor: Color(0xff0EB07B),
                      value: "Rp ${formatter.format(num.tryParse(financeData?['profit']?.toString() ?? '0') ?? 0)}",
                      label: "Profit",
                      percentage: "+12%",
                      percentageColor: AppColor.iconTrendUp,
                    ),
                  ),
                ],
              ),
              h(32),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Revenue Overview",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Last 30 days",
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: AppColor.iconTrendUp,
                            ),
                            Text(
                              "+12%",
                              style: TextStyle(color: AppColor.iconTrendUp),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Image.asset('assets/images/chart_dummy.png'),
                  ],
                ),
              ),
              h(32),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: Container(
                      height: 294,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Categories",
                            style: AppTextStyle.sectionTitle(context),
                          ),
                          h(36),
                          Image.asset('assets/images/pie_chart_dummy.png'),
                          h(24),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  w(8),
                                  Text("Test"),
                                  w(32),
                                  Text("55%"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffEC4899),
                                    ),
                                  ),
                                  w(8),
                                  Text("Test"),
                                  w(32),
                                  Text("55%"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff06B6D4),
                                    ),
                                  ),
                                  w(8),
                                  Text("Test"),
                                  w(32),
                                  Text("55%"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: LowStockCard(
                      items: [
                        {'name': 'Indocafe', 'stock': 5, 'max': 20},
                        {'name': 'Good Day', 'stock': 2, 'max': 15},
                        {'name': 'Cilok Isi', 'stock': 8, 'max': 30},
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Recent Activity",
                          style: AppTextStyle.sectionTitle(context),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "View All",
                                style: TextStyle(color: AppColor.primary),
                              ),
                            ),
                            Icon(
                              Icons.arrow_outward,
                              color: AppColor.primary,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                    // height(12),
                    FutureBuilder(
                      future: transactionFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No transactions found.'));
                        } else {
                          final transactions =
                              snapshot.data as List<TransactionModel>;
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: transactions.length > 5
                                ? 5
                                : transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = transactions[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ActivityTile(
                                  title: transaction.transactionType == 0
                                      ? "Stock Added"
                                      : "Stock Saled",
                                  subtitle: transaction.itemName!,
                                  value:
                                      "${transaction.transactionType == 0 ? '+' : '-'}${transaction.quantity}",
                                  time: "",
                                  icon: transaction.transactionType == 0
                                      ? Icons.trending_down
                                      : Icons.trending_up,
                                  iconColor: transaction.transactionType == 0
                                      ? AppColor.iconTrenDown
                                      : AppColor.iconTrendUp,
                                  bgColor: transaction.transactionType == 0
                                      ? Color(0x202B7FFF)
                                      : Color(0x2000C950),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
