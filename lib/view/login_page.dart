import 'package:descarte_bem/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = context.read<UserController>();

    return Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 40),
            SignInButton(
              buttonType: ButtonType.googleDark,
              btnText: "Entrar com o Google",
              onPressed: () {
                userController.login();
              },
            ),
          ],
        ),
      ),
    );
  }
}
