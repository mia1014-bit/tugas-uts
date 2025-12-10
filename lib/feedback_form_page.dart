import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'model/feedback_item.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  String nama = '';
  String nim = '';
  String fakultas = '';
  String jenisFeedback = 'Apresiasi';
  double nilaiKepuasan = 3;
  String komentar = '';

  final List<String> fasilitasList = [
    'Kantin',
    'Perpustakaan',
    'Kelas',
    'Parkiran',
    'Toilet',
    'Laboratorium',
    'Ruang Baca',
  ];
  final List<String> fasilitasDipilih = [];

  final fakultasList = [
    'Fakultas Ilmu Tarbiyah dan Keguruan',
    'Fakultas Syariah',
    'Fakultas Ushuluddin dan Studi Agama',
    'Fakultas Adab dan Humaniora',
    'Fakultas Ekonomi dan Bisnis Islam',
    'Fakultas Sains dan Teknologi',
    'Fakultas Dakwah',
  ];

  final jenisList = ['Apresiasi', 'Saran', 'Keluhan'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: const Text(
          "Formulir Feedback Mahasiswa",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCard([
                _buildTextField(
                  label: "Nama Mahasiswa",
                  icon: Icons.person_outline,
                  onSaved: (val) => nama = val!,
                  validator: (val) =>
                  val!.isEmpty ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: "NIM",
                  icon: Icons.badge_outlined,
                  onSaved: (val) => nim = val!,
                  validator: (val) => val!.isEmpty ? 'NIM wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  label: "Pilih Fakultas",
                  icon: Icons.school_outlined,
                  items: fakultasList,
                  value: fakultas.isEmpty ? null : fakultas,
                  onChanged: (val) => setState(() => fakultas = val!),
                  validator: (val) =>
                  val == null ? 'Silakan pilih fakultas' : null,
                ),
              ]),
              const SizedBox(height: 16),
              _buildCard([
                _buildDropdownField(
                  label: "Jenis Feedback",
                  icon: Icons.category_outlined,
                  items: jenisList,
                  value: jenisFeedback,
                  onChanged: (val) => setState(() => jenisFeedback = val!),
                ),
                const SizedBox(height: 16),
                Text(
                  "Nilai Kepuasan: ${nilaiKepuasan.toStringAsFixed(1)}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Slider(
                  value: nilaiKepuasan,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  activeColor: Colors.blueAccent,
                  onChanged: (val) =>
                      setState(() => nilaiKepuasan = val),
                ),
              ]),
              const SizedBox(height: 16),
              _buildCard([
                const Text(
                  "Fasilitas yang Dinilai:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                ...fasilitasList.map((item) => CheckboxListTile(
                  title: Text(item),
                  value: fasilitasDipilih.contains(item),
                  activeColor: Colors.blueAccent,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        fasilitasDipilih.add(item);
                      } else {
                        fasilitasDipilih.remove(item);
                      }
                    });
                  },
                )),
              ]),
              const SizedBox(height: 16),
              _buildCard([
                _buildTextField(
                  label: "Komentar (opsional)",
                  icon: Icons.comment_outlined,
                  onSaved: (val) => komentar = val ?? '',
                  maxLines: 3,
                ),
              ]),
              const SizedBox(height: 25),

              // 📤 Tombol kirim (teks putih)
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  "Kirim Feedback",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor: Colors.blueAccent.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 6,
      shadowColor: Colors.blue.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required List<String> items,
    String? value,
    required void Function(String?) onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final fasilitasGabung = fasilitasDipilih.join(', ');
      final newFeedback = FeedbackItem(
        nama: nama,
        nim: nim,
        fakultas: fakultas,
        jenis: jenisFeedback,
        nilai: nilaiKepuasan,
        komentar: komentar.isNotEmpty
            ? "$komentar (Fasilitas: $fasilitasGabung)"
            : "Fasilitas: $fasilitasGabung",
      );

      // 🔹 Simpan ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getStringList('feedbackList') ?? [];
      data.add(jsonEncode(newFeedback.toMap()));
      await prefs.setStringList('feedbackList', data);

      // ✅ Tampilkan notifikasi sukses
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Feedback berhasil dikirim!",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.blueAccent,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        // Tunggu sedikit sebelum kembali
        await Future.delayed(const Duration(milliseconds: 800));
        Navigator.pop(context, newFeedback);
      }
    }
  }
}