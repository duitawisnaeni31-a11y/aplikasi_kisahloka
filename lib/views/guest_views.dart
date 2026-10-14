import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/app_models.dart';

class GuestHomeScreen extends StatefulWidget {
  final Function(Story) onSelectStory;
  final Function(int) onSwitchTab;

  const GuestHomeScreen({
    super.key,
    required this.onSelectStory,
    required this.onSwitchTab,
  });

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    var filteredStories = globalStories.where((s) {
      bool matchesSearch = s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.region.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesCategory = _selectedCategory == 'Semua' || s.category == _selectedCategory;
      return matchesSearch && matchesCategory && s.status == 'terbit';
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4ECE1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCustomNavbar(),
            _buildHeroBanner(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Color(0xFF1A0C05), fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Cari judul / asal daerah...',
                            hintStyle: const TextStyle(color: Color(0xFF8C7355)),
                            prefixIcon: const Icon(Icons.search, color: Color(0xFF2A1408)),
                            filled: true,
                            fillColor: const Color(0xFFFFFDF9),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFFC7B299), width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF2A1408), width: 2),
                            ),
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val),
                        ),
                      ),
                      const SizedBox(width: 16),
                      DropdownButtonHideUnderline(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFDF9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFC7B299), width: 1.5),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            dropdownColor: const Color(0xFFFFFDF9),
                            style: const TextStyle(color: Color(0xFF2A1408), fontWeight: FontWeight.bold),
                            items: ['Semua', 'Legenda', 'Mitos', 'Sejarah']
                                .map((c) => DropdownMenuItem(value: c, child: Text('Filter Kategori: $c')))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCategory = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('⚜️  ', style: TextStyle(fontSize: 20, color: Color(0xFF2A1408))),
                Text(
                  'KATALOG CERITA POPULER',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.3,
                    color: Color(0xFF1A0C05),
                  ),
                ),
                Text('  ⚜️', style: TextStyle(fontSize: 20, color: Color(0xFF2A1408))),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 700 ? 3 : (constraints.maxWidth > 480 ? 2 : 1);
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.70,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredStories.length,
                        itemBuilder: (context, index) {
                          final story = filteredStories[index];
                          return _buildStoryCard(story);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNavbar() {
    return Container(
      color: const Color(0xFF2A1408),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Row(
            children: [
              Row(
                children: const [
                  Text('🏰 ', style: TextStyle(fontSize: 22)),
                  Text(
                    'KisahLoka',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              const Spacer(),
              _navLink('Beranda', isSelected: true, onTap: () => widget.onSwitchTab(0)),
              _navLink('Kategori', onTap: () => widget.onSwitchTab(1)),
              _navLink('Peta', onTap: () => widget.onSwitchTab(2)),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => widget.onSwitchTab(3),
                child: const Icon(Icons.person_pin, color: Colors.amber, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navLink(String title, {bool isSelected = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
            color: isSelected ? Colors.amber : Colors.white70,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF3D1E0B), Color(0xFF1A0C05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Jelajahi Cerita &\nWarisan Nusantara',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Platform digital edukasi budaya dan legenda rakyat Indonesia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Color(0xFFE5D5C5), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _categoryBadge('MTS : Mitos', const Color(0xFFC2410C)),
                    const SizedBox(width: 10),
                    _categoryBadge('LGN : Legenda', const Color(0xFFD97706)),
                    const SizedBox(width: 10),
                    _categoryBadge('SJR : Sejarah', const Color(0xFF15803D)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStoryCard(Story story) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC7B299), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFE8D3C0),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: story.imageBytes != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.memory(story.imageBytes!, fit: BoxFit.cover),
                          )
                        : Center(child: Text(story.iconEmoji, style: const TextStyle(fontSize: 55))),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A1408),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        story.category.toUpperCase(),
                        style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A0C05)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Color(0xFF3D1E0B)),
                    const SizedBox(width: 4),
                    Text(story.region, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5C2C16))),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  story.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF3D1E0B), height: 1.3),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A1408),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () => widget.onSelectStory(story),
                    child: const Text('Baca Selengkapnya ➔', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A0C05),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      child: Column(
        children: const [
          Text('KisahLoka', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 6),
          Text('© 2026 KisahLoka. Melestarikan Budaya Nusantara.', style: TextStyle(color: Colors.white60, fontSize: 12)),
        ],
      ),
    );
  }
}

class GuestDetailScreen extends StatelessWidget {
  final Story story;
  final VoidCallback onBack;

