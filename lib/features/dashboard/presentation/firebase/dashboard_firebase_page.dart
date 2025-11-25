import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:invengo/core/services/firebase.dart';
import 'package:invengo/data/models/transaction_firebase_model.dart';
import 'package:invengo/features/dashboard/presentation/widgets/activity_tile.dart';
import 'package:invengo/features/dashboard/presentation/widgets/category_pie_chart.dart';
import 'package:invengo/features/dashboard/presentation/widgets/info_card.dart';
import 'package:invengo/features/dashboard/presentation/widgets/low_stock_card.dart';
import 'package:invengo/shared/widgets/page_header.dart';
import 'package:invengo/core/constant/spacing_helper.dart';
import 'package:invengo/core/constant/app_color.dart';
import 'package:invengo/core/constant/app_text_style.dart';
import 'package:invengo/core/services/db_helper.dart';
import 'package:invengo/data/models/transaction_model.dart';
import 'package:invengo/core/services/preference_handler.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

@RoutePage()
class DashboardFirebasePage extends StatefulWidget {
  const DashboardFirebasePage({super.key});

  @override
  State<DashboardFirebasePage> createState() => _DashboardFirebasePageState();
}

class _DashboardFirebasePageState extends State<DashboardFirebasePage> {
  int? totalProduct;
  int? lowStock;
  int? outStock;
  String? username;
  Map<String, dynamic>? stockData;
  Map<String, dynamic>? financeData;
  late Future<List<TransactionFirebaseModel>> transactionFuture;
  final NumberFormat formatter = NumberFormat("#,###", "id_ID");
  List<FlSpot> revenueSpots = [];
  List<FlSpot> expenseSpots = [];
  List<String> chartLabels = [];

  @override
  void initState() {
    super.initState();

    // safe async: check `mounted` before calling setState
    PreferenceHandler.getUsername()
        .then((value) {
          if (!mounted) return;
          setState(() {
            username = value ?? 'Guest';
          });
        })
        .catchError((e) {
          // optional: log error, but don't call setState if not mounted
          // print('Failed to get username: $e');
        });

    // start loading data (non-blocking)
    transactionFuture = FirebaseService.getAllTransaction();
    _loadDataSafely();
  }

  // keep a separate async function that checks `mounted` before setState
  Future<void> _loadDataSafely() async {
    try {
      // we already started transactionFuture above, so no need to await it here
      final data = await FirebaseService.getItemsTotal();
      final finance = await FirebaseService.getTotalTransaction();
      await _prepareChartData();

      // important: don't call setState if disposed
      if (!mounted) return;
      setState(() {
        stockData = data;
        financeData = finance;
        // debug print ok, but keep it outside setState ideally
      });
    } catch (e, st) {
      // handle or log error; don't call setState unless mounted
      // print('Error loading dashboard data: $e\n$st');
      if (!mounted) return;
      setState(() {
        // you might want to set an error state or keep previous values
      });
    }
  }

  @override
  void dispose() {
    // If you add timers/listeners/subscriptions later, cancel them here.
    super.dispose();
  }

  // You can keep other helper functions but always check mounted before setState
  getUserData() async {
    final name = await PreferenceHandler.getUsername();
    if (!mounted) return;
    setState(() {
      username = name;
    });
  }

