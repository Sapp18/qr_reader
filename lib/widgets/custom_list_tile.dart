import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/providers.dart';
import 'package:qr_reader/utils/utils.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  const CustomListTile({
    Key? key,
    required this.icon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScanListProvider>(context);
    final scans = provider.scans;
    return ListView.builder(
      itemCount: scans.length,
      itemBuilder: (_, index) => Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.redAccent,
        ),
        onDismissed: (direction) => Provider.of<ScanListProvider>(context, listen: false)
            .borrarScanPorId(scans[index].id ?? 0),
        child: ListTile(
          subtitle: Text(scans[index].id.toString()),
          title: Text(scans[index].valor),
          trailing: const Icon(Icons.keyboard_arrow_right),
          leading: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          onTap: () => launchUrl2(context, scans[index]),
        ),
      ),
    );
  }
}
