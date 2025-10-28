import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Invengo",
                        style: TextStyle(
                          fontSize: 28,
                          color: Color(0xff101828),
                        ),
                      ),
                      Text(
                        "Welcome back, Admin",
                        style: TextStyle(color: Color(0x60101828)),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xff8C5CF5), Color(0xffEB489A)],
                      ),
                    ),
                    alignment: AlignmentGeometry.center,
                    child: Text("A", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              height(32),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xffe5e7eb)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 202,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(0xff8043EF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              FontAwesomeIcons.boxOpen,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          height(24),
                          Text("24", style: TextStyle(fontSize: 18)),
                          height(24),
                          Text(
                            "Total Product",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0x60101828),
                            ),
                          ),
                          height(24),
                          Row(
                            children: [
                              Icon(Icons.trending_up, color: Color(0xff05DF72)),
                              Text(
                                "+12%",
                                style: TextStyle(color: Color(0xff05DF72)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xffe5e7eb)),
                      ),
                      height: 202,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(0xffEF9509),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              FontAwesomeIcons.triangleExclamation,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          height(24),
                          Text("24", style: TextStyle(fontSize: 18)),
                          height(24),
                          Text(
                            "Total Product",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0x60101828),
                            ),
                          ),
                          height(24),
                          Row(
                            children: [
                              Icon(Icons.trending_up, color: Color(0xff05DF72)),
                              Text(
                                "+12%",
                                style: TextStyle(color: Color(0xff05DF72)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xffe5e7eb)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 202,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(0xff0EB07B),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              FontAwesomeIcons.dollarSign,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          height(24),
                          Text("24", style: TextStyle(fontSize: 18)),
                          height(24),
                          Text(
                            "Total Product",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0x60101828),
                            ),
                          ),
                          height(24),
                          Row(
                            children: [
                              Icon(Icons.trending_up, color: Color(0xff05DF72)),
                              Text(
                                "+12%",
                                style: TextStyle(color: Color(0xff05DF72)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              height(32),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xffe5e7eb)),
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
                                color: Color(0xff101828),
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Last 30 days",
                              style: TextStyle(
                                color: Color(0x60101828),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Icon(Icons.trending_up, color: Color(0xff05DF72)),
                            Text(
                              "+12%",
                              style: TextStyle(color: Color(0xff05DF72)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Image.asset('assets/images/chart_dummy.png'),
                  ],
                ),
              ),
              height(32),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: Container(
                      height: 294,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xffe5e7eb)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text("Categories"),
                          height(36),
                          Image.asset('assets/images/pie_chart_dummy.png'),
                          height(24),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xff8B5CF6),
                                    ),
                                  ),
                                  width(8),
                                  Text("Test"),
                                  width(32),
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
                                  width(8),
                                  Text("Test"),
                                  width(32),
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
                                  width(8),
                                  Text("Test"),
                                  width(32),
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
                    child: Container(
                      height: 294,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        gradient: LinearGradient(
                          begin: AlignmentGeometry.topLeft,
                          end: AlignmentGeometry.bottomRight,
                          colors: [Color(0xffFEF2C5), Color(0xffFDE78C)],
                        ),
                        border: Border.all(color: Color(0x30F59E0B)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.triangleExclamation,
                                size: 16,
                                color: Color(0xffF59E0B),
                              ),
                              width(8),
                              Text("Low Stock"),
                            ],
                          ),
                          height(36),
                          Column(
                            spacing: 12,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Kopi Sachet"),
                                      Spacer(),
                                      Text("5/50"),
                                    ],
                                  ),
                                  height(4),
                                  Container(
                                    height: 4,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Expanded(child: Divider(thickness: 4)),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Kopi Sachet"),
                                      Spacer(),
                                      Text("5/50"),
                                    ],
                                  ),
                                  height(4),
                                  Container(
                                    height: 4,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Expanded(child: Divider(thickness: 4)),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Kopi Sachet"),
                                      Spacer(),
                                      Text("5/50"),
                                    ],
                                  ),
                                  height(4),
                                  Container(
                                    height: 4,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Expanded(child: Divider(thickness: 4)),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Kopi Sachet"),
                                      Spacer(),
                                      Text("5/50"),
                                    ],
                                  ),
                                  height(4),
                                  Container(
                                    height: 4,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Expanded(child: Divider(thickness: 4)),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Kopi Sachet"),
                                      Spacer(),
                                      Text("5/50"),
                                    ],
                                  ),
                                  height(4),
                                  Container(
                                    height: 4,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Expanded(child: Divider(thickness: 4)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
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
                                style: TextStyle(color: Color(0xff8B5CF6)),
                              ),
                            ),
                            Icon(
                              Icons.arrow_outward,
                              color: Color(0xff8B5CF6),
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                    // height(12),
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          // minVerticalPadding: 15,
                          titleTextStyle: TextStyle(
                            fontSize: 13.7,
                            color: Color(0xff101828),
                          ),
                          // minTileHeight: 66,
                          subtitleTextStyle: TextStyle(
                            color: Color(0x60101828),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: Color(0xffe5e7eb)),
                          ),
                          tileColor: Colors.white,
                          leading: Container(
                            // margin: EdgeInsets.all(13),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0x2000C950),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.trending_up,
                              color: Color(0xff05DF72),
                              size: 20,
                            ),
                          ),
                          title: Text("Stock Added"),
                          subtitle: Text("Kopi Sachet"),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "+12",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff101828),
                                ),
                              ),
                              Text(
                                "2h ago",
                                style: TextStyle(
                                  color: Color(0x60101828),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        height(8),
                        ListTile(
                          // minVerticalPadding: 15,
                          titleTextStyle: TextStyle(
                            fontSize: 13.7,
                            color: Color(0xff101828),
                          ),
                          // minTileHeight: 66,
                          subtitleTextStyle: TextStyle(
                            color: Color(0x60101828),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: Color(0xffe5e7eb)),
                          ),
                          tileColor: Colors.white,
                          leading: Container(
                            // margin: EdgeInsets.all(13),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0x2000C950),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.trending_up,
                              color: Color(0xff05DF72),
                              size: 20,
                            ),
                          ),
                          title: Text("Stock Added"),
                          subtitle: Text("Kopi Sachet"),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "+12",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff101828),
                                ),
                              ),
                              Text(
                                "2h ago",
                                style: TextStyle(
                                  color: Color(0x60101828),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        height(8),
                        ListTile(
                          // minVerticalPadding: 15,
                          titleTextStyle: TextStyle(
                            fontSize: 13.7,
                            color: Color(0xff101828),
                          ),
                          // minTileHeight: 66,
                          subtitleTextStyle: TextStyle(
                            color: Color(0x60101828),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: Color(0xffe5e7eb)),
                          ),
                          tileColor: Colors.white,
                          leading: Container(
                            // margin: EdgeInsets.all(13),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0x2000C950),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.trending_up,
                              color: Color(0xff05DF72),
                              size: 20,
                            ),
                          ),
                          title: Text("Stock Added"),
                          subtitle: Text("Kopi Sachet"),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "+12",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff101828),
                                ),
                              ),
                              Text(
                                "2h ago",
                                style: TextStyle(
                                  color: Color(0x60101828),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
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

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);
}
