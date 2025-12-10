import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/feedback_item.dart';
import 'feedback_detail_page.dart';

class FeedbackListPage extends StatefulWidget {
  const FeedbackListPage({super.key});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  List<FeedbackItem> feedbackList = [];
  List<FeedbackItem> filteredList = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  Future<void> _loadFeedback() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('feedbackList') ?? [];
    setState(() {
      feedbackList = data
          .map((e) => FeedbackItem.fromMap(jsonDecode(e)))
          .toList()
          .reversed
          .toList();
      filteredList = feedbackList;
    });
  }

  Future<void> _deleteFeedback(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('feedbackList') ?? [];

    final reversedIndex = feedbackList.length - 1 - index;
    data.removeAt(reversedIndex);
    await prefs.setStringList('feedbackList', data);

    setState(() {
      feedbackList.removeAt(index);
      filteredList = feedbackList;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Feedback berhasil dihapus!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _showDeleteDialog(int index) async {
    final feedback = filteredList[index];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Konfirmasi Hapus",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text(
          "Apakah kamu yakin ingin menghapus feedback milik ${feedback.nama}?",
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _deleteFeedback(index);
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _searchFeedback(String query) {
    setState(() {
      filteredList = feedbackList
          .where((item) =>
      item.nama.toLowerCase().contains(query.toLowerCase()) ||
          item.fakultas.toLowerCase().contains(query.toLowerCase()) ||
          item.jenis.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  IconData _getIconForType(String jenis) {
    switch (jenis) {
      case 'Apresiasi':
        return Icons.thumb_up_alt_outlined;
      case 'Saran':
        return Icons.lightbulb_outline;
      case 'Keluhan':
        return Icons.report_problem_outlined;
      default:
        return Icons.feedback_outlined;
    }
  }

  Color _getColorForType(String jenis) {
    switch (jenis) {
      case 'Apresiasi':
        return Colors.green;
      case 'Saran':
        return Colors.orange;
      case 'Keluhan':
        return Colors.redAccent;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: const Text(
          'Daftar Feedback Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Segarkan Data',
            onPressed: _loadFeedback,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: _searchFeedback,
              decoration: InputDecoration(
                hintText: 'Cari nama, fakultas, atau jenis feedback...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor:
                isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
              child: Text(
                "Belum ada data feedback.",
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
                : ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return Card(
                  elevation: 5,
                  shadowColor: Colors.blue.withOpacity(0.2),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                      _getColorForType(item.jenis).withOpacity(0.15),
                      child: Icon(
                        _getIconForType(item.jenis),
                        color: _getColorForType(item.jenis),
                      ),
                    ),
                    title: Text(
                      item.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.fakultas,
                          style: const TextStyle(fontSize: 13.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Nilai Kepuasan: ${item.nilai.toStringAsFixed(1)}",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent),
                      tooltip: 'Hapus feedback ini',
                      onPressed: () => _showDeleteDialog(index),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              FeedbackDetailPage(feedback: item),
                          transitionsBuilder: (_, anim, __, child) {
                            return FadeTransition(
                              opacity: anim,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}