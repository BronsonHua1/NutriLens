import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatelessWidget {
  const BarcodeScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Barcode")),
      body: MobileScanner(
        allowDuplicates: false,
        onDetect: (barcode, args) {
          if (barcode.rawValue == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to scan barcode.")),
            );
            return;
          }
          final String code = barcode.rawValue!;
          Navigator.pop(context, code); // Return scanned code to previous screen
        },
      ),
    );
  }
}
