// file: widgets/category_pie_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:invengo/core/services/firebase.dart';
import 'package:invengo/data/models/category_firebase_model.dart';
import 'package:invengo/data/models/item_firebase_model.dart';

class CategoryPieChart extends StatefulWidget {
  final List<CategoryFirebaseModel>? categories;
  final List<ItemFirebaseModel>? items;
  const CategoryPieChart({Key? key, this.categories, this.items})
    : super(key: key);

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  late Future<void> _loader;
  List<CategoryFirebaseModel> _categories = [];
  List<ItemFirebaseModel> _items = [];
  List<PieChartSectionData> _sections = [];
  List<Map<String, dynamic>> _legend = [];

  @override
  void initState() {
    super.initState();
    _loader = _prepareData();
  }

  Future<void> _prepareData() async {
    final cats = widget.categories ?? await FirebaseService.getAllCategory();
    final its = widget.items ?? await FirebaseService.getAllItems();

    // safety: build counts keyed by a stable key (prefer uid, fallback to name)
    final Map<String, int> counts = {};
    // keep a map from stableKey -> Category object for later use
    final Map<String, CategoryFirebaseModel> keyToCategory = {};

    for (final c in cats) {
      final key = (c.uid?.toString().trim().isNotEmpty == true)
          ? c.uid!
          : ((c.name?.toString().trim().isNotEmpty == true)
                ? c.name!
                : '__unknown_${keyToCategory.length}');
      counts[key] = 0;
      keyToCategory[key] = c;
    }

    // helper to find the category key for an item (try uid first, then name)
    String? findCategoryKeyForItem(ItemFirebaseModel it) {
      final cid = (it.categoryId ?? '').toString();
      if (cid.isEmpty) return null;

      // direct match uid
      final matchByUid = keyToCategory.entries.firstWhere(
        (e) => (e.value.uid != null && e.value.uid == cid),
        orElse: () => MapEntry('', CategoryFirebaseModel(uid: '', name: '')),
      );
      if (matchByUid.key != '') return matchByUid.key;

      // match by name (some DB may store name instead of id)
      final matchByName = keyToCategory.entries.firstWhere(
        (e) => (e.value.name != null && e.value.name == cid),
        orElse: () => MapEntry('', CategoryFirebaseModel(uid: '', name: '')),
      );
      if (matchByName.key != '') return matchByName.key;

      return null;
    }

    // count items per category
    for (final it in its) {
      final key = findCategoryKeyForItem(it);
      if (key != null && counts.containsKey(key)) {
        counts[key] = counts[key]! + 1;
      } else {
        // optional: try fuzzy match by trimming/normalizing
        // ignore items that truly have no matching category
      }
    }

    // Build display list: prefer categories that have >0, otherwise show all
    final filtered = keyToCategory.keys
        .where((k) => (counts[k] ?? 0) > 0)
        .toList();
    final displayKeys = filtered.isNotEmpty
        ? filtered
        : keyToCategory.keys.toList();

    final palette = [
      Color(0xff8B5CF6),
      Color(0xffEC4899),
      Color(0xff06B6D4),
      Color(0xff0EB07B),
      Color(0xffF59E0B),
      Color(0xff60A5FA),
      Color(0xffF97316),
    ];

    final total = counts.values.fold<int>(0, (p, e) => p + e);
    final sections = <PieChartSectionData>[];
    final legend = <Map<String, dynamic>>[];
    int idx = 0;

    for (final key in displayKeys) {
      final c = keyToCategory[key]!;
      final cnt = counts[key] ?? 0;
      final percent = total > 0 ? (cnt / total) * 100 : 0.0;
      final color = palette[idx % palette.length];

      sections.add(
        PieChartSectionData(
          value: cnt.toDouble(),
          color: color,
          radius: 48,
          title: (total > 0 && percent >= 5)
              ? '${percent.toStringAsFixed(0)}%'
              : '',
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

      legend.add({
        'name': c.name ?? (c.uid ?? 'Unknown'),
        'count': cnt,
        'color': color,
        'percent': percent,
      });

      idx++;
    }

    setState(() {
      _categories = cats;
      _items = its;
      _sections = sections;
      _legend = legend;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loader,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: const SizedBox(
              height: 140,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (_sections.isEmpty || _sections.every((s) => s.value == 0)) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                const SizedBox(
                  height: 120,
                  child: Center(child: Text('No category data')),
                ),
              ],
            ),
          );
        }

        final total = _legend.fold<int>(0, (p, e) => p + (e['count'] as int));
        final showCenterLabel = total > 0 && _legend.length == 1;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              // --- PIE CHART ---
              Center(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sections: _sections,
                          sectionsSpace: 6,
                          startDegreeOffset: -90,
                        ),
                      ),

                      // if (showCenterLabel)
                      //   Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Text(
                      //         '${_legend.first['percent'].toStringAsFixed(0)}%',
                      //         style: const TextStyle(
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       const SizedBox(height: 4),
                      //       Text(
                      //         _legend.first['name'] as String,
                      //         style: const TextStyle(fontSize: 12),
                      //       ),
                      //     ],
                      //   ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- LEGEND DI BAWAH ---
              Column(
                children: _legend.map((l) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: l['color'] as Color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l['name'] as String,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text('${(l['percent'] as double).toStringAsFixed(0)}%'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
