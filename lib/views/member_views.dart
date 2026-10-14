import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/app_models.dart';

class MemberDashboardScreen extends StatelessWidget {
  final VoidCallback onLogout;
  final Function(int) onNavigateTab;

  const MemberDashboardScreen({
    super.key,
    required this.onLogout,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    int publishedCount = globalStories.where((s) => s.status == 'terbit').length;
    int pendingCount = globalStories.where((s) => s.status == 'pending' && s.author == 'Anggota').length;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(
        title: const Text('Dasbor Anggota'),
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
                  label: const Text('Kembali ke Beranda Utama', style: TextStyle(color: Color(0xFF5C2C16), fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5C2C16), Color(0xFF8B4513)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Selamat Datang, Anggota KisahLoka! 👋',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Kelola cerita favoritmu dan berkontribusi melestarikan legenda Nusantara.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Aktivitas Saya',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3D1E0B)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatCard('$publishedCount', 'Cerita Terbit', Icons.menu_book, Colors.orange),
                    const SizedBox(width: 12),
                    _buildStatCard('$pendingCount', 'Menunggu Moderasi', Icons.hourglass_top, Colors.amber.shade800),
                    const SizedBox(width: 12),
                    _buildStatCard('${globalStories.where((s) => s.isFavorite).length}', 'Favorit Saya', Icons.favorite, Colors.red),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFF3E9DC),
                      child: Icon(Icons.add_circle, color: Color(0xFF5C2C16)),
                    ),
                    title: const Text('Kirimkan Cerita Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: const Text('Punya kisah/legenda lokal dari daerahmu? Bagikan sekarang.'),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5C2C16)),
                      onPressed: () => onNavigateTab(2),
                      child: const Text('Tulis Cerita', style: TextStyle(color: Colors.white)),
                    ),
                  ),
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

class FavoriteMemberScreen extends StatelessWidget {
  const FavoriteMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var favStories = globalStories.where((s) => s.isFavorite).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(title: const Text('Cerita Favorit Saya')),
      body: favStories.isEmpty
          ? const Center(
              child: Text(
                'Belum ada cerita favorit yang ditambahkan.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favStories.length,
              itemBuilder: (ctx, idx) {
                final s = favStories[idx];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(s.iconEmoji, style: const TextStyle(fontSize: 30)),
                    title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${s.region} • ${s.category}'),
                  ),
                );
              },
            ),
    );
  }
}

class SendStoryScreen extends StatefulWidget {
  final VoidCallback? onSuccess;

  const SendStoryScreen({
    super.key,
    this.onSuccess,
  });

  @override
  State<SendStoryScreen> createState() => _SendStoryScreenState();
}

class _SendStoryScreenState extends State<SendStoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _regionController = TextEditingController();
  final _summaryController = TextEditingController();
  final _moralController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'Legenda';
  String? _selectedFileName;

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFileName = result.files.first.name;
        });
      }
    } catch (e) {
      debugPrint("File Picker Error: $e");
    }
  }

  void _submitStory() {
    if (_formKey.currentState!.validate()) {
      final newStory = Story(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        region: _regionController.text,
        category: _selectedCategory,
        summary: _summaryController.text,
        moralValue: _moralController.text,
        content: _contentController.text,
        iconEmoji: '📜',
        status: 'pending',
        author: 'Anggota',
      );

      globalStories.add(newStory);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cerita berhasil dikirim! Menunggu persetujuan Admin.'),
          backgroundColor: Color(0xFF5C2C16),
        ),
      );

      _titleController.clear();
      _regionController.clear();
      _summaryController.clear();
      _moralController.clear();
      _contentController.clear();
      setState(() {
        _selectedFileName = null;
      });

      if (widget.onSuccess != null) {
        widget.onSuccess!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(title: const Text('Kirim Cerita Nusantara')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Formulir Kontribusi Cerita',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3D1E0B)),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Cerita yang kamu kirimkan akan ditinjau oleh Admin terlebih dahulu sebelum diterbitkan.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const Divider(height: 32),

                      // FITUR UPLOAD GAMBAR PROFIL
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8F0),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE5D5C5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Foto Profil / Cover Cerita',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D1E0B)),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5C2C16),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: _pickImage,
                                  icon: const Icon(Icons.upload_file),
                                  label: const Text('Pilih Foto dari Galeri / Komputer'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _selectedFileName ?? 'Belum ada foto dipilih',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Judul Cerita',
                          hintText: 'Misal: Lutung Kasarung',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Judul wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _regionController,
                              decoration: InputDecoration(
                                labelText: 'Asal Daerah',
                                hintText: 'Misal: Jawa Barat',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              validator: (v) => v == null || v.isEmpty ? 'Asal daerah wajib diisi' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              decoration: InputDecoration(
                                labelText: 'Kategori',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              items: ['Legenda', 'Mitos', 'Sejarah']
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _selectedCategory = v);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _summaryController,
                        decoration: InputDecoration(
                          labelText: 'Ringkasan Singkat',
                          hintText: 'Penjelasan 1-2 kalimat mengenai cerita...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Ringkasan wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _moralController,
                        decoration: InputDecoration(
                          labelText: 'Nilai / Pesan Moral',
                          hintText: 'Pesan kebaikan yang ingin disampaikan...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Pesan moral wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contentController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          labelText: 'Isi Cerita Lengkap',
                          hintText: 'Tuliskan alur narasi cerita selengkap mungkin...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Isi cerita wajib diisi' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C2C16),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _submitStory,
                          icon: const Icon(Icons.send),
                          label: const Text('Kirimkan Cerita ke Admin', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}