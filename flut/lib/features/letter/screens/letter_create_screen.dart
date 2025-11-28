import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/letter_controller.dart';

class LetterCreateScreen extends StatefulWidget {
  final dynamic jenisSurat;

  const LetterCreateScreen({super.key, this.jenisSurat});

  @override
  State<LetterCreateScreen> createState() => _LetterCreateScreenState();
}

class _LetterCreateScreenState extends State<LetterCreateScreen> {
  final namaC = TextEditingController();
  DateTime? tgl;

  final controller = LetterController();

  Future<void> pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => tgl = picked);
    }
  }

  void submit() async {
    final data = {
      "nama": namaC.text,
      "jenis_surat": widget.jenisSurat['id'],
      "tanggal": DateFormat("yyyy-MM-dd").format(tgl!),
    };

    final res = await controller.createLetter(data);

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Surat berhasil dibuat!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buat Surat")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaC,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: pickTanggal,
              child: Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  tgl == null
                      ? "Pilih Tanggal"
                      : DateFormat("yyyy-MM-dd").format(tgl!),
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: submit,
              child: const Text("Buat Surat"),
            )
          ],
        ),
      ),
    );
  }
}
