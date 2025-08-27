import 'package:flutter/material.dart';
import 'package:qr_chat_app/components/my_button.dart';
import 'package:qr_chat_app/components/my_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(height: 100),
                //logo
                Icon(
                  Icons.message,
                  size: 100,
                  color: Colors.grey[800],
                ),
                const SizedBox(height: 50),
                Text(
                  "Welcome Back you\'ve been missed",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),
                //email text field
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                // password text field
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 25),

                //sign in button
                MyButton(onTap: (){}, text: "Sign In"),

                const SizedBox(height: 25),
                //not a member? Register
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a Member?'),
                    SizedBox(width: 4),
                    Text(
                      "Register Now",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )

        ),
      ),
    );
  }
}