  const GuestDetailScreen({
    super.key,
    required this.story,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4ECE1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              color: const Color(0xFF2A1408),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: onBack,
                        child: Row(
                          children: const [
                            Icon(Icons.arrow_back, size: 18, color: Colors.amber),
                            SizedBox(width: 6),
                            Text('Kembali ke Beranda Utama', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A1408),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          story.category.toUpperCase(),
                          style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        story.title.toUpperCase(),
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF1A0C05)),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Color(0xFF5C2C16)),
                          const SizedBox(width: 4),
                          Text('Asal Daerah: ${story.region}', style: const TextStyle(color: Color(0xFF5C2C16), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 320,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7B299),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF2A1408), width: 2),
                        ),
                        child: story.imageBytes != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(story.imageBytes!, fit: BoxFit.cover),
                              )
                            : Center(child: Text(story.iconEmoji, style: const TextStyle(fontSize: 90))),
                      ),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          bool isWide = constraints.maxWidth > 700;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: isWide ? 2 : 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '⚜️ Isi Cerita',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A0C05)),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      story.content,
                                      style: const TextStyle(fontSize: 15, height: 1.7, color: Color(0xFF2A1408), fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              if (isWide) const SizedBox(width: 24),
                              if (isWide)
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      _buildMoralBox(),
                                      const SizedBox(height: 16),
                                      AudioPlayerWidget(
                                        storyText: "${story.title}. Asal daerah: ${story.region}. ${story.summary} ${story.content}",
                                      ),
                                      const SizedBox(height: 16),
                                      _buildMapBox(),
                                    ],
                                  ),
                                )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoralBox() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC7B299), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.star, color: Color(0xFFD97706), size: 20),
              SizedBox(width: 6),
              Text('Nilai Moral', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A0C05), fontSize: 15)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '"${story.moralValue}"',
            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13, color: Color(0xFF3D1E0B), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildMapBox() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC7B299), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.map, color: Color(0xFF2A1408), size: 20),
              SizedBox(width: 6),
              Text('Peta Asal-Usul', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A0C05))),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFFE8D3C0),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2A1408), width: 1),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 40),
                  const SizedBox(height: 4),
                  Text(
                    story.region,
                    style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1A0C05), fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String storyText;
  const AudioPlayerWidget({super.key, required this.storyText});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool isPlaying = false;

  void _speak() {
    if (!kIsWeb) return;

    try {
      final synth = html.window.speechSynthesis;
      synth?.cancel();

      final utterance = html.SpeechSynthesisUtterance(widget.storyText)
        ..lang = 'id-ID'
        ..rate = 0.9
        ..pitch = 1.0;

      utterance.onEnd.listen((_) {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      });

      synth?.speak(utterance);
      setState(() {
        isPlaying = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🔊 Memutar Narasi Suara Bahasa Indonesia...'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF2A1408),
        ),
      );
    } catch (e) {
      debugPrint("Speech Synthesis Error: $e");
    }
  }

  void _stop() {
    if (!kIsWeb) return;

    try {
      html.window.speechSynthesis?.cancel();
      setState(() {
        isPlaying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⏹️ Audio Diberhentikan.'),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFF2A1408),
        ),
      );
    } catch (e) {
      debugPrint("Speech Stop Error: $e");
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      html.window.speechSynthesis?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC7B299), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.headphones, color: Color(0xFF2A1408), size: 20),
              SizedBox(width: 6),
              Text('Audio Narasi Interaktif', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A0C05))),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isPlaying ? const Color(0xFFD97706) : const Color(0xFF2A1408),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (isPlaying) {
                _stop();
              } else {
                _speak();
              }
            },
            icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
            label: Text(isPlaying ? 'Hentikan Narasi Suara' : 'Dengarkan Narasi Suara', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class GuestExploreScreen extends StatelessWidget {
  final Function(Story) onSelectStory;
  const GuestExploreScreen({super.key, required this.onSelectStory});

  @override
  Widget build(BuildContext context) {
    var publishedStories = globalStories.where((s) => s.status == 'terbit').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4ECE1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1408),
        foregroundColor: Colors.white,
        title: const Text('Jelajah Peta Cerita Nusantara', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D1E0B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2A1408), width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
                    ],
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Text(
                          '🗺️\nPETA SEBARAN LEGENDA INDONESIA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 80,
                        child: _mapPin('Sumatera Utara', 'Danau Toba', publishedStories, onSelectStory),
                      ),
                      Positioned(
                        top: 100,
                        left: 120,
                        child: _mapPin('Sumatera Barat', 'Malin Kundang', publishedStories, onSelectStory),
                      ),
                      Positioned(
                        bottom: 40,
                        right: 250,
                        child: _mapPin('Jawa Tengah', 'Roro Jonggrang', publishedStories, onSelectStory),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Titik Cerita Berdasarkan Daerah',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A0C05)),
                ),
                const SizedBox(height: 14),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: publishedStories.length,
                  itemBuilder: (ctx, idx) {
                    final story = publishedStories[idx];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFC7B299), width: 1.2),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8D3C0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(story.iconEmoji, style: const TextStyle(fontSize: 26)),
                        ),
                        title: Text(story.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A0C05))),
                        subtitle: Text('📍 ${story.region}  •  ${story.category}', style: const TextStyle(color: Color(0xFF5C2C16), fontWeight: FontWeight.w600)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF2A1408)),
                        onTap: () => onSelectStory(story),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mapPin(String region, String title, List<Story> stories, Function(Story) onSelect) {
    return InkWell(
      onTap: () {
        final story = stories.firstWhere((s) => s.title.contains(title), orElse: () => stories.first);
        onSelect(story);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2A1408),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber, width: 1.5),
          boxShadow: const [
            BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3))
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class GuestAccountScreen extends StatelessWidget {
  final VoidCallback onLoginMember;
  final VoidCallback onLoginAdmin;

  const GuestAccountScreen({
    super.key,
    required this.onLoginMember,
    required this.onLoginAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4ECE1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1408),
        foregroundColor: Colors.white,
        title: const Text('Masuk ke KisahLoka', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              elevation: 6,
              color: const Color(0xFFFFFDF9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFC7B299), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8D3C0),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('🏰', style: TextStyle(fontSize: 48)),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Selamat Datang',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1A0C05)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pilih peran masuk untuk melanjutkan ke portal KisahLoka',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF5C2C16), fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A1408),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: onLoginMember,
                        icon: const Icon(Icons.person, color: Colors.amber),
                        label: const Text('Masuk sebagai Anggota', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2A1408),
                          side: const BorderSide(color: Color(0xFF2A1408), width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: onLoginAdmin,
                        icon: const Icon(Icons.admin_panel_settings, color: Color(0xFF2A1408)),
                        label: const Text('Masuk sebagai Admin', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}