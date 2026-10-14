import 'package:flutter/material.dart';
import '../models/app_models.dart';

class AdminDashboardScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const AdminDashboardScreen({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    int totalStories = globalStories.length;
    int pendingStories = globalStories.where((s) => s.status == 'pending').length;
    int publishedStories = globalStories.where((s) => s.status == 'terbit').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4ECE1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1408),
        foregroundColor: Colors.white,
        title: const Text('Panel Kontrol Admin', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout,
            tooltip: 'Keluar Sesi',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tombol Kembali yang Ditingkatkan Tampilannya
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D1E0B),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: onLogout,
                  icon: const Icon(Icons.arrow_back_rounded, size: 20),
                  label: const Text(
                    'Keluar ke Beranda Utama',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A1408),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Dasbor Administrator 🛡️',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Kelola publikasi cerita, moderasi kiriman anggota, dan kelestarian konten KisahLoka.',
                        style: TextStyle(color: Color(0xFFE5D5C5), fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildStatCard('$totalStories', 'Total Cerita', Icons.library_books, const Color(0xFF1E3A8A)),
                    const SizedBox(width: 14),
                    _buildStatCard('$pendingStories', 'Perlu Moderasi', Icons.hourglass_empty_rounded, const Color(0xFFC2410C)),
                    const SizedBox(width: 14),
                    _buildStatCard('$publishedStories', 'Telah Diterbitkan', Icons.check_circle_rounded, const Color(0xFF15803D)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String count, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD4C3B3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 10),
            Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A0C05))),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF5C2C16)), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class AdminModerationScreen extends StatefulWidget {
  const AdminModerationScreen({super.key});

  @override
  State<AdminModerationScreen> createState() => _AdminModerationScreenState();
}

class _AdminModerationScreenState extends State<AdminModerationScreen> {
  @override
  Widget build(BuildContext context) {
    var pendingStories = globalStories.where((s) => s.status == 'pending').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4ECE1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1408),
        foregroundColor: Colors.white,
        title: const Text('Moderasi Kiriman Cerita', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: pendingStories.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada cerita yang menunggu moderasi.',
                style: TextStyle(color: Color(0xFF5C2C16), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendingStories.length,
              itemBuilder: (ctx, idx) {
                final story = pendingStories[idx];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFD4C3B3), width: 1.2),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8D3C0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(story.iconEmoji, style: const TextStyle(fontSize: 28)),
                    ),
                    title: Text(story.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2A1408))),
                    subtitle: Text('Penulis: ${story.author} • Asal: ${story.region}', style: const TextStyle(color: Color(0xFF5C2C16))),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.green, size: 28),
                          tooltip: 'Setujui & Terbitkan',
                          onPressed: () {
                            setState(() {
                              story.status = 'terbit';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Cerita "${story.title}" berhasil diterbitkan!')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red, size: 28),
                          tooltip: 'Tolak',
                          onPressed: () {
                            setState(() {
                              story.status = 'ditolak';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Cerita "${story.title}" ditolak.')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class AdminStoryManageScreen extends StatefulWidget {
  const AdminStoryManageScreen({super.key});

  @override
  State<AdminStoryManageScreen> createState() => _AdminStoryManageScreenState();
}

class _AdminStoryManageScreenState extends State<AdminStoryManageScreen> {
  void _confirmDelete(BuildContext context, int index, Story story) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFAF6EE),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text(
                'Konfirmasi Hapus',
                style: TextStyle(color: Color(0xFF2A1408), fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus cerita "${story.title}"?\nTindakan ini tidak dapat dibatalkan.',
            style: const TextStyle(color: Color(0xFF3D1E0B), fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal', style: TextStyle(color: Color(0xFF5C2C16), fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                setState(() {
                  globalStories.removeAt(index);
                });
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cerita "${story.title}" telah dihapus secara permanen.'),
                    backgroundColor: Colors.red[900],
                  ),
                );
              },
              child: const Text('Hapus Cerita', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4ECE1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1408),
        foregroundColor: Colors.white,
        title: const Text('Kelola Semua Cerita', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: globalStories.length,
        itemBuilder: (ctx, idx) {
          final story = globalStories[idx];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFD4C3B3), width: 1.2),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8D3C0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(story.iconEmoji, style: const TextStyle(fontSize: 28)),
              ),
              title: Text(story.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2A1408))),
              subtitle: Text(
                'Status: ${story.status.toUpperCase()} • ${story.region}',
                style: TextStyle(
                  color: story.status == 'terbit' ? Colors.green[800] : Colors.orange[900],
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.red, size: 26),
                tooltip: 'Hapus Cerita',
                onPressed: () => _confirmDelete(context, idx, story),
              ),
            ),
          );
        },
      ),
    );
  }
}