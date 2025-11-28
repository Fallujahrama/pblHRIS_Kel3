import 'package:flutter/material.dart';
import '../models/superior.dart';

class SuperiorTile extends StatelessWidget {
  final Superior item;

  const SuperiorTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      child: ListTile(
        title: Text(item.fullName),
        subtitle: Text("${item.position} • ${item.companyName}"),
        trailing: Text(item.phone),
      ),
    );
  }
}
