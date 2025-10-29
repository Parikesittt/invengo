import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:invengo/components/auth/auth_container.dart';
import 'package:invengo/components/auth/auth_divider.dart';
import 'package:invengo/components/auth/auth_footer.dart';
import 'package:invengo/components/auth/auth_header.dart';
import 'package:invengo/components/auth/auth_social_button.dart';
import 'package:invengo/components/custom_button.dart';
import 'package:invengo/components/custom_input_form.dart';
import 'package:invengo/components/custome_image_button.dart';
import 'package:invengo/components/auth/label_form_auth.dart';
import 'package:invengo/constant/app_color.dart';
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
            AuthHeader(
              title: "Welcome Back",
              subtitle: "Sign in to continue to Invengo",
            ),
            height(32),
            AuthContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height(8),
                  LabelAuth(title: "Email"),
                  height(8),
                  InputForm(
                    hint: "Enter your email",
                    prefixIcon: Icon(Icons.email_outlined),
                    controller: emailC,
                  ),
                  height(24),
                  LabelAuth(title: "Password"),
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
                                color: AppColor.primaryTextLightOpacity80,
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
                  AuthDivider(text: "continue"),
                  height(24),
                  AuthSocialButton(),
                ],
              ),
            ),
            AuthFooter(isRegister: false),
          ],
        ),
      ),
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);
}
