import 'package:flutter/cupertino.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrl2(BuildContext context, ScanModel scan) async {
  final Uri _url = Uri.parse(scan.valor);
  if (scan.tipo == 'http') {
    //Abrir el sitio web
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'No se pudo lanzar $_url';
    }
  } else {
    Navigator.pushNamed(
      context,
      'map',
      arguments: scan,
    );
  }
}
