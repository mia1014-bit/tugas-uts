import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Tentang Aplikasi",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // 🌟 Logo UIN tampil nimbul
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/uin_logo.png',
                  width: 130,
                ),
              ),
            ),

            const SizedBox(height: 25),
            const Text(
              "Universitas Islam Negeri Sulthan Thaha Saifuddin Jambi",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Aplikasi Feedback Mahasiswa",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 25),

            // 💡 Informasi dalam Card rapi
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              shadowColor: Colors.blue.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _InfoTile(
                      icon: Icons.menu_book_rounded,
                      title: "Mata Kuliah",
                      value: "Pemrograman Mobile",
                    ),
                    SizedBox(height: 14),
                    _InfoTile(
                      icon: Icons.person_pin_rounded,
                      title: "Dosen Pengampu",
                      value: "Ahmad Nasukha, S.Hum., M.S.I ",
                    ),
                    SizedBox(height: 14),
                    _InfoTile(
                      icon: Icons.engineering_rounded,
                      title: "Pengembang",
                      value: "Mia Faradila",
                    ),
                    SizedBox(height: 14),
                    _InfoTile(
                      icon: Icons.calendar_month_rounded,
                      title: "Tahun Akademik",
                      value: "2025 / 2026",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 🔘 Tombol kembali
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text(
                "Kembali ke Beranda",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 5,
                shadowColor: Colors.blueAccent.withOpacity(0.3),
              ),
            ),

            const SizedBox(height: 30),

            // 🩵 Catatan kecil di bawah
            const Text(
              "",
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Widget kecil untuk baris informasi
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          radius: 22,
          child: Icon(icon, color: Colors.blueAccent, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}