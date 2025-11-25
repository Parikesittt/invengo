import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invengo/shared/widgets/app_container.dart';
import 'package:invengo/features/auth/presentation/widgets/label_form_auth.dart';
import 'package:invengo/shared/widgets/button_logo.dart';
import 'package:invengo/shared/widgets/custom_input_form.dart';
import 'package:invengo/core/constant/spacing_helper.dart';
import 'package:invengo/core/constant/app_color.dart';
import 'package:invengo/core/constant/app_text_style.dart';
import 'package:invengo/core/services/db_helper.dart';
import 'package:invengo/data/models/user_model.dart';
import 'package:invengo/core/services/preference_handler.dart';

@RoutePage()
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  @override
  void initState() {
    super.initState();
    PreferenceHandler.getUsername().then((value) {
      setState(() {
        username = value ?? 'Guest';
      });
    });
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = await PreferenceHandler.getUserId();
    if (userId != null) {
      final user = await DBHelper.getUserById(userId);
      if (user != null) {
        setState(() {
          username = user.username;
          usernameC.text = user.username;
          nameC.text = user.name;
          emailC.text = user.email;
          phoneC.text = user.phoneNumber;
          passwordC.text = user.password;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Edit Profile", style: AppTextStyle.h2(context)),
            Text(
              "Update your personal information",
              style: AppTextStyle.label(context),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              AppContainer(
                child: Column(
                  children: [
                    InkWell(
                      child: Stack(
                        alignment: AlignmentGeometry.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xfff3e8fa),
                            radius: 48,
                            child: Text(
                              (username ?? 'Guest')[0].toUpperCase(),
                              style: AppTextStyle.h3(context),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: AppColor.primaryGradient,
                              ),
                            ),
                            child: Icon(
                              FontAwesomeIcons.camera,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    h(16),
                    Text(
                      "Klik icon kamera untuk mengubah avatar",
                      style: AppTextStyle.cardTitle(context),
                    ),
                  ],
                ),
              ),
              h(16),
              AppContainer(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Informasi Pribadi",
                        style: AppTextStyle.sectionTitle(context),
                      ),
                      h(28),
                      LabelAuth(title: "Nama Lengkap *"),
                      h(8),
                      InputForm(controller: nameC),
                      h(12),
                      LabelAuth(title: "Username *"),
                      h(8),
                      InputForm(controller: usernameC),
                      h(12),
                      LabelAuth(title: "Email *"),
                      h(8),
                      InputForm(controller: emailC),
                      h(12),
                      LabelAuth(title: "Nomor Telepon *"),
                      h(8),
                      InputForm(controller: phoneC),
                      h(12),
                      LabelAuth(title: "Password *"),
                      h(8),
                      InputForm(controller: passwordC, isPassword: true),
                    ],
                  ),
                ),
              ),
              h(16),
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
                          child: Text("Batal", style: AppTextStyle.p(context)),
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
                      iconColor: Colors.white,
                      iconSize: 16,
                      textButton: "Simpan",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          final userId = await PreferenceHandler.getUserId();
                          if (userId == null) return;

                          final UserModel data = UserModel(
                            id: userId,
                            username: usernameC.text,
                            name: nameC.text,
                            email: emailC.text,
                            phoneNumber: phoneC.text,
                            password: passwordC.text,
                          );
                          await DBHelper.updateUser(data);

                          Fluttertoast.showToast(
                            msg: "Data berhasil diperbarui",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            textColor: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 12.0,
                          );

                          context.router.pop();
                          // Navigator.pop(context);
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
    );
  }
}
