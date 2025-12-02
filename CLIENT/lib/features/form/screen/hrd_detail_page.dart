import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class HrdDetailPage extends StatelessWidget {
  final Map<String, dynamic> surat;

  const HrdDetailPage({super.key, required this.surat});

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Future<void> updateStatus(BuildContext context, String status) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(status == 'approved' ? 'Approve Surat?' : 'Reject Surat?'),
        content: Text(
          status == 'approved'
              ? 'Apakah Anda yakin ingin menyetujui surat ini?'
              : 'Apakah Anda yakin ingin menolak surat ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: status == 'approved' ? Colors.green : Colors.red,
            ),
            child: Text(status == 'approved' ? 'Approve' : 'Reject'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final success = await ApiService.updateStatus(surat['id'], status);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                status == 'approved'
                    ? 'Surat berhasil disetujui'
                    : 'Surat berhasil ditolak',
              ),
            ),
          );
          context.pop(true); // Kembali ke list dan refresh
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal update status')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = surat['status'] ?? 'pending';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Surat"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Pengajuan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow('Nama', surat['name'] ?? '-'),
                    _buildInfoRow('Jabatan', surat['jabatan'] ?? '-'),
                    _buildInfoRow('Departemen', surat['departemen'] ?? '-'),
                    _buildInfoRow('Jenis Surat', surat['letter_format']?['name'] ?? '-'),
                    _buildInfoRow('Tanggal', formatDate(surat['tanggal'])),
                    _buildInfoRow('Status', status.toUpperCase()),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            if (status == 'pending') ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => updateStatus(context, 'approved'),
                      icon: const Icon(Icons.check),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => updateStatus(context, 'rejected'),
                      icon: const Icon(Icons.close),
                      label: const Text('Reject'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: status == 'approved' ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: status == 'approved' ? Colors.green : Colors.red,
                  ),
                ),
                child: Text(
                  'Surat sudah ${status == 'approved' ? 'disetujui' : 'ditolak'}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: status == 'approved' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
