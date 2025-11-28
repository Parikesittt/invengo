import 'package:auto_route/annotations.dart';
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
    // load quick preference username (fast)
    final prefName = await PreferenceHandler.getUsername();
    if (!mounted) return;
    setState(() {
      username = prefName ?? 'Guest';
    });

    // try load from firebase if user is signed in
    final uid = FirebaseAuth.instance.currentUser?.uid;
    _uid = uid;
    if (uid != null) {
      final user = await FirebaseService.getUserById(uid);
      if (!mounted) return;
      if (user != null) {
        username = user.username ?? username;
        usernameC.text = user.username ?? '';
        emailC.text = user.email ?? '';
        phoneC.text = user.phoneNumber ?? '';
        // don't prefill password (not stored here)
        setState(() {});
      }
    } else {
      // fallback to preferences only
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

    // require signed in user to update Firebase profile
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
        email: emailC.text.trim(),
        phoneNumber: phoneC.text.trim(),
        // do not store password here; handle auth password separately if needed
        updatedAt: DateTime.now().toIso8601String(),
      );

      await FirebaseService.updateUser(updated);

      // update local preference username so other screens read updated name
      // await PreferenceHandler.setUsername(usernameC.text.trim());

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
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // TODO: implement avatar change
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xfff3e8fa),
                            radius: 48,
                            child: Text(
                              (username ?? 'G')[0].toUpperCase(),
                              style: AppTextStyle.h3(context),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: AppColor.primaryGradient,
                              ),
                            ),
                            child: const Icon(
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
