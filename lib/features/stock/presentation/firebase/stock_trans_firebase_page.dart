import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:invengo/shared/widgets/app_container.dart';
import 'package:invengo/shared/widgets/custom_button.dart';
import 'package:invengo/shared/widgets/date_picker.dart';
import 'package:invengo/shared/widgets/input_form_number.dart';
import 'package:invengo/core/constant/spacing_helper.dart';
import 'package:invengo/features/stock/presentation/widgets/stock_button.dart';
import 'package:invengo/core/constant/app_text_style.dart';
import 'package:invengo/refresh_notifier.dart';

// Firebase service & models
import 'package:invengo/core/services/firebase.dart';
import 'package:invengo/data/models/item_firebase_model.dart';
import 'package:invengo/data/models/transaction_firebase_model.dart';

@RoutePage()
class StockTransFirebasePage extends StatefulWidget {
  const StockTransFirebasePage({super.key});

  @override
  State<StockTransFirebasePage> createState() => _StockTransFirebasePageState();
}

class _StockTransFirebasePageState extends State<StockTransFirebasePage> {
  final NumberFormat formatter = NumberFormat("#,###", "id_ID");
  final _formKey = GlobalKey<FormState>();

  List<ItemFirebaseModel> _stockList = [];
  bool isAdd = true;
  ItemFirebaseModel? selectedItems;

  final TextEditingController totalC = TextEditingController();
  final TextEditingController priceC = TextEditingController();
  final TextEditingController dateC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
    dateC.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> _loadItems() async {
    try {
      final items = await FirebaseService.getAllItems();
      if (!mounted) return;
      setState(() => _stockList = items);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil daftar barang: $e')),
      );
    }
  }

  @override
  void dispose() {
    totalC.dispose();
    priceC.dispose();
    dateC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Semua field harus diisi')));
    return;
  }

  if (selectedItems == null) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Pilih barang terlebih dahulu')));
    return;
  }

  final qty = int.tryParse(totalC.text.replaceAll('.', '')) ?? 0;
  if (qty <= 0) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Jumlah harus lebih dari 0')));
    return;
  }

  // ambil stock terbaru (coba dari server untuk mengurangi kemungkinan stale data)
  int currentStock;
  try {
    final fresh = await FirebaseService.getItemById(selectedItems!.id!);
    if (fresh != null && fresh.stock != null) {
      currentStock = fresh.stock!;
    } else {
      currentStock = selectedItems!.stock ?? 0;
    }
  } catch (_) {
    // fallback aman
    currentStock = selectedItems!.stock ?? 0;
  }

  // hitung newStock secara lokal (selalu int, tidak null)
  final int newStock = isAdd ? (currentStock + qty) : (currentStock - qty);

  final parsedPrice = int.tryParse(priceC.text.replaceAll('.', ''));
  final unitPriceFallback =
      isAdd ? (selectedItems!.costPrice ?? 0) : (selectedItems!.sellingPrice ?? 0);
  final usedUnitPrice = parsedPrice ?? unitPriceFallback;
  final total = usedUnitPrice * qty;

  try {
    final trans = TransactionFirebaseModel(
      id: null,
      itemId: selectedItems!.id!,
      transactionType: isAdd ? 0 : 1,
      total: total,
      quantity: qty,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    // buat transaction (this updates stock atomically inside the service)
    await FirebaseService.createTransaction(trans);

    // jika user masukkan harga baru -> update hanya field harga
    if (parsedPrice != null) {
      final fields = <String, dynamic>{};
      if (isAdd) {
        fields['cost_price'] = parsedPrice;
      } else {
        fields['selling_price'] = parsedPrice;
      }
      await FirebaseService.updateItemFields(selectedItems!.id!, fields);
    }

    // pastikan dokumen item tidak menyimpan stock null: tulis newStock (int)
    // ini menulis stock yang kita hitung; createTransaction sudah update stock atomically,
    // tapi menulis ulang dengan newStock memberikan jaminan doc tidak berisi null.
    await FirebaseService.updateItemFields(selectedItems!.id!, {'stock': newStock});

    // refresh local item model dari server supaya UI akurat
    final refreshed = await FirebaseService.getItemById(selectedItems!.id!);
    if (refreshed != null) selectedItems = refreshed;

    refreshStockNotifier.value = true;
    if (!mounted) return;
    Navigator.of(context).pop();
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Gagal menyimpan transaksi: $e')));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Transaksi Stok", style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18)),
            Text("Catat barang masuk atau keluar", style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AppContainer(
                withBorder: true,
                height: 214,
                padding: const EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tipe Transaksi", style: AppTextStyle.sectionTitle(context)),
                    h(24),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: StockButton(
                            onTap: () {
                              if (!isAdd) {
                                setState(() {
                                  isAdd = true;
                                  if (selectedItems != null) {
                                    priceC.text = formatter.format(selectedItems!.costPrice ?? 0);
                                  }
                                });
                              }
                            },
                            isEnable: isAdd,
                            icon: FontAwesomeIcons.plus,
                            title: "Barang Masuk",
                            subtitle: "Tambah stok",
                          ),
                        ),
                        Expanded(
                          child: StockButton(
                            onTap: () {
                              if (isAdd) {
                                setState(() {
                                  isAdd = false;
                                  if (selectedItems != null) {
                                    priceC.text = formatter.format(selectedItems!.sellingPrice ?? 0);
                                  }
                                });
                              }
                            },
                            isEnable: !isAdd,
                            icon: FontAwesomeIcons.minus,
                            title: "Barang Keluar",
                            subtitle: "Kurangi stok",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              h(18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.fromBorderSide(BorderSide(color: Theme.of(context).colorScheme.outline)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pilih Barang", style: AppTextStyle.sectionSubtitle(context)),
                      h(8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xfff9fafb),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.fromBorderSide(BorderSide(color: Theme.of(context).colorScheme.outline)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownSearch<ItemFirebaseModel>(
                            items: _stockList,
                            filterFn: (item, filter) {
                              return item.name?.toLowerCase().contains(filter.toLowerCase()) ?? false;
                            },
                            itemAsString: (ItemFirebaseModel? m) => m?.name ?? '',
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Pilih barang ...',
                              ),
                            ),
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  hintText: 'Cari barang...',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                ),
                              ),
                              itemBuilder: (context, item, isSelected) {
                                return ListTile(
                                  title: Text(item.name ?? ''),
                                  subtitle: item.categoryName != null ? Text(item.categoryName!) : null,
                                  trailing: Text(
                                    (item.sellingPrice != null) ? 'Rp ${formatter.format(item.sellingPrice)}' : '',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                            ),
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() {
                                selectedItems = v;
                                final price = isAdd ? (v.costPrice ?? 0) : (v.sellingPrice ?? 0);
                                priceC.text = formatter.format(price);
                              });
                            },
                          ),
                        ),
                      ),
                      h(16),
                      Text("Jumlah", style: AppTextStyle.sectionSubtitle(context)),
                      h(8),
                      InputFormNumber(hint: "Masukkan jumlah", controller: totalC),
                      h(16),
                      Text("Harga", style: AppTextStyle.sectionSubtitle(context)),
                      h(8),
                      InputFormNumber(hint: "(Opsional jika harga berubah)", controller: priceC, isPrice: true),
                      h(16),
                      Text("Tanggal", style: AppTextStyle.sectionSubtitle(context)),
                      h(8),
                      DatePickerFormField(controller: dateC),
                      h(16),
                      Button(
                        buttonText: isAdd ? "Tambah Stok" : "Kurangi Stok",
                        height: 48,
                        width: double.infinity,
                        click: () async => await _submit(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
