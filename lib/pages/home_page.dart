import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_chat_app/widgets/qr_code_page.dart';
import 'package:qr_chat_app/services/auth/auth_service.dart';
import 'package:qr_chat_app/widgets/qr_scanner_page.dart';

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

    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user!.email;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("$userEmail", style: TextStyle(color: Colors.white,)),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          //sign out button
          IconButton(
              onPressed: signOut,
              icon: const Icon(Icons.logout),
              color: Colors.white,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Oops, No chats yet :(", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[400]),),
            Text("Start a new chat now!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[400]),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //pop up for QR code
          showQRScannerPopUp(context);
        },
        backgroundColor: Colors.black,
        elevation: 0,
        highlightElevation: 0,
        child: const Icon(Icons.add_outlined, color: Colors.white,),
      ),
    );
  }
}
