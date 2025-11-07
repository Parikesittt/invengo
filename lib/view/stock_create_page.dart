import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/components/app_container.dart';
import 'package:invengo/components/auth/label_form_auth.dart';
import 'package:invengo/components/button_logo.dart';
import 'package:invengo/components/custom_input_form.dart';
import 'package:invengo/components/input_form_number.dart';
import 'package:invengo/components/spacing_helper.dart';
import 'package:invengo/constant/app_color.dart';
import 'package:invengo/constant/app_text_style.dart';
import 'package:invengo/database/db_helper.dart';
import 'package:invengo/model/category_model.dart';
import 'package:invengo/model/item_model.dart';
import 'package:invengo/refresh_notifier.dart';

@RoutePage()
class StockCreatePage extends StatefulWidget {
  const StockCreatePage({super.key, this.isUpdate = false, this.item});
  final bool isUpdate;
  final ItemModel? item;

  @override
  State<StockCreatePage> createState() => _StockCreatePageState();
}

class _StockCreatePageState extends State<StockCreatePage> {
  late Future<List<CategoryModel>> _categoryListFuture;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController costPriceC = TextEditingController();
  final TextEditingController sellPriceC = TextEditingController();
  final TextEditingController stockC = TextEditingController();
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    getCategory();
    if (widget.isUpdate && widget.item != null) {
      nameC.text = widget.item!.name;
      costPriceC.text = widget.item!.costPrice.toString();
      sellPriceC.text = widget.item!.sellingPrice.toString();
      stockC.text = widget.item!.stock.toString();
      selectedCategoryId = widget.item!.categoryId;
    }
  }

  getCategory() {
    _categoryListFuture = DBHelper.getAllCategory();
    setState(() {});
  }

  getData() {}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isUpdate ? "Edit Barang" : "Tambah Barang Baru",
              style: AppTextStyle.h2(context),
            ),
            Text(
              "Isi informasi produk",
              style: AppTextStyle.cardTitle(context),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: AppContainer(
            width: screenWidth,
            child: Form(
              key: _formKey,
              child: Column(
                // spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelAuth(title: "Nama Barang"),
                  h(8),
                  InputForm(
                    controller: nameC,
                    prefixIcon: Icon(
                      FontAwesomeIcons.boxOpen,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  h(12),
                  LabelAuth(title: "Kategori"),
                  h(8),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xfff9fafb),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.fromBorderSide(
                        BorderSide(color: AppColor.borderLight),
                      ),
                    ),
                    child: FutureBuilder(
                      future: _categoryListFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No category found.'),
                          );
                        } else {
                          // Data has been successfully loaded
                          List<CategoryModel> categories = snapshot.data!;
                          String? selectedCategoryName;
                          if (selectedCategoryId != null) {
                            final matched = categories.firstWhere(
                              (cat) => cat.id == selectedCategoryId,
                              orElse: () => CategoryModel(id: 0, name: ''),
                            );
                            selectedCategoryName = matched.name.isNotEmpty
                                ? matched.name
                                : null;
                          }
                          return DropdownFlutter(
                            decoration: CustomDropdownDecoration(
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
                            initialItem: selectedCategoryName,
                            items: categories
                                .map((item) => item.name.toString())
                                .toList(),
                            onChanged: (v) {
                              final selectedItem = categories.firstWhere(
                                (e) => e.name == v,
                              );
                              setState(() {
                                selectedCategoryId = selectedItem.id;
                              });
                              print('ID terpilih: ${selectedItem.id}');
                            },
                            hintText: 'Pilih kategori ...',
                          );
                        }
                      },
                    ),
                  ),
                  h(12),
                  LabelAuth(title: "Harga Modal"),
                  h(8),
                  InputFormNumber(
                    controller: costPriceC,
                    hint: "Masukkan harga modal",
                    isPrice: true,
                  ),
                  h(12),
                  LabelAuth(title: "Harga"),
                  h(8),
                  InputFormNumber(
                    controller: sellPriceC,
                    hint: "Masukkan harga jual",
                    isPrice: true,
                  ),
                  h(12),
                  LabelAuth(title: "Stok"),
                  h(8),
                  InputFormNumber(
                    controller: stockC,
                    hint: "Masukkan jumlah stok",
                  ),
                  h(24),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            context.pop();
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.fromBorderSide(
                                BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Batal",
                                style: AppTextStyle.p(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ButtonLogo(
                          gradient: LinearGradient(
                            colors: AppColor.primaryGradient,
                          ),
                          icon: FontAwesomeIcons.floppyDisk,
                          iconColor: AppColor.surfaceLight,
                          iconSize: 16,
                          textButton: "Simpan",
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              final ItemModel data = ItemModel(
                                id: widget.isUpdate ? widget.item!.id : null,
                                categoryId: selectedCategoryId!,
                                name: nameC.text,
                                costPrice: int.parse(
                                  costPriceC.text.replaceAll('.', ''),
                                ),
                                sellingPrice: int.parse(
                                  sellPriceC.text.replaceAll('.', ''),
                                ),
                                stock: int.parse(
                                  stockC.text.replaceAll('.', ''),
                                ),
                              );
                              if (widget.isUpdate) {
                                // 🔹 UPDATE DATA
                                await DBHelper.updateItems(data);
                                refreshStockNotifier.value = true;

                                Fluttertoast.showToast(
                                  msg: "Data berhasil diperbarui",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: AppColor.surfaceLight,
                                  textColor: AppColor.textSecondaryLight,
                                  fontSize: 12.0,
                                );
                              } else {
                                // 🔹 CREATE DATA BARU
                                await DBHelper.createItems(data);
                                refreshStockNotifier.value = true;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Data berhasil ditambahkan"),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                      bottom: 80,
                                      left: 16,
                                      right: 16,
                                    ),
                                  ),
                                );
                              }
                              Navigator.pop(context);
                              // Navigator.pushNamed(context, '/home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Semua field harus diisi"),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(
                                    bottom: 80,
                                    left: 16,
                                    right: 16,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
