import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF4ECE1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1408),
        foregroundColor: Colors.white,
        title: const Text('Dasbor Anggota', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout,
            tooltip: 'Keluar',
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
                    children: [
                      const Text(
                        'Halo, Penjelajah Budaya! 👋',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Bagikan legenda dan cerita kisah rakyat dari daerahmu untuk melestarikan budaya Nusantara.',
                        style: TextStyle(color: Color(0xFFE5D5C5), fontSize: 14, height: 1.4),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD97706),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => onNavigateTab(2),
                        icon: const Icon(Icons.create),
                        label: const Text('Tulis Cerita Baru Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavoriteMemberScreen extends StatelessWidget {
  const FavoriteMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var publishedStories = globalStories.where((s) => s.status == 'terbit').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4ECE1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1408),
        foregroundColor: Colors.white,
        title: const Text('Cerita Favorit Saya', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: publishedStories.isEmpty
          ? const Center(
              child: Text(
                'Belum ada cerita favorit tersimpan.',
                style: TextStyle(color: Color(0xFF5C2C16), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: publishedStories.length,
              itemBuilder: (ctx, idx) {
                final story = publishedStories[idx];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFD4C3B3), width: 1.2),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8D3C0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(story.iconEmoji, style: const TextStyle(fontSize: 28)),
                    ),
                    title: Text(story.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2A1408))),
                    subtitle: Text('📍 ${story.region} • ${story.category}', style: const TextStyle(color: Color(0xFF5C2C16))),
                    trailing: const Icon(Icons.favorite, color: Colors.red, size: 26),
                  ),
                );
              },
            ),
    );
  }
}

class SendStoryScreen extends StatefulWidget {
  final VoidCallback onSuccess;
  const SendStoryScreen({super.key, required this.onSuccess});

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
  String _category = 'Legenda';

  Uint8List? _selectedImageBytes;
  String? _selectedImageName;

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.first.bytes != null) {
        setState(() {
          _selectedImageBytes = result.files.first.bytes;
          _selectedImageName = result.files.first.name;
        });
      }
    } catch (e) {
      debugPrint("Gagal memilih file: $e");
    }
  }

  void _submitStory() {
    if (_formKey.currentState!.validate()) {
      final newStory = Story(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        region: _regionController.text,
        category: _category,
        summary: _summaryController.text,
        content: _contentController.text,
        moralValue: _moralController.text,
        iconEmoji: _category == 'Legenda' ? '🏔️' : (_category == 'Mitos' ? '🌊' : '📜'),
        status: 'pending',
        author: 'Anggota KisahLoka',
        imageBytes: _selectedImageBytes,
      );

      globalStories.add(newStory);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Cerita berhasil dikirim! Menunggu moderasi dari Admin.'),
          backgroundColor: Color(0xFF2A1408),
        ),
      );

      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4ECE1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1408),
        foregroundColor: Colors.white,
        title: const Text('Kirim Cerita Nusantara', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Card(
              elevation: 5,
              color: const Color(0xFFFFFDF9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFD4C3B3), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Formulir Kontribusi Cerita',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2A1408)),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Cerita yang kamu kirimkan akan ditinjau oleh Admin terlebih dahulu sebelum diterbitkan.',
                        style: TextStyle(color: Color(0xFF5C2C16), fontSize: 13, height: 1.4),
                      ),
                      const Divider(height: 28, color: Color(0xFFD4C3B3), thickness: 1.2),
                      
                      // AREA UPLOAD FOTO
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F3EA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFC7B299), width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Foto Profil / Cover Cerita',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2A1408), fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3D1E0B),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: _pickImage,
                                  icon: const Icon(Icons.upload_file),
                                  label: const Text('Pilih Foto dari Galeri / Komputer', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _selectedImageName ?? 'Belum ada foto dipilih',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF5C2C16), fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (_selectedImageBytes != null) ...[
                              const SizedBox(height: 14),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(_selectedImageBytes!, height: 160, width: double.infinity, fit: BoxFit.cover),
                              ),
                            ]
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      _buildTextField(_titleController, 'Judul Cerita', 'Masukkan judul cerita...'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildTextField(_regionController, 'Asal Daerah', 'Contoh: Jawa Barat')),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _category,
                              decoration: _inputDecoration('Kategori'),
                              items: ['Legenda', 'Mitos', 'Sejarah']
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontWeight: FontWeight.w600))))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _category = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(_summaryController, 'Ringkasan Singkat', 'Tuliskan ringkasan 1-2 kalimat...'),
                      const SizedBox(height: 16),
                      _buildTextField(_moralController, 'Nilai / Pesan Moral', 'Pesan moral dari cerita ini...'),
                      const SizedBox(height: 16),
                      _buildTextField(_contentController, 'Isi Cerita Lengkap', 'Tuliskan cerita lengkap di sini...', maxLines: 6),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A1408),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _submitStory,
                          icon: const Icon(Icons.send_rounded),
                          label: const Text('Kirimkan Cerita ke Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildTextField(TextEditingController controller, String label, String hint, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Color(0xFF1A0C05), fontWeight: FontWeight.w500),
      decoration: _inputDecoration(label, hint: hint),
      validator: (val) => (val == null || val.isEmpty) ? '$label tidak boleh kosong' : null,
    );
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Color(0xFF3D1E0B), fontWeight: FontWeight.bold),
      hintStyle: const TextStyle(color: Color(0xFF8C7355), fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFF9F3EA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFC7B299), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2A1408), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}