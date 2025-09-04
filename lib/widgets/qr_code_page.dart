import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_chat_app/widgets/qr_scanner_page.dart';

void showQRPopUp(BuildContext context) {

  final user = FirebaseAuth.instance.currentUser;
  final userId = user!.uid;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      // Close current dialog first
                      Navigator.of(context, rootNavigator: true).pop();
                      // Then open scanner dialog
                      Future.microtask(() => showQRScannerPopUp(context));
                    },
                    child: Icon(Icons.photo_camera,
                        size: 30, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
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
                  const Icon(Icons.qr_code_2, size: 30),
                  const SizedBox(height: 3),
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
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
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}
