import 'package:flutter/material.dart';

class LetterDetailScreen extends StatelessWidget {
  final int id;

  const LetterDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Surat #$id")),
      body: Center(child: Text("Detail surat tampil di sini")),
    );
  }
}
