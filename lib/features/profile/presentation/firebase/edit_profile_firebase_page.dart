import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:invengo/core/services/preference_handler.dart';
import 'package:invengo/core/services/firebase.dart';
import 'package:invengo/data/models/user_firebase_model.dart';

@RoutePage()
class EditProfileFirebasePage extends StatefulWidget {
  const EditProfileFirebasePage({super.key});

  @override
  State<EditProfileFirebasePage> createState() =>
      _EditProfileFirebasePageState();
}

class _EditProfileFirebasePageState extends State<EditProfileFirebasePage> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  bool isLoading = false;
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  String? _uid;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final prefName = await PreferenceHandler.getUsername();
    if (!mounted) return;
    setState(() {
      username = prefName ?? 'Guest';
    });

    final uid = FirebaseAuth.instance.currentUser?.uid;
    _uid = uid;
    if (uid != null) {
      final user = await FirebaseService.getUserById(uid);
      if (!mounted) return;
      if (user != null) {
        username = user.username ?? username;
        usernameC.text = user.username ?? '';
        phoneC.text = user.phoneNumber ?? '';
        setState(() {});
      }
    } else {
      final storedUsername = await PreferenceHandler.getUsername();
      if (!mounted) return;
      usernameC.text = storedUsername ?? '';
      setState(() {});
    }
  }

  @override
  void dispose() {
    usernameC.dispose();
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field harus diisi"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ),
      );
      return;
    }

    final uid = _uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not signed in')));
      return;
    }

    setState(() => isLoading = true);
    try {
      final updated = UserFirebaseModel(
        uid: uid,
        username: usernameC.text.trim(),
        phoneNumber: phoneC.text.trim(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      await FirebaseService.updateUser(updated);

      Fluttertoast.showToast(
        msg: "Data berhasil diperbarui",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.surfaceLight,
        textColor: AppColor.textSecondaryLight,
        fontSize: 12.0,
      );

      if (!mounted) return;
      setState(() => isLoading = false);
      context.router.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui data: $e')));
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
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
                      LabelAuth(title: "Username *"),
                      h(8),
                      InputForm(controller: usernameC),
                      h(12),
                      LabelAuth(title: "Nomor Telepon *"),
                      h(8),
                      InputForm(controller: phoneC),
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
                      onTap: () => context.pop(),
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
                      gradient: const LinearGradient(
                        colors: AppColor.primaryGradient,
                      ),
                      icon: FontAwesomeIcons.floppyDisk,
                      iconColor: Colors.white,
                      iconSize: 16,
                      textButton: "Simpan",
                      onTap: _save,
                      isLoading: isLoading,
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
