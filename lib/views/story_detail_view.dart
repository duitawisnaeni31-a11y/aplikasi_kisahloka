import 'package:flutter/material.dart';
import '../models/app_models.dart';

class GuestDetailScreen extends StatelessWidget {
  final Story story;
  final VoidCallback onBack;

  const GuestDetailScreen({
    Key? key,
    required this.story,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C2A21),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: onBack,
        ),
        title: Text(
          story.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Cerita
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: story.imageBytes != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(story.imageBytes!, fit: BoxFit.cover),
                    )
                  : story.imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(story.imageFile!, fit: BoxFit.cover),
                        )
                      : Center(
                          child: Text(story.iconEmoji, style: const TextStyle(fontSize: 80)),
                        ),
            ),
            const SizedBox(height: 16),

            // Kategori & Daerah
            Row(
              children: [
                Chip(
                  label: Text(
                    story.category.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  backgroundColor: const Color(0xFF3C2A21),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '📍 Asal: ${story.region}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF3C2A21)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Card Simulasi Narasi Audio
            Card(
              color: const Color(0xFF3C2A21),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.volume_up, color: Colors.amber, size: 32),
                title: const Text(
                  'Dengarkan Narasi Cerita',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Fitur Audio Narasi Siap Diputar',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.play_circle_fill, color: Colors.amber, size: 40),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Memutar Audio Narasi...')),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Isi Cerita
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.menu_book, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Isi Cerita',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3C2A21)),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    story.content,
                    style: TextStyle(fontSize: 15, height: 1.6, color: Colors.black.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 20),
                  if (story.moralValue.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5EFE6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '💡 Nilai / Pesan Moral:',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3C2A21)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            story.moralValue,
                            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}