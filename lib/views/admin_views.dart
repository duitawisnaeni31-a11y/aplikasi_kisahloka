import 'package:flutter/material.dart';
import '../models/app_models.dart';

class AdminDashboardScreen extends StatelessWidget {
  final Function(int) onSwitchTab;

  const AdminDashboardScreen({
    super.key,
    required this.onSwitchTab,
  });

  @override
  Widget build(BuildContext context) {
    int totalStories = globalStories.length;
    int pendingStories = globalStories.where((s) => s.status == 'pending').toList().length;
    int publishedStories = globalStories.where((s) => s.status == 'terbit').toList().length;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(
        title: const Text('Dasbor Administrator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3D1E0B), Color(0xFF5C2C16)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Panel Kontrol Utama ⚙️',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Pantau statistik konten, moderasi cerita masuk, dan kelola katalog KisahLoka.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ringkasan Sistem',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3D1E0B)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildAdminCard('$totalStories', 'Total Cerita', Icons.library_books, Colors.brown),
                    const SizedBox(width: 12),
                    _buildAdminCard('$pendingStories', 'Perlu Moderasi', Icons.fact_check, Colors.orange),
                    const SizedBox(width: 12),
                    _buildAdminCard('$publishedStories', 'Telah Terbit', Icons.check_circle, Colors.green),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Aksi Pengelolaan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3D1E0B)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.fact_check, color: Color(0xFF5C2C16)),
                          title: const Text('Moderasi Cerita', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('$pendingStories cerita menunggu'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => onSwitchTab(1),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.edit_note, color: Color(0xFF5C2C16)),
                          title: const Text('Kelola Katalog', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text('Hapus atau ubah cerita terbit'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => onSwitchTab(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(String count, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5D5C5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// HALAMAN MODERASI CERITA MASUK
class AdminModerationScreen extends StatefulWidget {
  const AdminModerationScreen({super.key});

  @override
  State<AdminModerationScreen> createState() => _AdminModerationScreenState();
}

class _AdminModerationScreenState extends State<AdminModerationScreen> {
  @override
  Widget build(BuildContext context) {
    var pendingList = globalStories.where((s) => s.status == 'pending').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(title: const Text('Moderasi Cerita Masuk')),
      body: pendingList.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada cerita yang menunggu persetujuan saat ini.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendingList.length,
              itemBuilder: (ctx, idx) {
                final story = pendingList[idx];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    leading: Text(story.iconEmoji, style: const TextStyle(fontSize: 28)),
                    title: Text(story.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${story.region} • ${story.category} (Oleh: ${story.author})'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(story.content, style: const TextStyle(height: 1.5)),
                            const SizedBox(height: 12),
                            Text('Pesan Moral: ${story.moralValue}', style: const TextStyle(fontStyle: FontStyle.italic)),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      story.status = 'ditolak';
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Cerita telah ditolak.')),
                                    );
                                  },
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('Tolak'),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E8B57)),
                                  onPressed: () {
                                    setState(() {
                                      story.status = 'terbit';
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Cerita berhasil disetujui & diterbitkan!')),
                                    );
                                  },
                                  icon: const Icon(Icons.check_circle, color: Colors.white),
                                  label: const Text('Setujui & Terbitkan', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// HALAMAN KELOLA CERITA DENGAN DIALOG KONFIRMASI POP-UP NUSANTARA
class AdminManageStoriesScreen extends StatefulWidget {
  const AdminManageStoriesScreen({super.key});

  @override
  State<AdminManageStoriesScreen> createState() => _AdminManageStoriesScreenState();
}

class _AdminManageStoriesScreenState extends State<AdminManageStoriesScreen> {
  void _confirmDelete(BuildContext context, Story story) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFF8F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Color(0xFF5C2C16), size: 28),
            SizedBox(width: 8),
            Text('Konfirmasi Hapus', style: TextStyle(color: Color(0xFF3D1E0B), fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus cerita "${story.title}" dari katalog KisahLoka?',
          style: const TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5C2C16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() {
                globalStories.removeWhere((s) => s.id == story.id);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cerita "${story.title}" berhasil dihapus.')),
              );
            },
            child: const Text('Ya, Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(title: const Text('Kelola Seluruh Cerita')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: globalStories.length,
        itemBuilder: (ctx, idx) {
          final s = globalStories[idx];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Text(s.iconEmoji, style: const TextStyle(fontSize: 28)),
              title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${s.region} • ${s.category} [${s.status.toUpperCase()}]'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, s),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AdminProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;
  const AdminProfileScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(
        title: const Text('Profil Administrator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout,
            tooltip: 'Keluar',
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.admin_panel_settings, size: 80, color: Color(0xFF5C2C16)),
            const SizedBox(height: 16),
            const Text('Administrator KisahLoka', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5C2C16)),
              onPressed: onLogout,
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Keluar dari Sesi Admin', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}