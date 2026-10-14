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
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(
        title: const Text('Panel Kontrol Admin'),
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
                TextButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF5C2C16)),
                  label: const Text('Keluar ke Beranda Utama', style: TextStyle(color: Color(0xFF5C2C16), fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D1E0B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Dasbor Administrator 🛡️',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Kelola publikasi cerita, moderasi kiriman anggota, dan kelestarian konten KisahLoka.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildStatCard('$totalStories', 'Total Cerita', Icons.library_books, Colors.blue),
                    const SizedBox(width: 12),
                    _buildStatCard('$pendingStories', 'Perlu Moderasi', Icons.hourglass_empty, Colors.orange),
                    const SizedBox(width: 12),
                    _buildStatCard('$publishedStories', 'Telah Diterbitkan', Icons.check_circle, Colors.green),
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5D5C5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
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
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(title: const Text('Moderasi Kiriman Cerita')),
      body: pendingStories.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada cerita yang menunggu moderasi.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendingStories.length,
              itemBuilder: (ctx, idx) {
                final story = pendingStories[idx];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(story.iconEmoji, style: const TextStyle(fontSize: 30)),
                    title: Text(story.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Penulis: ${story.author} • Asal: ${story.region}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.green),
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
                          icon: const Icon(Icons.cancel, color: Colors.red),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(title: const Text('Kelola Semua Cerita')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: globalStories.length,
        itemBuilder: (ctx, idx) {
          final story = globalStories[idx];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Text(story.iconEmoji, style: const TextStyle(fontSize: 30)),
              title: Text(story.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Status: ${story.status.toUpperCase()} • ${story.region}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    globalStories.removeAt(idx);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cerita "${story.title}" dihapus.')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}