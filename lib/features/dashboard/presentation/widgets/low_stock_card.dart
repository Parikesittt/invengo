import 'package:flutter/material.dart';
import 'package:invengo/core/services/firebase.dart';
import 'package:invengo/data/models/item_firebase_model.dart';

class LowStockCard extends StatefulWidget {
  final List<ItemFirebaseModel>? items;
  final int lowThreshold;
  final int maxDisplay;
  const LowStockCard({
    Key? key,
    this.items,
    this.lowThreshold = 5,
    this.maxDisplay = 5,
  }) : super(key: key);

  @override
  State<LowStockCard> createState() => _LowStockCardState();
}

class _LowStockCardState extends State<LowStockCard> {
  late Future<void> _loader;
  List<ItemFirebaseModel> _lowItems = [];

  @override
  void initState() {
    super.initState();
    _loader = _loadLowItems();
  }

  Future<void> _loadLowItems() async {
    final items = widget.items ?? await FirebaseService.getAllItems();
    final low = items
        .where((it) => it.stock > 0 && it.stock < widget.lowThreshold)
        .toList();
    low.sort((a, b) => (a.stock.compareTo(b.stock)));
    setState(() {
      _lowItems = low.take(widget.maxDisplay).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loader,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xfffff6e5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xfffff6e5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Low Stock',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 12),
              if (_lowItems.isEmpty)
                Text(
                  'No low stock items',
                  style: TextStyle(color: Colors.black54),
                )
              else
                Column(
                  children: _lowItems.map((it) {
                    final stock = it.stock;
                    final max = (it.stock) + 20;
                    final ratio = max > 0 ? (stock / max).clamp(0.0, 1.0) : 0.0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  it.name,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '$stock/$max',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              minHeight: 6,
                              value: ratio,
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ratio < 0.3
                                    ? Colors.red
                                    : (ratio < 0.6
                                          ? Colors.orange
                                          : Colors.green),
                              ),
                            ),
                          ),
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
