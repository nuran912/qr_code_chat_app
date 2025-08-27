import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_chat_app/services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //sign out method
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
        actions: [
          //sign out button
          IconButton(
              onPressed: signOut,
              icon: const Icon(Icons.logout),
              color: Colors.black,
          )
        ],
      ),
    );
  }
}
