import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:chat_box/widgets/qr_scanner_page.dart';

void showQRPopUp(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;
  final userId = user!.uid;

  final neonGreen = const Color(0xFF39FF14);
  final bgDark = const Color.fromARGB(255, 0, 20, 49);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        
        backgroundColor: bgDark,
        title: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      Future.microtask(() => showQRScannerPopUp(context));
                    },
                    child: Icon(
                      Icons.photo_camera,
                      size: 30,
                      color: neonGreen.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: neonGreen.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_2, size: 30, color: neonGreen),
                  const SizedBox(height: 3),
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: neonGreen,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 300,
          height: 300,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: SizedBox(
              height: 250,
              width: 250,
              child: Center(
                child: QrImageView(
                  data: userId,
                  version: QrVersions.auto,
                  size: 200,
                  gapless: false,
                  foregroundColor: neonGreen,
                  backgroundColor: Color.fromARGB(255, 0, 20, 49),
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close", style: TextStyle(color: neonGreen)),
          ),
        ],
      );
    },
  );
}
