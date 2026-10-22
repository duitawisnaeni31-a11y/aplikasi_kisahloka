import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_models.dart';

class GuestHomeScreen extends StatefulWidget {
  final Function(Story) onSelectStory;
  final Function(int) onSwitchTab;

  const GuestHomeScreen({
    Key? key,
    required this.onSelectStory,
    required this.onSwitchTab,
  }) : super(key: key);

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  String selectedCategoryFilter = 'Semua';

  Widget _buildCardImage(Story story) {
    if (story.imageBytes != null) {
      return Image.memory(story.imageBytes!, fit: BoxFit.cover);
    } else if (story.imageFile != null) {
      return Image.file(story.imageFile!, fit: BoxFit.cover);
    } else if (story.imageUrl != null && story.imageUrl!.isNotEmpty) {
      return Image.network(
        story.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Center(child: Text(story.iconEmoji, style: const TextStyle(fontSize: 60))),
      );
    }
    return Center(child: Text(story.iconEmoji, style: const TextStyle(fontSize: 60)));
  }

  @override
  Widget build(BuildContext context) {
    List<Story> filteredStories = selectedCategoryFilter == 'Semua'
        ? globalStories
        : globalStories.where((s) => s.category.toLowerCase() == selectedCategoryFilter.toLowerCase()).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF322219),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    children: const [
                      TextSpan(text: 'Jelajahi Cerita &\nWarisan '),
                      TextSpan(
                        text: 'Nusantara',
                        style: TextStyle(color: Color(0xFFE5A93C)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Platform digital edukasi budaya dan legenda rakyat Indonesia.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFD3C5BB),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip(Icons.book, 'MTS : Mitos', const Color(0xFFC85A2A)),
                      const SizedBox(width: 8),
                      _buildCategoryChip(Icons.menu_book, 'LGN : Legenda', const Color(0xFFD48928)),
                      const SizedBox(width: 8),
                      _buildCategoryChip(Icons.local_florist, 'SJR : Sejarah', const Color(0xFF2C8453)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.filter_list, color: Color(0xFF5A3D28), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCategoryFilter,
                      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF322219)),
                      items: ['Semua', 'Legenda', 'Mitos', 'Sejarah'].map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            'Filter Kategori: $category',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF322219),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedCategoryFilter = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFE5A93C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.diamond, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 10),
              Text(
                'KATALOG CERITA POPULER',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: const Color(0xFF322219),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          filteredStories.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: Text(
                    'Belum ada cerita dalam kategori ini.',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredStories.length,
                  itemBuilder: (context, index) {
                    final story = filteredStories[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => widget.onSelectStory(story),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 180,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFF1D6),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: _buildCardImage(story),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF322219),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.workspace_premium, color: Color(0xFFE5A93C), size: 11),
                                        const SizedBox(width: 4),
                                        Text(
                                          story.category.toUpperCase(),
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFFE5A93C),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    story.title,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF2A1B12),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Asal: ${story.region}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class GuestAccountScreen extends StatelessWidget {
  final VoidCallback onLoginMember;
  final VoidCallback onLoginAdmin;

  const GuestAccountScreen({
    Key? key,
    required this.onLoginMember,
    required this.onLoginAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onLoginMember,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF322219),
                minimumSize: const Size(220, 48),
              ),
              child: Text('Masuk sebagai Member', style: GoogleFonts.poppins(color: Colors.white)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onLoginAdmin,
              style: OutlinedButton.styleFrom(minimumSize: const Size(220, 48)),
              child: Text('Masuk sebagai Admin', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );
  }
}