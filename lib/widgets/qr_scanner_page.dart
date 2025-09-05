import 'package:flutter/material.dart';
import 'package:chat_box/widgets/qr_code_page.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

Future<String?> showQRScannerPopUp(BuildContext context) async {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedData = "";

  final neonGreen = const Color(0xFF39FF14);
  final bgDark = const Color.fromARGB(255, 0, 20, 49);
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            
            backgroundColor: bgDark,
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.photo_camera, size: 30, color: neonGreen),
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
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          Future.microtask(() => showQRPopUp(context));
                        },
                        child: Icon(
                          Icons.qr_code_2,
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
                        scannedData.isEmpty
                            ? "Scan a QR code"
                            : "Result: $scannedData",
                        style: TextStyle(fontSize: 14, color: neonGreen),
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
                child: Text("Close", style: TextStyle(color: neonGreen)),
              ),
            ],
          );
        },
      );
    },
  );
}
