import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../models/app_models.dart';

class SendStoryScreen extends StatefulWidget {
  const SendStoryScreen({Key? key}) : super(key: key);

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
        iconEmoji: _category == 'Legenda' ? '⛵' : (_category == 'Mitos' ? '🌊' : '📜'),
        status: 'approved',
        imageBytes: _selectedImageBytes,
      );

      // Tambahkan cerita baru ke list global
      globalStories.insert(0, newStory);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cerita berhasil diterbitkan!')),
      );

      _titleController.clear();
      _regionController.clear();
      _summaryController.clear();
      _moralController.clear();
      _contentController.clear();
      setState(() {
        _selectedImageBytes = null;
        _selectedImageName = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kirim Cerita Baru',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3C2A21)),
              ),
              const SizedBox(height: 16),
              
              // Frame Upload Foto
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _selectedImageBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(_selectedImageBytes!, height: 120, width: double.infinity, fit: BoxFit.cover),
                          )
                        : const Icon(Icons.image, size: 50, color: Colors.grey),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3C2A21)),
                      icon: const Icon(Icons.upload_file, color: Colors.amber),
                      label: Text(_selectedImageName ?? 'Pilih Foto dari Galeri', style: const TextStyle(color: Colors.white)),
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
                      items: ['Legenda', 'Mitos', 'Sejarah'].map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
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
                decoration: const InputDecoration(labelText: 'Pesan Moral', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _contentController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Isi Cerita Lengkap', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
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