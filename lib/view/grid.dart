// import 'package:belajar_ppkd/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:invengo/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class TugasGridWidget extends StatelessWidget {
  const TugasGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List listColor = [
      Color(0xff3B82F6),
      Color(0xffF97316),
      Color(0xffFB923C),
      Color(0xffFACC15),
      Color(0xffDC2626),
      Color(0xff111827),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulir"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toogleTheme();
            },
            icon: Icon(Icons.lightbulb),
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 10),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Nama"),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukan nama',
                    hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Email"),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'test@mail.com',
                    hintStyle: TextStyle(color: Color(0xff6B7280)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Text("No. HP"),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '6288888888',
                    hintStyle: TextStyle(color: Color(0xff6B7280)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Deskripsi"),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ini deskripsi',
                    hintStyle: TextStyle(color: Color(0xff6B7280)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(),
                child: Text(
                  'Gallery',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 6,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: listColor[index],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Text(
                          "Container ${index + 1}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
