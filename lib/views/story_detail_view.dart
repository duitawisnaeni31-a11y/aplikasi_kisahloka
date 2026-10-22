import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/app_models.dart';

class GuestDetailScreen extends StatefulWidget {
  final Story story;
  final VoidCallback onBack;

  const GuestDetailScreen({
    Key? key,
    required this.story,
    required this.onBack,
  }) : super(key: key);

  @override
  State<GuestDetailScreen> createState() => _GuestDetailScreenState();
}

class _GuestDetailScreenState extends State<GuestDetailScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool isLoadingAudio = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      setState(() => isLoadingAudio = true);
      try {
        String url = widget.story.audioUrl ?? 'https://ia800201.us.archive.org/12/items/IndonesianStoryAudio/Sangkuriang.mp3';
        await _audioPlayer.play(UrlSource(url));
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memutar audio: $e')));
        }
      } finally {
        if (mounted) setState(() => isLoadingAudio = false);
      }
    }
  }

  Widget _buildCoverImage() {
    if (widget.story.imageFile != null) {
      return Image.file(widget.story.imageFile!, fit: BoxFit.cover, width: double.infinity);
    } else if (widget.story.imageBytes != null) {
      return Image.memory(widget.story.imageBytes!, fit: BoxFit.cover, width: double.infinity);
    } else if (widget.story.imageUrl != null && widget.story.imageUrl!.isNotEmpty) {
      return Image.network(
        widget.story.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Center(child: Text(widget.story.iconEmoji, style: const TextStyle(fontSize: 80))),
      );
    }
    return Center(child: Text(widget.story.iconEmoji, style: const TextStyle(fontSize: 80)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF322219),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE5A93C)),
          onPressed: widget.onBack,
        ),
        title: Text(widget.story.title, style: GoogleFonts.playfairDisplay(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFFFFF1D6), borderRadius: BorderRadius.circular(16)),
              child: ClipRRect(borderRadius: BorderRadius.circular(16), child: _buildCoverImage()),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Chip(
                  label: Text(widget.story.category.toUpperCase(), style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                  backgroundColor: const Color(0xFF322219),
                ),
                Text('Asal: ${widget.story.region}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF322219))),
              ],
            ),
            const SizedBox(height: 12),

            Card(
              color: const Color(0xFF322219),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.volume_up, color: Color(0xFFE5A93C), size: 32),
                title: Text('Dengarkan Suara Narasi Cerita', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(isPlaying ? 'Sedang Memutar Suara Narasi...' : 'Tekan Play untuk Mendengarkan Narasi', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                trailing: isLoadingAudio
                    ? const CircularProgressIndicator(color: Color(0xFFE5A93C))
                    : IconButton(
                        icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: const Color(0xFFE5A93C), size: 40),
                        onPressed: _toggleAudio,
                      ),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book, color: Color(0xFFE5A93C)),
                      const SizedBox(width: 8),
                      Text('Isi Cerita Lengkap', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF322219))),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(widget.story.content, style: GoogleFonts.poppins(fontSize: 14, height: 1.6, color: Colors.black.withOpacity(0.85))),
                  const SizedBox(height: 20),
                  if (widget.story.moralValue.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F6EE),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('💡 Nilai / Pesan Moral:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF322219))),
                          const SizedBox(height: 4),
                          Text(widget.story.moralValue, style: GoogleFonts.poppins(fontStyle: FontStyle.italic, color: Colors.black.withOpacity(0.75))),
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