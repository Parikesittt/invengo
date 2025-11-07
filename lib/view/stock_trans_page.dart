import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:invengo/components/app_container.dart';
import 'package:invengo/components/custom_button.dart';
import 'package:invengo/components/date_picker.dart';
import 'package:invengo/components/input_form_number.dart';
import 'package:invengo/components/spacing_helper.dart';
import 'package:invengo/components/stock/stock_button.dart';
import 'package:invengo/constant/app_text_style.dart';
import 'package:invengo/database/db_helper.dart';
import 'package:invengo/model/item_model.dart';
import 'package:invengo/model/transaction_model.dart';
import 'package:invengo/refresh_notifier.dart';

@RoutePage()
class StockTransPage extends StatefulWidget {
  const StockTransPage({super.key});

  @override
  State<StockTransPage> createState() => _StockTransPageState();
}

class _StockTransPageState extends State<StockTransPage> {
  // late Future<List<StockDropdownModel>> _stockListFuture;
  final NumberFormat formatter = NumberFormat("#,###", "id_ID");
  final _formKey = GlobalKey<FormState>();
  List<ItemModel> _stockList = [];
  DateTime? selectedDate = DateTime.now();
  String? valueDropdown;
  bool isAdd = true;
  int? selectedItemId;
  ItemModel? selectedItems;
  final TextEditingController totalC = TextEditingController();
  final TextEditingController priceC = TextEditingController();
  final TextEditingController dateC = TextEditingController();

  final List<String> listCategory = [
    'Elektronik',
    'Pakaian',
    'Makanan',
    'Perabotan',
  ];

  @override
  void initState() {
    super.initState();
    getData();
    if (selectedItems != null) {
      final price = isAdd
          ? selectedItems!.sellingPrice
          : selectedItems!.costPrice;

      // Format langsung di sini (biar TextField-nya sudah bertitik)
      final formatted = formatter.format(price);
      priceC.text = formatted;
    }
  }

  Future<void> getData() async {
    final items = await DBHelper.getAllItems();
    setState(() {
      _stockList = items;
      print(_stockList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transaksi Stok",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
              ),
            ),
            Text(
              "Catat barang masuk atau keluar",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
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
                padding: EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tipe Transaksi",
                      style: AppTextStyle.sectionTitle(context),
                    ),
                    h(24),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: StockButton(
                            onTap: () {
                              isAdd = !isAdd;
                              setState(() {});
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
                              isAdd = !isAdd;
                              setState(() {});
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
                padding: EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.fromBorderSide(
                    BorderSide(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pilih Barang",
                        style: AppTextStyle.sectionSubtitle(context),
                      ),
                      h(8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xfff9fafb),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                        child: DropdownFlutter<ItemModel>.search(
                          decoration: CustomDropdownDecoration(
                            searchFieldDecoration: SearchFieldDecoration(
                              fillColor: Theme.of(context).colorScheme.surface,
                            ),
                            closedFillColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            expandedFillColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            listItemStyle: AppTextStyle.p(context),
                            closedBorder: BoxBorder.fromBorderSide(
                              BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            expandedBorder: BoxBorder.fromBorderSide(
                              BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ),
                          items: _stockList,
                          onChanged: (v) {
                            final selectedItem = _stockList.firstWhere(
                              (e) => e.id == v!.id,
                            );
                            setState(() {
                              selectedItems = selectedItem;
                              priceC.text = formatter.format(
                                isAdd
                                    ? selectedItems!.costPrice
                                    : selectedItems!.sellingPrice,
                              );
                            });
                          },
                          hintText: 'Pilih barang ...',
                        ),
                      ),
                      h(16),
                      Text(
                        "Jumlah",
                        style: AppTextStyle.sectionSubtitle(context),
                      ),
                      h(8),
                      InputFormNumber(
                        hint: "Masukkan jumlah",
                        controller: totalC,
                      ),
                      h(16),
                      Text(
                        "Harga",
                        style: AppTextStyle.sectionSubtitle(context),
                      ),
                      h(8),
                      InputFormNumber(
                        hint: "(Opsional jika harga berubah)",
                        controller: priceC,
                        isPrice: true,
                      ),
                      h(16),
                      Text(
                        "Tanggal",
                        style: AppTextStyle.sectionSubtitle(context),
                      ),
                      h(8),
                      DatePickerFormField(controller: dateC),
                      h(16),
                      Button(
                        buttonText: isAdd ? "Tambah Stok" : "Kurangi Stok",
                        height: 48,
                        width: double.infinity,
                        click: () async {
                          if (_formKey.currentState!.validate()) {
                            final TransactionModel data = TransactionModel(
                              itemId: selectedItems!.id!,
                              transactionType: isAdd ? 0 : 1,
                              total: isAdd
                                  ? int.parse(totalC.text) *
                                        selectedItems!.costPrice
                                  : int.parse(totalC.text) *
                                        selectedItems!.sellingPrice,
                              quantity: int.parse(totalC.text),
                            );
                            await DBHelper.createTransaction(
                              data,
                              priceC.text.isNotEmpty
                                  ? int.parse(priceC.text.replaceAll('.', ''))
                                  : selectedItems!.sellingPrice,
                            );
                            refreshStockNotifier.value = true;
                            context.router.pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Semua field harus diisi"),
                              ),
                            );
                          }
                        },
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
