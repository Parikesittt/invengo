import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/components/page_header.dart';
import 'package:invengo/components/spacing_helper.dart';

@RoutePage()
class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
                              "Rp 3.000.000",
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
                                    "Rp 4.000.000",
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
                                    "Rp 1.000.000",
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
                        colors: [Color(0xff8C5CF5), Color(0xffeb489a)],
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _tabController.animateTo(0);
                      },

                      child: Text(
                        "Week",
                        style: TextStyle(color: Color(0xffffffff)),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _tabController.animateTo(1);
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Color(0xffe5e7eb)),
                    ),
                    child: Text(
                      "Month",
                      style: TextStyle(color: Color(0x80101828)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _tabController.animateTo(2);
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Color(0xffe5e7eb)),
                    ),
                    child: Text(
                      "Year",
                      style: TextStyle(color: Color(0x80101828)),
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
                        Text("Recent Transaction"),
                        TextButton(onPressed: () {}, child: Text("View All")),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(12),
                            tileColor: Colors.white,
                            leading: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              color: Color(0xffccf4dc),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  Icons.arrow_outward,
                                  color: Color(0xff05df72),
                                ),
                              ),
                            ),
                            title: Text(
                              "Kopi Sachet Sale",
                              style: TextStyle(
                                color: Color(0xff101828),
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Row(
                              spacing: 2,
                              children: [
                                Text(
                                  "Minuman",
                                  style: TextStyle(
                                    color: Color(0x60101828),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "-",
                                  style: TextStyle(
                                    color: Color(0x60101828),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "Oct 25, 2025",
                                  style: TextStyle(
                                    color: Color(0x60101828),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              "+Rp 5.000",
                              style: TextStyle(
                                color: Color(0xff05df72),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
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
        Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Revenue vs Expenses"),
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
                                color: Color(0xff8B5CF6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Text(
                              "Income",
                              style: TextStyle(color: Color(0x60101828)),
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
                              style: TextStyle(color: Color(0x60101828)),
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
        ),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 40,
              children: [
                Text(
                  "Weekly Trend",
                  style: TextStyle(
                    color: Color(0xff101828),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset('assets/images/line_chart_dummy.png'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
