import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_models.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: const Color(0xFF322219),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Hapus Cerita?',
              style: GoogleFonts.playfairDisplay(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Apakah Anda yakin ingin menghapus cerita "${globalStories[index].title}"? Tindakan ini tidak dapat dibatalkan.',
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('BATAL', style: GoogleFonts.poppins(color: Colors.amber, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
                onPressed: () async {
                  setState(() {
                    globalStories.removeAt(index);
                  });
                  await saveStoriesToStorage();
                  if (mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cerita berhasil dihapus.')));
                  }
                },
                child: Text('HAPUS', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EE),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF322219), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Panel Kelola Admin', style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Total Cerita Terbit: ${globalStories.length}', style: GoogleFonts.poppins(color: const Color(0xFFE5A93C), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Daftar Cerita Terbit', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF322219))),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: globalStories.length,
              itemBuilder: (context, index) {
                final story = globalStories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Text(story.iconEmoji, style: const TextStyle(fontSize: 30)),
                    title: Text(story.title, style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
                    subtitle: Text('${story.category} • Asal: ${story.region}', style: GoogleFonts.poppins(fontSize: 12)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, index),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({Key? key}) : super(key: key);

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _regionController = TextEditingController();
  final _summaryController = TextEditingController();
  final _moralController = TextEditingController();
  final _contentController = TextEditingController();

  String _category = 'Legenda';
  File? _selectedImageFile;
  Uint8List? _selectedImageBytes; // Menyimpan data byte gambar HP

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true, // Ambil data byte langsung agar kompatibel di HP
      );

      if (result != null) {
        setState(() {
          if (result.files.single.path != null) {
            _selectedImageFile = File(result.files.single.path!);
          }
          _selectedImageBytes = result.files.single.bytes;
        });
      }
    } catch (e) {
      debugPrint("Error upload: $e");
    }
  }

  void _submitStory() async {
    if (_formKey.currentState!.validate()) {
      // Jika pengguna memilih File tetapi bytes belum terbaca, baca manual dari file
      Uint8List? finalBytes = _selectedImageBytes;
      if (finalBytes == null && _selectedImageFile != null) {
        finalBytes = await _selectedImageFile!.readAsBytes();
      }

      final newStory = Story(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        category: _category,
        region: _regionController.text,
        summary: _summaryController.text,
        content: _contentController.text,
        moralValue: _moralController.text,
        imageFile: _selectedImageFile,
        imageBytes: finalBytes,
        iconEmoji: _category == 'Legenda' ? '⛵' : (_category == 'Mitos' ? '🌊' : '📜'),
      );

      globalStories.insert(0, newStory);
      await saveStoriesToStorage();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cerita berhasil diterbitkan!')));

        _titleController.clear();
        _regionController.clear();
        _summaryController.clear();
        _moralController.clear();
        _contentController.clear();
        setState(() {
          _selectedImageFile = null;
          _selectedImageBytes = null;
        });
      }
    }
  }

  Widget _buildPreviewImage() {
    if (_selectedImageBytes != null) {
      return Image.memory(_selectedImageBytes!, height: 160, width: double.infinity, fit: BoxFit.cover);
    } else if (_selectedImageFile != null) {
      return Image.file(_selectedImageFile!, height: 160, width: double.infinity, fit: BoxFit.cover);
    }
    return Column(
      children: [
        const Icon(Icons.image, size: 50, color: Colors.grey),
        Text('Belum ada gambar terpilih', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EE),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tambah Cerita Baru (Khusus Admin)', style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF322219))),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.brown.shade200)),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildPreviewImage(),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF322219)),
                      icon: const Icon(Icons.upload_file, color: Color(0xFFE5A93C)),
                      label: Text((_selectedImageFile != null || _selectedImageBytes != null) ? 'Ganti Foto Gambar' : 'Pilih Foto dari Galeri HP', style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Cerita', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _regionController,
                      decoration: const InputDecoration(labelText: 'Asal Daerah', border: OutlineInputBorder()),
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _category,
                      decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
                      items: ['Legenda', 'Mitos', 'Sejarah'].map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _category = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _summaryController,
                decoration: const InputDecoration(labelText: 'Ringkasan Singkat', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _moralController,
                decoration: const InputDecoration(labelText: 'Nilai / Pesan Moral', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Isi Cerita Lengkap', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submitStory,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF322219)),
                  child: Text('TERBITKAN CERITA', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}