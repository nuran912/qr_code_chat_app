import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_box/components/my_button.dart';
import 'package:chat_box/components/my_text_field.dart';
import 'package:chat_box/services/auth/auth_service.dart';
import 'package:chat_box/components/error_box.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? errorMessage;

  void signUp() async {
    setState(() => errorMessage = null);
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = "Passwords do not match!";
      });
      return;
    }

    if (usernameController.text.trim().isEmpty) {
      setState(() {
        errorMessage = "Username cannot be empty!";
      });
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signUpWithEmailAndPassword(
        emailController.text,
        passwordController.text,
        usernameController.text.trim(),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception:', '').trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final neonGreen = const Color(0xFF39FF14);
    final bgDark = const Color.fromARGB(255, 0, 20, 49);
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_pin_sharp, size: 100, color: neonGreen),
                const SizedBox(height: 40),
                Text(
                  "Let's Create an Account For You",
                  style: TextStyle(
                    fontSize: 20,
                    color: neonGreen,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (errorMessage != null && errorMessage!.isNotEmpty)
                  ErrorBox(message: errorMessage!, textColor: Colors.red),
                MyTextField(
                  controller: usernameController,
                  hintText: "Username",
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                MyButton(onTap: signUp, text: "Sign Up"),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a Member? ',
                      style: TextStyle(color: neonGreen),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login Now",
                        style: TextStyle(
                          color: neonGreen,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
