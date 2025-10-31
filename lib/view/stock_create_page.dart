import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/components/app_container.dart';
import 'package:invengo/components/auth/label_form_auth.dart';
import 'package:invengo/components/custom_button.dart';
import 'package:invengo/components/custom_input_form.dart';
import 'package:invengo/components/spacing_helper.dart';
import 'package:invengo/constant/app_color.dart';
import 'package:invengo/constant/app_text_style.dart';
import 'package:invengo/database/db_categories_helper.dart';
import 'package:invengo/database/db_helper.dart';
import 'package:invengo/model/category_model.dart';
import 'package:invengo/model/item_model.dart';

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
            Text("Tambah Barang Baru", style: AppTextStyle.h3),
            Text("Isi informasi produk", style: AppTextStyle.cardTitle),
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
                      color: AppColor.primaryTextLightOpacity60,
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
                  InputForm(
                    controller: costPriceC,
                    prefixIcon: Icon(
                      FontAwesomeIcons.dollarSign,
                      size: 16,
                      color: AppColor.primaryTextLightOpacity60,
                    ),
                  ),
                  h(12),
                  LabelAuth(title: "Harga"),
                  h(8),
                  InputForm(
                    controller: sellPriceC,
                    prefixIcon: Icon(
                      FontAwesomeIcons.dollarSign,
                      size: 16,
                      color: AppColor.primaryTextLightOpacity60,
                    ),
                  ),
                  h(12),
                  LabelAuth(title: "Stok"),
                  h(8),
                  InputForm(controller: stockC),
                  h(24),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.fromBorderSide(
                                BorderSide(color: AppColor.borderLight),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("Batal", style: AppTextStyle.p),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              final ItemModel data = ItemModel(
                                id: widget.isUpdate ? widget.item!.id : null,
                                categoryId: selectedCategoryId!,
                                name: nameC.text,
                                costPrice: int.parse(costPriceC.text),
                                sellingPrice: int.parse(sellPriceC.text),
                                stock: int.parse(stockC.text),
                              );
                              if (widget.isUpdate) {
                                // 🔹 UPDATE DATA
                                await DBHelper.updateItems(data);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Data berhasil diperbarui"),
                                  ),
                                );
                              } else {
                                // 🔹 CREATE DATA BARU
                                await DBHelper.createItems(data);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Data berhasil ditambahkan"),
                                  ),
                                );
                              }
                              Navigator.pop(context);
                              // Navigator.pushNamed(context, '/home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Semua field harus diisi"),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                colors: AppColor.primaryGradient,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.floppyDisk,
                                  color: AppColor.surfaceLight,
                                  size: 16,
                                ),
                                w(8),
                                Text("Simpan", style: AppTextStyle.button),
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
          ),
        ),
      ),
    );
  }
}
