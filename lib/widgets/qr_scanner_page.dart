import 'package:flutter/material.dart';
import 'package:qr_chat_app/widgets/qr_code_page.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

Future<String?> showQRScannerPopUp(BuildContext context) async {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedData = "";

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.photo_camera, size: 30, color: Colors.black),
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
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          Future.microtask(() => showQRPopUp(context));
                        },
                        child: Icon(Icons.qr_code_2, size: 30, color: Colors.grey[500]),
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
                  child: Column(
                    children: [
                      Expanded(
                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: (ctrl) {
                            controller = ctrl;
                            controller?.scannedDataStream.listen((scanData) {
                              setState(() {
                                scannedData = scanData.code ?? "";
                              });

                              if (scannedData.isNotEmpty) {
                                controller?.pauseCamera();
                                Navigator.of(context).pop(scannedData);
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        scannedData.isEmpty ? "Scan a QR code" : "Result: $scannedData",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller?.dispose();
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    },
  );
}
