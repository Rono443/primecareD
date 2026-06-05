import 'package:flutter/material.dart';

class QRScannerWidget extends StatelessWidget {
  const QRScannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR/Barcode')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.qr_code_scanner, size: 100, color: Colors.white),
            ),
            const SizedBox(height: 32),
            const Text('Align QR code within the frame', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