  Future<void> _prepareChartData() async {
    try {
      final allTrans =
          await FirebaseService.getAllTransaction(); // returns TransactionFirebaseModel list
      // focus on last 30 days
      final now = DateTime.now();
      final start = now.subtract(const Duration(days: 29)); // 30 days inclusive

      // initialize daily buckets
      final Map<String, num> revenueByDay = {};
      final Map<String, num> expenseByDay = {};

      for (int i = 0; i < 30; i++) {
        final day = start.add(Duration(days: i));
        final key = DateFormat('yyyy-MM-dd').format(day);
        revenueByDay[key] = 0;
        expenseByDay[key] = 0;
      }

      for (final t in allTrans) {
        if (t.createdAt == null) continue;
        DateTime? dt;
        try {
          dt = DateTime.parse(t.createdAt!);
        } catch (_) {
          // fallback: ignore unparsable timestamps
          continue;
        }
        if (dt.isBefore(start) || dt.isAfter(now)) continue;
        final key = DateFormat('yyyy-MM-dd').format(dt);
        // transactionType: 0 = expense (stock in), 1 = revenue (stock out)
        if (t.transactionType == 1) {
          revenueByDay[key] = (revenueByDay[key] ?? 0) + (t.total ?? 0);
        } else {
          expenseByDay[key] = (expenseByDay[key] ?? 0) + (t.total ?? 0);
        }
      }

      // prepare spots (x as day index 0..29)
      final List<FlSpot> revSpots = [];
      final List<FlSpot> expSpots = [];
      final List<String> labels = [];

      int idx = 0;
      for (int i = 0; i < 30; i++) {
        final day = start.add(Duration(days: i));
        final key = DateFormat('yyyy-MM-dd').format(day);
        final rev = (revenueByDay[key] ?? 0) as num;
        final exp = (expenseByDay[key] ?? 0) as num;
        revSpots.add(FlSpot(idx.toDouble(), rev.toDouble()));
        expSpots.add(FlSpot(idx.toDouble(), exp.toDouble()));
        // label only few to avoid crowding
        labels.add(DateFormat('MM/dd').format(day));
        idx++;
      }

      if (!mounted) return;
      setState(() {
        revenueSpots = revSpots;
        expenseSpots = expSpots;
        chartLabels = labels;
      });
    } catch (e) {
      // ignore or log
      // print('chart preparation error: $e');
    }
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
                      value:
                          "Rp ${formatter.format(num.tryParse(financeData?['profit']?.toString() ?? '0') ?? 0)}",
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
                    SizedBox(
                      height: 140, // tune as needed
                      child: revenueSpots.isEmpty && expenseSpots.isEmpty
                          ? Center(child: Text('No chart data'))
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 4,
                              ),
                              child: LineChart(
                                LineChartData(
                                  minX: 0,
                                  maxX: (chartLabels.length - 1)
                                      .toDouble()
                                      .clamp(0, double.infinity),
                                  minY: 0,
                                  maxY: _calcMaxY(revenueSpots, expenseSpots),
                                  gridData: FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                  lineTouchData: LineTouchData(enabled: true),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: _calcNiceInterval(),
                                        reservedSize: 48,
                                        getTitlesWidget:
                                            (double value, TitleMeta meta) {
                                              // meta.axisSide tersedia di TitleMeta
                                              final txt = NumberFormat.compact(
                                                locale: 'en_US',
                                              ).format(value);
                                              return SideTitleWidget(
                                                axisSide: meta.axisSide,
                                                space: 6,
                                                child: Text(
                                                  txt,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 28,
                                        interval: (chartLabels.length <= 1)
                                            ? 1
                                            : (chartLabels.length / 5)
                                                  .floorToDouble()
                                                  .clamp(
                                                    1,
                                                    chartLabels.length
                                                        .toDouble(),
                                                  ),
                                        getTitlesWidget:
                                            (double value, TitleMeta meta) {
                                              final xi = value.round();
                                              if (xi < 0 ||
                                                  xi >= chartLabels.length)
                                                return const SizedBox.shrink();
                                              final label = chartLabels[xi];
                                              return SideTitleWidget(
                                                axisSide: meta.axisSide,
                                                child: Text(
                                                  label,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: revenueSpots,
                                      isCurved: true,
                                      barWidth: 2,
                                      dotData: FlDotData(show: false),
                                      color: const Color(0xff8B5CF6),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: const Color(0x408B5CF6),
                                      ),
                                    ),
                                    LineChartBarData(
                                      spots: expenseSpots,
                                      isCurved: true,
                                      barWidth: 2,
                                      dotData: FlDotData(show: false),
                                      color: const Color(0xff06B6D4),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: const Color(0x4006B6D4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              h(32),
              Row(
                spacing: 16,
                children: [
                  Expanded(child: CategoryPieChart()),
                  Expanded(child: LowStockCard()),
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
                              snapshot.data as List<TransactionFirebaseModel>;
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
                                  subtitle:
                                      (transaction.itemName != null &&
                                          transaction.itemName!.isNotEmpty)
                                      ? transaction.itemName!
                                      : 'Unknown item',
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

  double _calcMaxY(List<FlSpot> a, List<FlSpot> b) {
    double maxVal = 0;
    for (final s in a) if (s.y > maxVal) maxVal = s.y;
    for (final s in b) if (s.y > maxVal) maxVal = s.y;
    // add a headroom
    if (maxVal <= 0) return 10;
    return (maxVal * 1.25).ceilToDouble();
  }

  double _calcNiceInterval() {
    // crude interval pick for left axis labels
    final maxY = _calcMaxY(revenueSpots, expenseSpots);
    final nice = (maxY / 3).ceilToDouble();
    return nice > 0 ? nice : 1;
  }
}
