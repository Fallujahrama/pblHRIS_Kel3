import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PdfService {
  static Future<Uint8List> generateSuratIzin(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header - Tanggal
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Malang, ${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(data['tanggal_izin']))}",
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),

              pw.SizedBox(height: 20),

              // Perihal
              pw.Text(
                "Perihal: Surat ${data['jenis_surat']}",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),

              pw.SizedBox(height: 20),

              // Kepada
              pw.Text("Yth. HRD Perusahaan HRIS", style: const pw.TextStyle(fontSize: 12)),
              pw.Text("di tempat", style: const pw.TextStyle(fontSize: 12)),

              pw.SizedBox(height: 20),

              // Salam Pembuka
              pw.Text("Dengan hormat,", style: const pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 10),

              pw.Text(
                "Saya yang bertanda tangan di bawah ini:",
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 10),

              // Data Karyawan
              pw.Text("Nama        : ${data['nama']}", style: const pw.TextStyle(fontSize: 12)),
              pw.Text("Jabatan     : ${data['jabatan']}", style: const pw.TextStyle(fontSize: 12)),
              pw.Text("Departemen  : ${data['departemen']}", style: const pw.TextStyle(fontSize: 12)),

              pw.SizedBox(height: 20),

              // // Isi Surat
              pw.Text(
                _getIsiSurat(data['jenis_surat'], data['tanggal_izin']),
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(fontSize: 12),
              ),

              pw.SizedBox(height: 30),

                // // Penutup
                // pw.Text(
                //   "Demikian ${data['jenis_surat'].toLowerCase()} ini saya ajukan. "
                //   "Atas perhatiannya, saya ucapkan terima kasih.",
                //   textAlign: pw.TextAlign.justify,
                //   style: const pw.TextStyle(fontSize: 12),
                // ) 

              pw.SizedBox(height: 40),

              // Tanda Tangan
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Hormat saya,", style: const pw.TextStyle(fontSize: 12)),
                    pw.SizedBox(height: 60),
                    pw.Text("${data['nama']}", style: const pw.TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static String _getIsiSurat(String jenisSurat, String tanggal) {
    final tanggalFormat = DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(tanggal));
    
    switch (jenisSurat.toUpperCase()) {
      case 'IZIN':
        return "Bermaksud untuk mengajukan izin tidak masuk kerja pada hari $tanggalFormat.";
      case 'SAKIT':
        return "Dengan ini saya memberitahukan bahwa saya tidak dapat masuk kerja pada hari $tanggalFormat dikarenakan sakit.";
      case 'TUGAS':
        return "Dengan ini saya memberitahukan bahwa saya akan melaksanakan tugas luar kantor pada hari $tanggalFormat.";
      default:
        return "Bermaksud untuk mengajukan $jenisSurat pada hari $tanggalFormat.";
    }
  }
}