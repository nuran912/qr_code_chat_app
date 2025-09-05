import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_box/components/my_button.dart';
import 'package:chat_box/components/my_text_field.dart';
import 'package:chat_box/services/auth/auth_service.dart';
import 'package:chat_box/components/error_box.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorMessage;

  void signIn() async {
    setState(() => errorMessage = null);
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
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
                Icon(Icons.assignment_ind, size: 100, color: neonGreen),
                const SizedBox(height: 40),
                Text(
                  "Welcome Back! You've been missed",
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
                const SizedBox(height: 30),
                MyButton(onTap: signIn, text: "Sign In"),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a Member? ', style: TextStyle(color: neonGreen)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now",
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
