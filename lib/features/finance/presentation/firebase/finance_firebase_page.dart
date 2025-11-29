import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invengo/shared/widgets/app_container.dart';
import 'package:invengo/shared/widgets/page_header.dart';
import 'package:invengo/core/constant/spacing_helper.dart';
import 'package:invengo/core/constant/app_color.dart';
import 'package:invengo/core/constant/app_text_style.dart';
import 'package:invengo/core/constant/rupiah_formatting.dart';
import 'package:invengo/core/services/firebase.dart';
import 'package:invengo/data/models/transaction_firebase_model.dart';
import 'dart:math' as math;

@RoutePage()
class FinanceFirebasePage extends StatefulWidget {
  const FinanceFirebasePage({super.key});

  @override
  State<FinanceFirebasePage> createState() => _FinanceFirebasePageState();
}

enum RangeWindow { week, month, year }

class _FinanceFirebasePageState extends State<FinanceFirebasePage>
    with SingleTickerProviderStateMixin {
  RangeWindow selectedRange = RangeWindow.week;
  bool loading = true;

  int revenue = 0;
  int expenses = 0;
  int profit = 0;

  List<String> xLabels = [];
  List<num> incomeSeries = [];
  List<num> expenseSeries = [];

  late Future<List<TransactionFirebaseModel>> recentTransFuture;

  final NumberFormat compact = NumberFormat.compact(locale: 'en_US');

  @override
  void initState() {
    super.initState();
    recentTransFuture = FirebaseService.getAllTransaction();
    _reloadAll();
  }

  Future<void> _reloadAll() async {
    setState(() => loading = true);
    try {
      final totals = await FirebaseService.getTotalTransaction();
      revenue = (totals['revenue'] ?? 0) is num
          ? (totals['revenue'] as num).toInt()
          : int.tryParse(totals['revenue']?.toString() ?? '0') ?? 0;
      expenses = (totals['expenses'] ?? 0) is num
          ? (totals['expenses'] as num).toInt()
          : int.tryParse(totals['expenses']?.toString() ?? '0') ?? 0;
      profit = (totals['profit'] ?? 0) is num
          ? (totals['profit'] as num).toInt()
          : int.tryParse(totals['profit']?.toString() ?? '0') ?? 0;

      await _aggregateForRange(selectedRange);
    } catch (e) {
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _aggregateForRange(RangeWindow range) async {
    final all = await FirebaseService.getAllTransaction();
    final now = DateTime.now();

    DateTime? _parseAnyDate(String? maybeDate, String? maybeCreatedAt) {
      if (maybeDate != null && maybeDate.isNotEmpty) {
        final d1 = DateTime.tryParse(maybeDate);
        if (d1 != null) return d1;
        try {
          return DateFormat('dd/MM/yyyy').parseStrict(maybeDate);
        } catch (_) {}
        try {
          return DateFormat('yyyy-MM-dd').parseStrict(maybeDate);
        } catch (_) {}
        final millis = int.tryParse(maybeDate);
        if (millis != null) return DateTime.fromMillisecondsSinceEpoch(millis);
      }
      if (maybeCreatedAt != null && maybeCreatedAt.isNotEmpty) {
        final d2 = DateTime.tryParse(maybeCreatedAt);
        if (d2 != null) return d2;
        final millis2 = int.tryParse(maybeCreatedAt);
        if (millis2 != null)
          return DateTime.fromMillisecondsSinceEpoch(millis2);
      }
      return null;
    }

    num _safeNum(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v;
      if (v is String) {
        final cleaned = v.replaceAll(RegExp(r'[^\d\-,.]'), '');
        if (cleaned.isEmpty) return 0;
        final noSep = cleaned.replaceAll(RegExp(r'[.,]'), '');
        final asInt = int.tryParse(noSep);
        if (asInt != null) return asInt;
        final norm = cleaned.replaceAll(',', '.');
        final asDouble = double.tryParse(norm);
        if (asDouble != null) return asDouble;
      }
      return 0;
    }

    if (range == RangeWindow.week) {
      final start = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 6));
      final Map<String, num> rev = {};
      final Map<String, num> exp = {};
      final List<String> labels = [];
      final dateKeyFmt = DateFormat('yyyy-MM-dd');
      final labelFmt = DateFormat('dd/MM');

      for (int i = 0; i < 7; i++) {
        final d = start.add(Duration(days: i));
        final key = dateKeyFmt.format(d);
        rev[key] = 0;
        exp[key] = 0;
        labels.add(labelFmt.format(d));
      }

      for (final t in all) {
        final dt = _parseAnyDate(t.date, t.createdAt);
        if (dt == null) continue;
        final local = DateTime(dt.year, dt.month, dt.day);
        if (local.isBefore(start) ||
            local.isAfter(DateTime(now.year, now.month, now.day)))
          continue;
        final key = dateKeyFmt.format(local);
        if (!rev.containsKey(key)) continue;
        final totalVal = _safeNum(t.total);
        if (t.transactionType == 1) {
          rev[key] = rev[key]! + totalVal;
        } else {
          exp[key] = exp[key]! + totalVal;
        }
      }

      if (mounted) {
        setState(() {
          xLabels = labels;
          incomeSeries = rev.values.toList();
          expenseSeries = exp.values.toList();
        });
      }
    } else if (range == RangeWindow.month) {
      final start = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 29));
      final int buckets = 5;
      final bucketSize = 30 / buckets;
      final List<num> revB = List.filled(buckets, 0);
      final List<num> expB = List.filled(buckets, 0);
      final labels = List.generate(buckets, (i) {
        final bucketStart = start.add(Duration(days: (i * bucketSize).floor()));
        final bucketEnd = start.add(
          Duration(days: (((i + 1) * bucketSize).floor() - 1)),
        );
        return '${DateFormat('dd/MM').format(bucketStart)}';
      });

      for (final t in all) {
        final dt = _parseAnyDate(t.date, t.createdAt);
        if (dt == null) continue;
        if (dt.isBefore(start) || dt.isAfter(now)) continue;
        final daysFromStart = dt.difference(start).inDays;
        final idx = (daysFromStart / bucketSize).floor().clamp(0, buckets - 1);
        final totalVal = _safeNum(t.total);
        if (t.transactionType == 1) {
          revB[idx] = revB[idx] + totalVal;
        } else {
          expB[idx] = expB[idx] + totalVal;
        }
      }

      if (mounted) {
        setState(() {
          xLabels = labels;
          incomeSeries = revB;
          expenseSeries = expB;
        });
      }
    } else {
      final months = List.generate(12, (i) {
        final m = DateTime(now.year, now.month - 11 + i, 1);
        return m;
      });
      final revM = List<num>.filled(12, 0);
      final expM = List<num>.filled(12, 0);
      final labels = months
          .map((m) => DateFormat('MM/yyyy').format(m))
          .toList();

      for (final t in all) {
        final dt = _parseAnyDate(t.date, t.createdAt);
        if (dt == null) continue;
        final idx = months.indexWhere(
          (m) => m.year == dt.year && m.month == dt.month,
        );
        if (idx == -1) continue;
        final totalVal = _safeNum(t.total);
        if (t.transactionType == 1) {
          revM[idx] = revM[idx] + totalVal;
        } else {
          expM[idx] = expM[idx] + totalVal;
        }
      }

      if (mounted) {
        setState(() {
          xLabels = labels;
          incomeSeries = revM;
          expenseSeries = expM;
        });
      }
    }
  }

  String _formatTransactionDate(TransactionFirebaseModel it) {
    DateTime? dt;
    if (it.date != null && (it.date as String).isNotEmpty) {
      dt =
          DateTime.tryParse(it.date!) ??
          (DateFormat('dd/MM/yyyy').parseLoose(it.date!, true) as DateTime?);
    }
    if (dt == null && it.createdAt != null && it.createdAt!.isNotEmpty) {
      dt = DateTime.tryParse(it.createdAt!);
    }
    if (dt == null) return '';
    final base = DateFormat('dd/MM/yyyy').format(dt);
    if (dt.hour != 0 || dt.minute != 0) {
      final time = DateFormat('HH:mm').format(dt);
      return '$base $time';
    }
    return base;
  }

  Widget _rangeButton(String text, RangeWindow r) {
    final active = selectedRange == r;
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          if (selectedRange == r) return;
          setState(() {
            selectedRange = r;
            loading = true;
          });
          await _aggregateForRange(r);
          if (mounted) setState(() => loading = false);
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: active ? null : Theme.of(context).colorScheme.surface,
            gradient: active
                ? LinearGradient(colors: AppColor.primaryGradient)
                : null,
            borderRadius: BorderRadius.circular(12),
            border: active
                ? null
                : Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: active
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28),
          child: Column(
            children: [
              PageHeader(
                title: "Finance",
                subtitle: "Track your revenue & expenses",
              ),
              h(20),
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

                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  h(4),
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
              h(20),
              Row(
                children: [
                  _rangeButton("Week", RangeWindow.week),
                  w(8),
                  _rangeButton("Month", RangeWindow.month),
                  w(8),
                  _rangeButton("Year", RangeWindow.year),
                ],
              ),
              h(20),
              AppContainer(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Revenue vs Expenses",
                            style: AppTextStyle.sectionTitle(context),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Flexible(
                          flex: 0,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              spacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runSpacing: 4,
                              children: [
                                _legendDot(Colors.deepPurple, "Income"),
                                _legendDot(Colors.pink, "Expense"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    h(12),
                    SizedBox(
                      height: 180,
                      child: loading
                          ? Center(child: CircularProgressIndicator())
                          : SimpleBarChart(
                              xLabels: xLabels,
                              income: incomeSeries,
                              expense: expenseSeries,
                            ),
                    ),
                    h(16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Weekly Trend",
                        style: AppTextStyle.sectionTitle(context),
                      ),
                    ),
                    h(12),
                    SizedBox(
                      height: 120,
                      child: loading
                          ? Center(child: CircularProgressIndicator())
                          : SimpleLineChart(points: incomeSeries),
                    ),
                  ],
                ),
              ),
              h(20),
              SizedBox(
                height: screenH * 0.6,
                child: FutureBuilder<List<TransactionFirebaseModel>>(
                  future: recentTransFuture,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    if (!snap.hasData || snap.data!.isEmpty)
                      return Center(child: Text("No recent transactions"));
                    final list = snap.data!;
                    return ListView.separated(
                      itemCount: list.length > 8 ? 8 : list.length,
                      separatorBuilder: (_, __) => h(8),
                      itemBuilder: (context, i) {
                        final it = list[i];
                        final name = it.itemName ?? 'Unknown item';
                        final date = _formatTransactionDate(it);
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Color(0xffccf4dc),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                it.transactionType == 0
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: Color(0xff05df72),
                              ),
                            ),
                            title: Text(
                              "$name ${it.transactionType == 0 ? 'Added' : 'Sale'}",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(date),
                            trailing: Text(
                              "${it.transactionType == 0 ? '-' : '+'} Rp ${formatRupiahWithoutSymbol(it.total)}",
                              style: TextStyle(
                                color: Color(0xff05df72),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              h(24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallMetric(String label, int value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.arrow_outward, color: color, size: 16),
              SizedBox(width: 8),
              Text(label),
            ],
          ),
          h(8),
          Text(
            'Rp ${formatRupiahWithoutSymbol(value)}',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color c, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<String> xLabels;
  final List<num> income;
  final List<num> expense;
  const SimpleBarChart({
    Key? key,
    required this.xLabels,
    required this.income,
    required this.expense,
  }) : super(key: key);

  double _maxValue() {
    final all = <num>[]
      ..addAll(income)
      ..addAll(expense);
    if (all.isEmpty) return 1;
    final m = all.reduce((a, b) => a > b ? a : b);
    return (m == 0) ? 1 : m.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final maxVal = _maxValue();
    final count = xLabels.isEmpty ? 0 : xLabels.length;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (count == 0) return Center(child: Text('No data'));
        final barWidth = (constraints.maxWidth / count) * 0.28;
        final availableH = math.max(0.0, constraints.maxHeight - 28);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(count, (i) {
            final inc = (i < income.length) ? income[i].toDouble() : 0.0;
            final exp = (i < expense.length) ? expense[i].toDouble() : 0.0;
            final incRaw = (inc / maxVal) * availableH;
            final expRaw = (exp / maxVal) * availableH;
            final incH = incRaw.clamp(4.0, availableH).toDouble();
            final expH = expRaw.clamp(4.0, availableH).toDouble();
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: barWidth,
                        height: incH,
                        decoration: BoxDecoration(
                          color: Color(0xff8B5CF6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: 6),
                      Container(
                        width: barWidth,
                        height: expH,
                        decoration: BoxDecoration(
                          color: Color(0xffEC4899),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 20,
                    child: Text(
                      xLabels[i],
                      style: TextStyle(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

class SimpleLineChart extends StatelessWidget {
  final List<num> points;
  const SimpleLineChart({Key? key, required this.points}) : super(key: key);

  double _max() {
    if (points.isEmpty) return 1;
    final m = points.reduce((a, b) => a > b ? a : b);
    return (m == 0) ? 1 : m.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final maxV = _max();
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return SizedBox(
          width: width,
          height: height,
          child: CustomPaint(
            painter: _LinePainter(
              points.map((e) => e.toDouble()).toList(),
              maxV,
              Theme.of(context).colorScheme.primary,
            ),
            size: Size(width, height),
          ),
        );
      },
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> points;
  final double maxV;
  final Color color;
  _LinePainter(this.points, this.maxV, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    final paintDot = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    if (points.isEmpty) return;
    final w = size.width;
    final h = size.height;
    final step = w / (points.length - 1 == 0 ? 1 : (points.length - 1));
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = step * i;
      final y = h - (points[i] / maxV) * (h - 8);
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    final fillPaint = Paint()
      ..color = color.withOpacity(0.12)
      ..style = PaintingStyle.fill;
    final area = Path.from(path)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(area, fillPaint);
    canvas.drawPath(path, paintLine);
    for (int i = 0; i < points.length; i++) {
      final x = step * i;
      final y = h - (points[i] / maxV) * (h - 8);
      canvas.drawCircle(Offset(x, y), 3.0, paintDot);
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.maxV != maxV;
}
