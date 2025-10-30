import 'package:auto_route/annotations.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/components/app_container.dart';
import 'package:invengo/components/custom_button.dart';
import 'package:invengo/components/custom_input_form.dart';
import 'package:invengo/components/date_picker.dart';
import 'package:invengo/components/spacing_helper.dart';
import 'package:invengo/components/stock/stock_button.dart';
import 'package:invengo/constant/app_color.dart';
import 'package:invengo/constant/app_text_style.dart';
import 'package:invengo/model/stock_dropdown_model.dart';

@RoutePage()
class StockTransPage extends StatefulWidget {
  const StockTransPage({super.key});

  @override
  State<StockTransPage> createState() => _StockTransPageState();
}

class _StockTransPageState extends State<StockTransPage> {
  DateTime? selectedDate = DateTime.now();
  String? valueDropdown;
  bool isAdd = true;
  final TextEditingController totalC = TextEditingController();
  final TextEditingController priceC = TextEditingController();
  final TextEditingController dateC = TextEditingController();

  final List<String> listCategory = [
    'Elektronik',
    'Pakaian',
    'Makanan',
    'Perabotan',
  ];

  final List<StockDropdownModel> _list = [
    StockDropdownModel('Engineer', Icons.engineering),
    StockDropdownModel('Artist', Icons.palette),
    StockDropdownModel('Manager', Icons.business_center),
    StockDropdownModel('Intern', Icons.school),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transaksi Stok",
              style: TextStyle(color: AppColor.primaryTextLight, fontSize: 18),
            ),
            Text(
              "Catat barang masuk atau keluar",
              style: TextStyle(color: Color(0x60101828), fontSize: 12),
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
                    Text("Tipe Transaksi", style: AppTextStyle.sectionTitle),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.fromBorderSide(
                    BorderSide(color: AppColor.borderLight),
                  ),
                ),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pilih Barang", style: AppTextStyle.sectionSubtitle),
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
                        child: DropdownFlutter<StockDropdownModel>.search(
                          items: _list,
                          onChanged: (v) {},
                          hintText: 'Pilih barang ...',
                        ),
                        // child: DropdownButton(
                        //   // iconSize: 18,
                        //   // icon: Icon(FontAwesomeIcons.box),
                        //   hint: Text("Pilih barang..."),
                        //   borderRadius: BorderRadius.circular(12),
                        //   value: valueDropdown,
                        //   items: listCategory.map((String val) {
                        //     return DropdownMenuItem(
                        //       value: val,
                        //       child: Text(val),
                        //     );
                        //   }).toList(),
                        //   onChanged: (value) {
                        //     setState(() {
                        //       valueDropdown = value;
                        //     });
                        //   },
                        // ),
                      ),
                      h(16),
                      Text("Jumlah", style: AppTextStyle.sectionSubtitle),
                      h(8),
                      InputForm(hint: "Masukkan jumlah"),
                      h(16),
                      Text("Harga", style: AppTextStyle.sectionSubtitle),
                      h(8),
                      InputForm(hint: "(Opsional jika harga berubah)"),
                      h(16),
                      Text("Tanggal", style: AppTextStyle.sectionSubtitle),
                      h(8),
                      DatePickerFormField(controller: dateC),
                      h(16),
                      Button(
                        buttonText: isAdd ? "Tambah Stok" : "Kurangi Stok",
                        height: 48,
                        width: double.infinity,
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
