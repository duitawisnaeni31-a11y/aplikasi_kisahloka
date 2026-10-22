import 'dart:io';
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
  void _deleteStory(int index) {
    setState(() {
      globalStories.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cerita dihapus oleh Admin.')));
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
                      onPressed: () => _deleteStory(index),
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

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedImageFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint("Error upload: $e");
    }
  }

  void _submitStory() {
    if (_formKey.currentState!.validate()) {
      final newStory = Story(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        category: _category,
        region: _regionController.text,
        summary: _summaryController.text,
        content: _contentController.text,
        moralValue: _moralController.text,
        imageFile: _selectedImageFile,
        audioUrl: 'https://actions.google.com/sounds/v1/ambiences/outdoor_river.ogg',
        iconEmoji: _category == 'Legenda' ? '⛵' : (_category == 'Mitos' ? '🌊' : '📜'),
      );

      globalStories.insert(0, newStory);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cerita berhasil diterbitkan!')));

      _titleController.clear();
      _regionController.clear();
      _summaryController.clear();
      _moralController.clear();
      _contentController.clear();
      setState(() => _selectedImageFile = null);
    }
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
                    _selectedImageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_selectedImageFile!, height: 160, width: double.infinity, fit: BoxFit.cover),
                          )
                        : Column(
                            children: [
                              const Icon(Icons.image, size: 50, color: Colors.grey),
                              Text('Belum ada gambar terpilih', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF322219)),
                      icon: const Icon(Icons.upload_file, color: Color(0xFFE5A93C)),
                      label: Text(_selectedImageFile != null ? 'Ganti Foto Gambar' : 'Pilih Foto dari Galeri', style: GoogleFonts.poppins(color: Colors.white)),
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