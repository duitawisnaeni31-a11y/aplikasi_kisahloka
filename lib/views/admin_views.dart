import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../models/app_models.dart';

class AddStoryView extends StatefulWidget {
  const AddStoryView({Key? key}) : super(key: key);

  @override
  State<AddStoryView> createState() => _AddStoryViewState();
}

class _AddStoryViewState extends State<AddStoryView> {
  final _titleController = TextEditingController();
  final _regionController = TextEditingController();
  final _summaryController = TextEditingController();
  final _moralController = TextEditingController();
  final _contentController = TextEditingController();

  String _selectedCategory = 'Legenda';
  File? _selectedImageFile;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImageFile = File(result.files.single.path!);
      });
    }
  }

  void _submitStory() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan Isi Cerita wajib diisi!')),
      );
      return;
    }

    final newStory = Story(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      category: _selectedCategory,
      region: _regionController.text.isEmpty ? 'Indonesia' : _regionController.text,
      summary: _summaryController.text,
      moralValue: _moralController.text,
      content: _contentController.text,
      imageFile: _selectedImageFile,
      iconEmoji: _selectedCategory == 'Legenda' ? '⛵' : (_selectedCategory == 'Mitos' ? '🌊' : '📜'),
    );

    globalStories.insert(0, newStory);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cerita berhasil diterbitkan ke Dasbor Utama!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C2A21),
        title: const Text('Kirim Cerita Nusantara', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Formulir Kontribusi Cerita',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3C2A21)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Cerita yang kamu kirimkan akan langsung diterbitkan di dasbor utama.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Upload Foto dari Galeri
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EFE6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.brown.shade200),
                ),
                child: Column(
                  children: [
                    const Text('Foto Profil / Cover Cerita', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _selectedImageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_selectedImageFile!, height: 140, width: double.infinity, fit: BoxFit.cover),
                          )
                        : const Icon(Icons.image, size: 50, color: Colors.grey),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3C2A21)),
                      icon: const Icon(Icons.upload_file, color: Colors.amber),
                      label: const Text('Pilih Foto dari Galeri', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Cerita', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _regionController,
                      decoration: const InputDecoration(labelText: 'Asal Daerah', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
                      items: ['Legenda', 'Mitos', 'Sejarah'].map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _summaryController,
                decoration: const InputDecoration(labelText: 'Ringkasan Singkat', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _moralController,
                decoration: const InputDecoration(labelText: 'Nilai / Pesan Moral', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Isi Cerita Lengkap', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submitStory,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3C2A21)),
                  child: const Text('TERBITKAN CERITA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}