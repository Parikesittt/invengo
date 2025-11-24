import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:invengo/core/constant/app_color.dart';
import 'package:invengo/core/config/route.dart';

class AuthFooter extends StatelessWidget {
  final bool isRegister;
  const AuthFooter({super.key, required this.isRegister});

  @override
  Widget build(BuildContext context) {
    return isRegister
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(color: AppColor.primaryTextLightOpacity60),
              ),
              TextButton(
                onPressed: () {
                  context.pushRoute(const LoginRouteFirebase());
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(color: Color(0xff8B5CF6)),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(color: AppColor.primaryTextLightOpacity60),
              ),
              TextButton(
                onPressed: () {
                  context.pushRoute(const RegisterRouteFirebase());
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Color(0xff8B5CF6)),
                ),
              ),
            ],
          );
  }
}
