import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/components/dashboard/activity_tile.dart';
import 'package:invengo/components/dashboard/info_card.dart';
import 'package:invengo/components/dashboard/low_stock_card.dart';
import 'package:invengo/components/page_header.dart';
import 'package:invengo/components/spacing_helper.dart';
import 'package:invengo/constant/app_color.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f4ff),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 48.0, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PageHeader(
                title: "Invengo",
                subtitle: "Welcome back, Admin",
                trailing: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: AppColor.primaryGradient),
                  ),
                  alignment: AlignmentGeometry.center,
                  child: Text("A", style: TextStyle(color: Colors.white)),
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
                      value: "24",
                      label: "Total Product",
                      percentage: "+12%",
                      percentageColor: AppColor.iconTrendUp,
                    ),
                  ),
                  Expanded(
                    child: InfoCard(
                      icon: FontAwesomeIcons.users,
                      iconBgColor: Color(0xffEF9509),
                      value: "24",
                      label: "Total Product",
                      percentage: "+12%",
                      percentageColor: AppColor.iconTrendUp,
                    ),
                  ),
                  Expanded(
                    child: InfoCard(
                      icon: FontAwesomeIcons.dollarSign,
                      iconBgColor: Color(0xff0EB07B),
                      value: "24",
                      label: "Total Product",
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.borderLight),
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
                                color: AppColor.primaryTextLight,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Last 30 days",
                              style: TextStyle(
                                color: AppColor.primaryTextLightOpacity60,
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
                        color: Colors.white,
                        border: Border.all(color: AppColor.borderLight),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text("Categories"),
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
                                      color: AppColor.primary,
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
                        {'name': 'Product A', 'stock': 5, 'max': 20},
                        {'name': 'Product B', 'stock': 2, 'max': 15},
                        {'name': 'Product C', 'stock': 8, 'max': 30},
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
                        Text("Recent Activity"),
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
                    ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ActivityTile(
                          title: "Stock Added",
                          subtitle: "Kopi Sachet",
                          value: "+12",
                          time: "2h ago",
                          icon: Icons.trending_up,
                          iconColor: AppColor.iconTrendUp,
                          bgColor: Color(0x2000C950),
                        ),
                        h(8),
                        ActivityTile(
                          title: "Stock Added",
                          subtitle: "Kopi Sachet",
                          value: "+12",
                          time: "2h ago",
                          icon: Icons.trending_up,
                          iconColor: AppColor.iconTrendUp,
                          bgColor: Color(0x2000C950),
                        ),
                        h(8),
                        ActivityTile(
                          title: "Stock Added",
                          subtitle: "Kopi Sachet",
                          value: "+12",
                          time: "2h ago",
                          icon: Icons.trending_up,
                          iconColor: AppColor.iconTrendUp,
                          bgColor: Color(0x2000C950),
                        ),
                      ],
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
