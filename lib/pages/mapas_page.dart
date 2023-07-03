import 'package:flutter/material.dart';
import 'package:qr_reader/widgets/widgets.dart';

class MapasPage extends StatelessWidget {
  const MapasPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const CustomListTile(
      icon: Icons.location_on_rounded
    );
  }
}
