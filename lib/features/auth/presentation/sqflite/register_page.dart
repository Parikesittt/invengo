import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:invengo/features/auth/presentation/widgets/auth_container.dart';
import 'package:invengo/features/auth/presentation/widgets/auth_footer.dart';
import 'package:invengo/features/auth/presentation/widgets/auth_header.dart';
import 'package:invengo/shared/widgets/custom_button.dart';
import 'package:invengo/shared/widgets/custom_input_form.dart';
import 'package:invengo/features/auth/presentation/widgets/label_form_auth.dart';
import 'package:invengo/core/constant/spacing_helper.dart';
import 'package:invengo/core/services/db_helper.dart';
import 'package:invengo/data/models/user_model.dart';
import 'package:invengo/core/config/route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  final TextEditingController fullNameC = TextEditingController();
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F4FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthHeader(
                    title: "Create Account",
                    subtitle: "Start managing your inventory today",
                  ),
                  h(32),
                  AuthContainer(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          h(8),
                          LabelAuth(title: "Full Name"),
                          h(8),
                          InputForm(
                            hint: "Enter your full name",
                            prefixIcon: Icon(Icons.person_2_outlined),
                            controller: fullNameC,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Nama tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          h(24),
                          LabelAuth(title: "Username"),
                          h(8),
                          InputForm(
                            hint: "Enter your username",
                            prefixIcon: Icon(Icons.person_2_outlined),
                            controller: usernameC,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Username tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          h(24),
                          LabelAuth(title: "Email"),
                          h(8),
                          InputForm(
                            hint: "Enter your email",
                            prefixIcon: Icon(Icons.email_outlined),
                            controller: emailC,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email tidak boleh kosong";
                              }
                              return null;
                            },
                          ),
                          h(24),
                          LabelAuth(title: "Password"),
                          h(8),
                          InputForm(
                            hint: "Enter your password",
                            prefixIcon: Icon(Icons.lock_outline),
                            isPassword: true,
                            controller: passwordC,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password tidak boleh kosong";
                              }
                              if (value.length < 8) {
                                return "Password minimal 8 karakter";
                              }
                              return null;
                            },
                          ),
                          h(24),
                          LabelAuth(title: "Confirm Password"),
                          h(8),
                          InputForm(
                            hint: "Confirm your password",
                            isPassword: true,
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                            validator: (value) {
                              if (value != passwordC.text) {
                                return "Password harus sama";
                              }
                              return null;
                            },
                          ),
                          h(16),
                          Button(
                            buttonText: "Sign Up",
                            height: 48,
                            width: 295,
                            icon: Icons.arrow_forward,
                            click: () {
                              if (_formKey.currentState!.validate()) {
                                // ✅ Semua validator sukses
                                final user = UserModel(
                                  username: usernameC.text,
                                  name: fullNameC.text,
                                  email: emailC.text,
                                  phoneNumber: phoneC.text,
                                  password: passwordC.text,
                                );
                                DBHelper.createUser(user);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Registrasi berhasil"),
                                  ),
                                );

                                // Misal: langsung ke halaman login
                                context.router.replace(const LoginRoute());
                              } else {
                                // ❌ Tampilkan pesan kalau input belum valid
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Periksa input kamu"),
                                  ),
                                );
                              }
                            },
                          ),
                          // h(24),
                          // AuthDivider(text: "register"),
                          // h(24),
                          // AuthSocialButton(),
                        ],
                      ),
                    ),
                  ),
                  AuthFooter(isRegister: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
