import 'package:faztapp/auth/auth_service.dart';
import 'package:faztapp/components/my_button.dart';
import 'package:faztapp/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  // email and password controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final Function()? onTap;

  LoginPage({super.key, required this.onTap});

  // login method
  void login(BuildContext context) async {
    final AuthService authService = AuthService();

    // try to login
    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _pwController.text);
    }
    // manage exceptions
    catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.group,
              color: Theme.of(context).colorScheme.primary,
              size: 100,
            ),
            const SizedBox(
              height: 50,
            ),
            // welcome back message
            Text(
              'Welcome back, you\'ve been missed',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // email text field
            MyTextField(
              hintText: 'Type your email',
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(
              height: 25,
            ),
            // password text field
            MyTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _pwController,
            ),

            const SizedBox(
              height: 25,
            ),
            // login button
            MyButton(text: 'Login', onTap: () => login(context)),
            const SizedBox(
              height: 25,
            ),
            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Register now',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
