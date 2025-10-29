import 'package:auto_route/annotations.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/components/custom_input_form.dart';

@RoutePage()
class StockTransPage extends StatefulWidget {
  const StockTransPage({super.key});

  @override
  State<StockTransPage> createState() => _StockTransPageState();
}

class _StockTransPageState extends State<StockTransPage> {
  String? valueDropdown;

  final List<String> listCategory = [
    'Elektronik',
    'Pakaian',
    'Makanan',
    'Perabotan',
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
              style: TextStyle(color: Color(0xff101828), fontSize: 18),
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
              Container(
                padding: EdgeInsets.all(17),
                height: 214,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.fromBorderSide(
                    BorderSide(color: Color(0xffe5e7eb)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tipe Transaksi",
                      style: TextStyle(
                        color: Color(0xff101828),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    height(24),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.fromBorderSide(
                                  BorderSide(color: Color(0xff8B5CF6)),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0x108B5CF6),
                                    Color(0x10EC4899),
                                  ],
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),

                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xff8C5CF5),
                                          Color(0xffEB489A),
                                        ],
                                      ),
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.plus,
                                      color: Colors.white,
                                    ),
                                  ),
                                  height(12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Barang Masuk",
                                        style: TextStyle(
                                          color: Color(0xff101828),
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        "Tambah stok",
                                        style: TextStyle(
                                          color: Color(0x80101828),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.fromBorderSide(
                                  BorderSide(color: Color(0xffe5e7eb)),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF3F4F6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.minus,
                                      color: Color(0xff4A5565),
                                    ),
                                  ),
                                  height(12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Barang Keluar",
                                        style: TextStyle(
                                          color: Color(0xff101828),
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        "Kurangi stok",
                                        style: TextStyle(
                                          color: Color(0x80101828),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
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
              height(18),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.fromBorderSide(
                    BorderSide(color: Color(0xffe5e7eb)),
                  ),
                ),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pilih Barang"),
                      height(8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xfff9fafb),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.fromBorderSide(
                            BorderSide(color: Color(0xffe5e7eb)),
                          ),
                        ),
                        // child: DropDownState<String>(dropDown: DropDown<String>(data: <SelectedListItem<String>>[
                        //   SelectedListItem(data: 'Tokyo'),
                        //   SelectedListItem(data: 'London'),
                        //   SelectedListItem(data: 'New York'),
                        // ],
                        // onSelected: (selectedItems){
                        //   List<String> list = [];
                        //   for
                        // }
                        // )),
                        child: DropdownButton(
                          // iconSize: 18,
                          // icon: Icon(FontAwesomeIcons.box),
                          hint: Text("Pilih barang..."),
                          borderRadius: BorderRadius.circular(12),
                          value: valueDropdown,
                          items: listCategory.map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              valueDropdown = value;
                            });
                          },
                        ),
                      ),
                      height(16),
                      Text("Jumlah"),
                      height(8),
                      InputForm(hint: "Masukkan jumlah"),
                      height(16),
                      Text("Harga"),
                      height(8),
                      InputForm(hint: "(Opsional jika harga berubah)"),
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

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);
}
