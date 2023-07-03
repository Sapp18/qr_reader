import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/providers.dart';
import 'package:qr_reader/utils/utils.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.filter_center_focus),
      onPressed: () async {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#3D8BEF',
          'Cancelar',
          false,
          ScanMode.QR,
        );
        // final barcodeScanRes = 'geo:19.548580202435765,-98.88169775526764';
        // final barcodeScanRes = 'https://google.com';
        if (barcodeScanRes == '-1') return;
        final provider = Provider.of<ScanListProvider>(context, listen: false);
        final nuevoScan = await provider.nuevoScan(barcodeScanRes);
        launchUrl2(context, nuevoScan);
      },
    );
  }
}
