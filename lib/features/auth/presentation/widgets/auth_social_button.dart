import 'package:flutter/material.dart';
import 'package:invengo/shared/widgets/custome_image_button.dart';

class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}