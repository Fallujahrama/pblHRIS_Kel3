import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../controllers/letter_controller.dart';
import '../services/pdf_service.dart';
import '../models/letter_format.dart';

class LetterCreateScreen extends StatefulWidget {
  final LetterFormat jenisSurat;

  const LetterCreateScreen({super.key, required this.jenisSurat});

  @override
  State<LetterCreateScreen> createState() => _LetterCreateScreenState();
}

class _LetterCreateScreenState extends State<LetterCreateScreen> {
  final namaC = TextEditingController();
  final jabatanC = TextEditingController();
  final departemenC = TextEditingController();
  DateTime? tanggalIzin;

  final controller = LetterController();

  Future<void> pickTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => tanggalIzin = picked);
    }
  }

  Future<void> submit() async {
    if (namaC.text.isEmpty || jabatanC.text.isEmpty || 
        departemenC.text.isEmpty || tanggalIzin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi!")),
      );
      return;
    }

    final data = {
      "nama": namaC.text,
      "jabatan": jabatanC.text,
      "departemen": departemenC.text,
      "jenis_surat": widget.jenisSurat.name,
      "tanggal_izin": DateFormat("yyyy-MM-dd").format(tanggalIzin!),
    };

    // Generate PDF
    final pdfBytes = await PdfService.generateSuratIzin(data);

    // Tampilkan Preview PDF
    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
    );

    // Simpan ke database (opsional)
    // final res = await controller.createLetter(data);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF berhasil dibuat!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Surat ${widget.jenisSurat.name}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Jenis Surat
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Template: ${widget.jenisSurat.name}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Form Fields
            TextField(
              controller: namaC,
              decoration: const InputDecoration(
                labelText: "Nama Lengkap",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: jabatanC,
              decoration: const InputDecoration(
                labelText: "Jabatan",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: departemenC,
              decoration: const InputDecoration(
                labelText: "Departemen",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
            ),
            const SizedBox(height: 16),

            // Date Picker
            GestureDetector(
              onTap: pickTanggal,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.grey),
                    const SizedBox(width: 12),
                    Text(
                      tanggalIzin == null
                          ? "Pilih Tanggal ${widget.jenisSurat.name}"
                          : DateFormat("dd MMMM yyyy").format(tanggalIzin!),
                      style: TextStyle(
                        fontSize: 16,
                        color: tanggalIzin == null ? Colors.grey : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: submit,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Generate PDF"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    namaC.dispose();
    jabatanC.dispose();
    departemenC.dispose();
    super.dispose();
  }
}
