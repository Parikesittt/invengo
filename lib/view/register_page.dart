import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:invengo/components/custom_button.dart';
import 'package:invengo/components/custom_input_form.dart';
import 'package:invengo/components/custome_image_button.dart';
import 'package:invengo/database/db_helper.dart';
import 'package:invengo/model/user_model.dart';
import 'package:invengo/route.dart';
import 'package:invengo/view/login_page.dart';
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
                  Column(
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff8C5CF5), Color(0xffEB489A)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: AlignmentGeometry.center,
                        child: Text(
                          "I",
                          style: TextStyle(fontSize: 32, color: Colors.white),
                        ),
                      ),
                      height(16),
                      Text(
                        "Create Account",
                        style: TextStyle(
                          color: Color(0xff101828),
                          fontSize: 30,
                        ),
                      ),
                      height(8),
                      Text(
                        "Start managing your inventory today",
                        style: TextStyle(
                          color: Color(0x60101828),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  height(32),
                  Container(
                    padding: EdgeInsets.all(24),
                    width: 343,
                    // height: 453,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          height(8),
                          Text(
                            "Full Name",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          height(8),
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
                          height(24),
                          Text(
                            "Username",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          height(8),
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
                          height(24),
                          Text(
                            "Email Address",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          height(8),
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
                          height(24),
                          Text(
                            "Password",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          height(8),
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
                          height(24),
                          Text(
                            "Confirm Password",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          height(8),
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
                          height(16),
                          Button(
                            buttonText: "Sign In",
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
                          height(24),
                          Row(
                            spacing: 8,
                            children: [
                              Expanded(
                                child: Divider(color: Color(0x20101828)),
                              ),
                              Text(
                                "Or login with",
                                style: TextStyle(color: Color(0x60101828)),
                              ),
                              Expanded(
                                child: Divider(color: Color(0x20101828)),
                              ),
                            ],
                          ),
                          height(24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 12,
                            children: [
                              ImageButton(
                                image: 'assets/images/iconGoogle.png',
                                buttonText: "Google",
                                onPressed: () {},
                              ),
                              ImageButton(
                                image: 'assets/images/Vector.png',
                                buttonText: "Github",
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(color: Color(0x60101828)),
                      ),
                      TextButton(
                        onPressed: () {
                          context.pushRoute(const LoginRoute());
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return LoginPage();
                          //     },
                          //   ),
                          // );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Color(0xff8B5CF6)),
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

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);
}
