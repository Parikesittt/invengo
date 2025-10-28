import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:invengo/components/custom_button.dart';
import 'package:invengo/components/custom_input_form.dart';
import 'package:invengo/components/custome_image_button.dart';
import 'package:invengo/database/db_helper.dart';
import 'package:invengo/preferences/preference_handler.dart';
import 'package:invengo/route.dart';
import 'package:invengo/view/register_page.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F4FF),
      body: Center(
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
                  "Welcome Back",
                  style: TextStyle(color: Color(0xff101828), fontSize: 30),
                ),
                height(8),
                Text(
                  "Sign in to continue to Invengo",
                  style: TextStyle(color: Color(0x60101828), fontSize: 16),
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
                  BorderSide(color: Color(0xffe5e7eb)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height(8),
                  Text(
                    "Email Address",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  height(8),
                  InputForm(
                    hint: "Enter your email",
                    prefixIcon: Icon(Icons.email_outlined),
                    controller: emailC,
                  ),
                  height(24),
                  Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  height(8),
                  InputForm(
                    hint: "Enter your password",
                    isPassword: true,
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    controller: passwordC,
                  ),
                  height(16),
                  Row(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value!;
                              });
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                rememberMe = !rememberMe;
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets
                                  .zero, // 🔹 Hilangin padding horizontal default
                              minimumSize: Size(
                                0,
                                0,
                              ), // opsional, biar gak nambah space
                              tapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, // rapat area klik
                            ),
                            child: Text(
                              "Remember Me",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0x80101828),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password ?",
                          style: TextStyle(
                            color: Color(0xff4D81E7),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(24),
                  Button(
                    buttonText: "Sign In",
                    height: 48,
                    width: 295,
                    icon: Icons.arrow_forward,
                    click: () async {
                      PreferenceHandler.saveLogin(true);
                      final data = await DBHelper.loginUser(
                        email: emailC.text,
                        password: passwordC.text,
                      );
                      if (data != null) {
                        context.pushRoute(const MainRoute());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Email atau password salah"),
                          ),
                        );
                      }
                    },
                  ),
                  height(24),
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(child: Divider(color: Color(0x20101828))),
                      Text(
                        "Or login with",
                        style: TextStyle(color: Color(0x60101828)),
                      ),
                      Expanded(child: Divider(color: Color(0x20101828))),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(color: Color(0x60101828)),
                ),
                TextButton(
                  onPressed: () {
                    context.pushRoute(const RegisterRoute());
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return RegisterPage();
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
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);
}
