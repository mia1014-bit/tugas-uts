class FeedbackItem {
  final String nama;
  final String nim;
  final String fakultas;
  final String jenis;
  final double nilai;
  final String komentar;

  FeedbackItem({
    required this.nama,
    required this.nim,
    required this.fakultas,
    required this.jenis,
    required this.nilai,
    required this.komentar,
  });

  // Untuk simpan data ke SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'nim': nim,
      'fakultas': fakultas,
      'jenis': jenis,
      'nilai': nilai,
      'komentar': komentar,
    };
  }

  // Untuk ambil data dari SharedPreferences
  factory FeedbackItem.fromMap(Map<String, dynamic> map) {
    return FeedbackItem(
      nama: map['nama'] ?? '',
      nim: map['nim'] ?? '',
      fakultas: map['fakultas'] ?? '',
      jenis: map['jenis'] ?? '',
      nilai: (map['nilai'] as num).toDouble(),
      komentar: map['komentar'] ?? '',
    );
  }
}