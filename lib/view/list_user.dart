import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/shared/widgets/custom_input_form.dart';
import 'package:invengo/core/services/db_helper.dart';
import 'package:invengo/data/models/category_model.dart';

@RoutePage()
class ListCategoryPage extends StatefulWidget {
  const ListCategoryPage({super.key});

  @override
  State<ListCategoryPage> createState() => _ListCategoryPageState();
}

class _ListCategoryPageState extends State<ListCategoryPage> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneNumC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  getData() {
    DBHelper.getAllCategory();
    setState(() {});
  }

  Future<void> _onEdit(CategoryModel category) async {
    final editNameC = TextEditingController(text: category.name);
    final res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [InputForm(hint: "Name", controller: editNameC)],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );

    if (res == true) {
      final updatedData = CategoryModel(id: category.id, name: editNameC.text);
      DBHelper.updateCategory(updatedData);
      getData();
    }
  }

  Future<void> _onDelete(CategoryModel category) async {
    final res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit data"),
          content: Text(
            "Yakin ingin menghapus category dengan nama ${category.name}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Tidak"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Ya"),
            ),
          ],
        );
      },
    );

    if (res == true) {
      DBHelper.deleteUser(category.id!);
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("List data user:"),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: DBHelper.getAllCategory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData ||
                    (snapshot.data as List).isEmpty) {
                  return const Center(child: Text("Tidak ada data"));
                } else {
                  final data = snapshot.data as List<CategoryModel>;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final items = data[index];
                      return ListTile(
                        title: Text(items.name!),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _onEdit(items);
                              },
                              icon: Icon(FontAwesomeIcons.penToSquare),
                            ),
                            IconButton(
                              onPressed: () {
                                _onDelete(items);
                              },
                              icon: Icon(FontAwesomeIcons.trashCan),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
