import "package:faztapp/auth/auth_service.dart";
import "package:faztapp/components/my_button.dart";
import "package:faztapp/components/my_textfield.dart";
import "package:flutter/material.dart";

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, required this.onTap});

  final Function()? onTap;

  // email and password controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  // register method
  void register(BuildContext context) async {
    // Get auth service
    final authService = AuthService();

    // passwords doesn't match
    if (_pwController.text != _confirmPwController.text) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Passwords doesn't match"),
              ));
      return;
    }

    // Sign up user
    try {
      await authService.signUpWithEmailPassword(
          _emailController.text, _pwController.text);
    } catch (e) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
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
              Icons.group_add,
              color: Theme.of(context).colorScheme.primary,
              size: 100,
            ),
            const SizedBox(
              height: 50,
            ),
            // welcome back message
            Text(
              'Let\'s create an account for you',
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

            // username text field
            MyTextField(
                hintText: "Username",
                obscureText: false,
                controller: _userNameController),

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

            // confirm password
            MyTextField(
              hintText: 'Confirm password',
              obscureText: true,
              controller: _confirmPwController,
            ),

            const SizedBox(
              height: 25,
            ),
            // login button
            MyButton(text: 'Register', onTap: () => register(context)),
            const SizedBox(
              height: 25,
            ),
            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login now',
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
