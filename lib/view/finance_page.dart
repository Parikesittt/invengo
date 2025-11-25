import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/shared/widgets/app_container.dart';
import 'package:invengo/shared/widgets/page_header.dart';
import 'package:invengo/core/constant/spacing_helper.dart';
import 'package:invengo/core/constant/app_color.dart';
import 'package:invengo/core/constant/app_text_style.dart';
import 'package:invengo/core/constant/rupiah_formatting.dart';
import 'package:invengo/core/services/db_helper.dart';
import 'package:invengo/data/models/transaction_model.dart';

@RoutePage()
class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage>
    with SingleTickerProviderStateMixin {
  late Future<List<TransactionModel>> _listTrans;
  late TabController _tabController;
  Map<String, dynamic>? _dataFinance;
  int expenses = 0;
  int revenue = 0;
  int profit = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    _listTrans = DBHelper.getAllTransaction();
    _dataFinance = await DBHelper.getTotalTransaction();
    print(_dataFinance);
    if (_dataFinance != null) {
      expenses = int.tryParse(_dataFinance!['expenses'].toString()) ?? 0;
      revenue = int.tryParse(_dataFinance!['revenue'].toString()) ?? 0;
      profit = int.tryParse(_dataFinance!['profit'].toString()) ?? 0;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
          child: Column(
            children: [
              PageHeader(
                title: "Finance",
                subtitle: "Track your revenue & expenses",
                trailing: Icon(FontAwesomeIcons.download),
              ),
              h(32),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: AlignmentGeometry.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff8C5CF5), Color(0xffEB489A)],
                  ),
                ),
                child: Column(
                  spacing: 40,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Net Profit",
                              style: TextStyle(
                                color: Color(0x80ffffff),
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Rp ${formatRupiahWithoutSymbol(profit)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          color: Colors.white24,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              spacing: 6,
                              children: [
                                Icon(
                                  FontAwesomeIcons.arrowTrendUp,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                Text(
                                  "+31.8%",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: Card(
                            color: Colors.white24,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 6,
                                    children: [
                                      Icon(
                                        Icons.arrow_outward,
                                        size: 16,
                                        color: Color(0xff7BF1A8),
                                      ),
                                      Text(
                                        "Revenue",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  h(8),
                                  Text(
                                    'Rp ${formatRupiahWithoutSymbol(revenue)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  h(4),
                                  Text(
                                    "+23.5%",
                                    style: TextStyle(color: Color(0xff7BF1A8)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            color: Colors.white24,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 6,
                                    children: [
                                      RotatedBox(
                                        quarterTurns: 1,
                                        child: Icon(
                                          Icons.arrow_outward,
                                          size: 16,
                                          color: Color(0xff7BF1A8),
                                        ),
                                      ),
                                      Text(
                                        "Expenses",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  h(8),
                                  Text(
                                    'Rp ${formatRupiahWithoutSymbol(expenses)}',

                                    // _dataFinance?['expenses']?.toString() ??
                                    //     '0',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  h(4),
                                  Text(
                                    "-8.2%",
                                    style: TextStyle(color: Color(0xff7BF1A8)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              h(32),
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
                        "Week",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _tabController.animateTo(1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,

                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      "Month",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _tabController.animateTo(2);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      "Year",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              h(32),
              SizedBox(
                height: screenHeight * 0.6,
                child: TabBarView(
                  controller: _tabController,
                  children: [_tabContent(), _tabContent(), _tabContent()],
                ),
              ),
              // height(4),
              SizedBox(
                height: screenHeight * 0.73,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Transaction",
                          style: AppTextStyle.sectionTitle(context),
                        ),
                        TextButton(onPressed: () {}, child: Text("View All")),
                      ],
                    ),
                    FutureBuilder(
                      future: _listTrans,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (!snapshot.hasData ||
                            (snapshot.data as List).isEmpty) {
                          return const Center(child: Text("Tidak ada data"));
                        } else {
                          final data = snapshot.data as List<TransactionModel>;
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: data.length > 5 ? 5 : data.length,
                            itemBuilder: (context, index) {
                              final item = data[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: EdgeInsets.all(12),
                                  tileColor: Theme.of(
                                    context,
                                  ).colorScheme.surface,
                                  leading: item.transactionType == 0
                                      ? RotatedBox(
                                          quarterTurns: 1,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            color: Color(0xffccf4dc),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                12.0,
                                              ),
                                              child: Icon(
                                                Icons.arrow_outward,
                                                color: Color(0xff05df72),
                                              ),
                                            ),
                                          ),
                                        )
                                      : RotatedBox(
                                          quarterTurns: 0,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            color: Color(0xffccf4dc),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                12.0,
                                              ),
                                              child: Icon(
                                                Icons.arrow_outward,
                                                color: Color(0xff05df72),
                                              ),
                                            ),
                                          ),
                                        ),
                                  title: Text(
                                    "${item.itemName} ${item.transactionType == 0 ? 'Added Stock' : 'Sale'}",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Row(
                                    spacing: 2,
                                    children: [
                                      Text(
                                        "Minuman",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "-",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Oct 25, 2025",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    '${item.transactionType == 0 ? "-" : "+"} Rp ${formatRupiahWithoutSymbol(item.total)}',
                                    style: TextStyle(
                                      color: Color(0xff05df72),
                                      fontSize: 14,
                                    ),
                                  ),
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

  Widget _tabContent() {
    // Scroll masing-masing tab
    return Column(
      spacing: 32,
      children: [
        AppContainer(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Revenue vs Expenses",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Row(
                        spacing: 2,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Text(
                            "Income",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 2,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Color(0xffEC4899),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Text(
                            "Expense",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Image.asset('assets/images/bar_chart_dummy.png'),
            ],
          ),
        ),
        AppContainer(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 40,
            children: [
              Text("Weekly Trend", style: AppTextStyle.sectionTitle(context)),
              Image.asset('assets/images/line_chart_dummy.png'),
            ],
          ),
        ),
      ],
    );
  }
}
