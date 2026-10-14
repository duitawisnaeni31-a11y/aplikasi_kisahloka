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
      backgroundColor: const Color(0xFFFAF6EE),
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
                          decoration: InputDecoration(
                            hintText: 'Cari judul / asal daerah...',
                            prefixIcon: const Icon(Icons.search, color: Color(0xFF5C2C16)),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFFE5D5C5)),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE5D5C5)),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedCategory,
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
                Text('⚜️  ', style: TextStyle(fontSize: 18, color: Color(0xFF8B4513))),
                Text(
                  'KATALOG CERITA POPULER',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Color(0xFF3D1E0B),
                  ),
                ),
                Text('  ⚜️', style: TextStyle(fontSize: 18, color: Color(0xFF8B4513))),
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
      color: const Color(0xFFFAF6EE),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3D1E0B)),
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
                child: const Icon(Icons.person_outline, color: Color(0xFF3D1E0B)),
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFF5C2C16) : Colors.black87,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Container(
            padding: const EdgeInsets.all(36),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFFE8D3C0), Color(0xFFC7A88B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Jelajahi Cerita &\nWarisan Nusantara',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D1B10),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Platform digital edukasi budaya dan legenda rakyat Indonesia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF5C2C16)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _categoryBadge('MTS : Mitos', const Color(0xFF8B4513)),
                    const SizedBox(width: 8),
                    _categoryBadge('LGN : Legenda', const Color(0xFFA0522D)),
                    const SizedBox(width: 8),
                    _categoryBadge('SJR : Sejarah', const Color(0xFF2E8B57)),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStoryCard(Story story) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5D5C5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
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
                color: Color(0xFFF3E9DC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Center(child: Text(story.iconEmoji, style: const TextStyle(fontSize: 50))),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B4513),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        story.category.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3D1E0B)),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 2),
                    Text(story.region, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  story.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C2C16),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () => widget.onSelectStory(story),
                    child: const Text('Baca Selengkapnya ➔', style: TextStyle(fontSize: 12)),
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
      color: const Color(0xFF2D1B10),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        children: const [
          Text('KisahLoka', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
      backgroundColor: const Color(0xFFFAF6EE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: const Color(0xFFFAF6EE),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: onBack,
                        child: Row(
                          children: const [
                            Icon(Icons.arrow_back, size: 16, color: Color(0xFF5C2C16)),
                            SizedBox(width: 4),
                            Text('Kembali ke Beranda', style: TextStyle(color: Color(0xFF5C2C16), fontWeight: FontWeight.bold)),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B4513),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          story.category.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        story.title.toUpperCase(),
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2D1B10)),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('Asal Daerah: ${story.region}', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 280,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5D5C5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: Text(story.iconEmoji, style: const TextStyle(fontSize: 80))),
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
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3D1E0B)),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      story.content,
                                      style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
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
                                      AudioPlayerWidget(storyText: "${story.title}. Asal daerah: ${story.region}.${story.summary}"),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5D5C5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.star, color: Color(0xFF8B4513), size: 18),
              SizedBox(width: 6),
              Text('Nilai Moral', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D1E0B))),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '"${story.moralValue}"',
            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildMapBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5D5C5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.map, color: Color(0xFF8B4513), size: 18),
              SizedBox(width: 6),
              Text('Peta Asal-Usul', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE5D5C5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 36),
                  const SizedBox(height: 4),
                  Text(
                    story.region,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D1E0B)),
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

// WIDGET AUDIO NARASI STABIL PURE FLUTTER
class AudioPlayerWidget extends StatefulWidget {
  final String storyText;
  const AudioPlayerWidget({super.key, required this.storyText});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool isPlaying = false;

  void _toggleAudio() {
    setState(() {
      isPlaying = !isPlaying;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isPlaying ? '🔊 Memutar Audio Narasi Cerita...' : '⏹️ Audio Diberhentikan.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5D5C5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.headphones, color: Color(0xFF8B4513), size: 18),
              SizedBox(width: 6),
              Text('Audio Narasi Interaktif', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isPlaying ? const Color(0xFFD97706) : const Color(0xFF5C2C16),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(42),
            ),
            onPressed: _toggleAudio,
            icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
            label: Text(isPlaying ? 'Hentikan Narasi Suara' : 'Dengarkan Narasi Suara'),
          )
        ],
      ),
    );
  }
}

// HALAMAN PETA CERITA NUSANTARA
class GuestExploreScreen extends StatelessWidget {
  final Function(Story) onSelectStory;
  const GuestExploreScreen({super.key, required this.onSelectStory});

  @override
  Widget build(BuildContext context) {
    var publishedStories = globalStories.where((s) => s.status == 'terbit').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(title: const Text('Jelajah Peta Cerita Nusantara')),
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
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8D3C0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF5C2C16), width: 1.5),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Text(
                          '🗺️\nPETA SEBARAN LEGENDA INDONESIA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3D1E0B),
                            letterSpacing: 1.1,
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
                const SizedBox(height: 24),
                const Text(
                  'Titik Cerita Berdasarkan Daerah',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3D1E0B)),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: publishedStories.length,
                  itemBuilder: (ctx, idx) {
                    final story = publishedStories[idx];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E9DC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(story.iconEmoji, style: const TextStyle(fontSize: 24)),
                        ),
                        title: Text(story.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('📍 ${story.region}  •${story.category}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF5C2C16)),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF5C2C16),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, color: Colors.amber, size: 14),
            const SizedBox(width: 4),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// HALAMAN LOGIN PERAN NUSANTARA
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
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(title: const Text('Masuk ke KisahLoka')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3E9DC),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('🏰', style: TextStyle(fontSize: 40)),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Selamat Datang',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3D1E0B)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Pilih peran masuk untuk melanjutkan ke portal KisahLoka',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C2C16),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: onLoginMember,
                        icon: const Icon(Icons.person),
                        label: const Text('Masuk sebagai Anggota', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF5C2C16),
                          side: const BorderSide(color: Color(0xFF5C2C16), width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: onLoginAdmin,
                        icon: const Icon(Icons.admin_panel_settings),
                        label: const Text('Masuk sebagai Admin', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ); // <-- Tutup Scaffold
  } // <-- Tutup build method
} // <-- Tutup Class GuestAccountScreen