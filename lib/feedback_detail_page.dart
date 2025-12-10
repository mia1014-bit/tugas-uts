import 'package:flutter/material.dart';
import 'model/feedback_item.dart';

class FeedbackDetailPage extends StatelessWidget {
  final FeedbackItem feedback;

  const FeedbackDetailPage({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: const Text(
          "Detail Feedback Mahasiswa",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _buildInfoTile(
              icon: Icons.person_outline,
              title: "Nama",
              content: feedback.nama,
            ),
            _buildInfoTile(
              icon: Icons.badge_outlined,
              title: "NIM",
              content: feedback.nim,
            ),
            _buildInfoTile(
              icon: Icons.school_outlined,
              title: "Fakultas",
              content: feedback.fakultas,
            ),
            _buildInfoTile(
              icon: Icons.category_outlined,
              title: "Jenis Feedback",
              content: feedback.jenis,
            ),
            _buildInfoTile(
              icon: Icons.star_border_outlined,
              title: "Nilai Kepuasan",
              content: feedback.nilai.toStringAsFixed(1),
            ),

            // 📝 Komentar hanya isi komentar (tanpa fasilitas)
            if (feedback.komentar.isNotEmpty)
              _buildInfoTile(
                icon: Icons.comment_outlined,
                title: "Komentar",
                content: feedback.komentar,
              ),

            // 🏢 Fasilitas (tanpa tanda kurung)
            if (feedback.komentar.contains('Fasilitas:'))
              _buildInfoTile(
                icon: Icons.business_outlined,
                title: "Fasilitas",
                content: _ambilFasilitas(feedback.komentar),
              ),
          ],
        ),
      ),
    );
  }

  // 🔹 Mengambil teks fasilitas dengan rapi
  String _ambilFasilitas(String komentar) {
    final startIndex = komentar.indexOf('Fasilitas: ');
    if (startIndex == -1) return '-';
    var fasilitas = komentar.substring(startIndex + 11).trim();
    if (fasilitas.endsWith(')')) {
      fasilitas = fasilitas.substring(0, fasilitas.length - 1);
    }
    return fasilitas;
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 3,
      shadowColor: Colors.blue.withOpacity(0.15),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            content,
            style: const TextStyle(fontSize: 14.5),
          ),
        ),
      ),
    );
  }
}