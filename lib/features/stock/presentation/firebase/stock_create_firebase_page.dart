import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/data/models/item_firebase_model.dart';
import 'package:invengo/data/models/category_firebase_model.dart';
import 'package:invengo/shared/widgets/app_container.dart';
import 'package:invengo/features/auth/presentation/widgets/label_form_auth.dart';
import 'package:invengo/shared/widgets/button_logo.dart';
import 'package:invengo/shared/widgets/custom_input_form.dart';
import 'package:invengo/shared/widgets/input_form_number.dart';
import 'package:invengo/core/constant/spacing_helper.dart';
import 'package:invengo/core/constant/app_color.dart';
import 'package:invengo/core/constant/app_text_style.dart';
import 'package:invengo/refresh_notifier.dart';
import 'package:invengo/core/services/firebase.dart';

@RoutePage()
class StockCreateFirebasePage extends StatefulWidget {
  const StockCreateFirebasePage({super.key, this.isUpdate = false, this.item});
  final bool isUpdate;
  final ItemFirebaseModel? item;

  @override
  State<StockCreateFirebasePage> createState() =>
      _StockCreateFirebasePageState();
}

class _StockCreateFirebasePageState extends State<StockCreateFirebasePage> {
  late Future<List<CategoryFirebaseModel>> _categoryListFuture;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final TextEditingController nameC = TextEditingController();
  final TextEditingController costPriceC = TextEditingController();
  final TextEditingController sellPriceC = TextEditingController();
  final TextEditingController stockC = TextEditingController();

  String? selectedCategoryUid;

  @override
  void initState() {
    super.initState();
    _loadCategories();

    if (widget.isUpdate && widget.item != null) {
      final it = widget.item!;
      nameC.text = it.name ?? '';
      costPriceC.text = (it.costPrice ?? 0).toString();
      sellPriceC.text = (it.sellingPrice ?? 0).toString();
      stockC.text = (it.stock ?? 0).toString();
      selectedCategoryUid = it.categoryId;
    }
  }

  void _loadCategories() {
    _categoryListFuture = FirebaseService.getAllCategory();
  }

  @override
  void dispose() {
    nameC.dispose();
    costPriceC.dispose();
    sellPriceC.dispose();
    stockC.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field harus diisi"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ),
      );
      return;
    }

    if (selectedCategoryUid == null || selectedCategoryUid!.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih kategori terlebih dahulu"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final parsedCost = int.tryParse(costPriceC.text.replaceAll('.', '')) ?? 0;
      final parsedSell = int.tryParse(sellPriceC.text.replaceAll('.', '')) ?? 0;
      final parsedStock = int.tryParse(stockC.text.replaceAll('.', '')) ?? 0;

      final item = ItemFirebaseModel(
        id: widget.isUpdate ? widget.item?.id : null,
        categoryId: selectedCategoryUid!,
        name: nameC.text.trim(),
        costPrice: parsedCost,
        sellingPrice: parsedSell,
        stock: parsedStock,
      );

      if (widget.isUpdate) {
        await FirebaseService.updateItem(item);
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
        await FirebaseService.createItem(item);
        refreshStockNotifier.value = true;
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data berhasil ditambahkan"),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
          ),
        );
      }

      if (mounted) {
        setState(() => isLoading = false);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan data: $e"),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ),
      );
    }
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: AppContainer(
            width: screenWidth,
            child: Form(
              key: _formKey,
              child: Column(
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
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nama wajib diisi'
                        : null,
                  ),
                  h(12),
                  LabelAuth(title: "Kategori"),
                  h(8),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xfff9fafb),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.fromBorderSide(
                        BorderSide(color: AppColor.borderLight),
                      ),
                    ),
                    child: FutureBuilder<List<CategoryFirebaseModel>>(
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
                          final categories = snapshot.data!;
                          String? selectedCategoryName;
                          if (selectedCategoryUid != null) {
                            final matched = categories.firstWhere(
                              (cat) => cat.uid == selectedCategoryUid,
                              orElse: () =>
                                  CategoryFirebaseModel(uid: '', name: ''),
                            );
                            if ((matched.name ?? '').isNotEmpty) {
                              selectedCategoryName = matched.name;
                            }
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
                            items: categories.map((c) => c.name ?? '').toList(),
                            onChanged: (v) {
                              final selected = categories.firstWhere(
                                (e) => e.name == v,
                              );
                              setState(() {
                                selectedCategoryUid = selected.uid;
                              });
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
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Harga modal wajib diisi';
                      return null;
                    },
                  ),
                  h(12),
                  LabelAuth(title: "Harga"),
                  h(8),
                  InputFormNumber(
                    controller: sellPriceC,
                    hint: "Masukkan harga jual",
                    isPrice: true,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Harga jual wajib diisi';
                      return null;
                    },
                  ),
                  h(12),
                  LabelAuth(title: "Stok"),
                  h(8),
                  InputFormNumber(
                    controller: stockC,
                    hint: "Masukkan jumlah stok",
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Stok wajib diisi';
                      return null;
                    },
                  ),
                  h(24),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            context.router.pop();
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
                          onTap: () async => await _onSave(),
                          isLoading: isLoading,
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
