import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_models.dart';

class GuestHomeScreen extends StatefulWidget {
  final Function(Story) onSelectStory;

  const GuestHomeScreen({Key? key, required this.onSelectStory}) : super(key: key);

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  String selectedCategoryFilter = 'Semua';

  Widget _buildCardImage(Story story) {
    if (story.imageBytes != null) {
      return Image.memory(story.imageBytes!, fit: BoxFit.cover, width: double.infinity);
    } else if (story.imageFile != null) {
      return Image.file(story.imageFile!, fit: BoxFit.cover, width: double.infinity);
    } else if (story.imageUrl != null && story.imageUrl!.isNotEmpty) {
      return Image.network(
        story.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
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
                      TextSpan(text: 'Nusantara', style: TextStyle(color: Color(0xFFE5A93C))),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Platform digital edukasi budaya dan legenda rakyat Indonesia.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: const Color(0xFFD3C5BB), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
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
                          child: Text('Filter Kategori: $category', style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF322219))),
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
                decoration: const BoxDecoration(color: Color(0xFFE5A93C), shape: BoxShape.circle),
                child: const Icon(Icons.diamond, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 10),
              Text('KATALOG CERITA POPULER', style: GoogleFonts.playfairDisplay(fontSize: 17, fontWeight: FontWeight.bold, color: const Color(0xFF322219))),
            ],
          ),
          const SizedBox(height: 14),

          filteredStories.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: Text('Belum ada cerita dalam kategori ini.', style: GoogleFonts.poppins(color: Colors.grey)),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(color: const Color(0xFF322219), borderRadius: BorderRadius.circular(12)),
                                        child: Text(
                                          story.category.toUpperCase(),
                                          style: GoogleFonts.poppins(color: const Color(0xFFE5A93C), fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(story.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            story.isFavorite = !story.isFavorite;
                                          });
                                          saveStoriesToStorage();
                                        },
                                      )
                                    ],
                                  ),
                                  Text(story.title, style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF2A1B12))),
                                  Text('Asal: ${story.region}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
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
}

class CategoryViewScreen extends StatelessWidget {
  final Function(String) onSelectCategory;

  const CategoryViewScreen({Key? key, required this.onSelectCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Legenda', 'icon': '⛵', 'color': const Color(0xFFD48928), 'desc': 'Kisah rakyat turun temurun Nusantara.'},
      {'name': 'Mitos', 'icon': '🌊', 'color': const Color(0xFFC85A2A), 'desc': 'Kepercayaan & supranatural daerah.'},
      {'name': 'Sejarah', 'icon': '📜', 'color': const Color(0xFF2C8453), 'desc': 'Peristiwa nyata kebangsaan & perjuangan.'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Jelajahi Berdasarkan Kategori', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF322219))),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 2.2, mainAxisSpacing: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final count = globalStories.where((s) => s.category.toLowerCase() == (cat['name'] as String).toLowerCase()).length;
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: cat['color'] as Color,
                  child: InkWell(
                    onTap: () => onSelectCategory(cat['name'] as String),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(cat['icon'] as String, style: const TextStyle(fontSize: 50)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cat['name'] as String, style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                Text(cat['desc'] as String, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                                  child: Text('$count Cerita Terdaftar', style: GoogleFonts.poppins(color: Colors.white, fontSize: 11)),
                                )
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class FavoriteStoriesScreen extends StatelessWidget {
  final Function(Story) onSelectStory;

  const FavoriteStoriesScreen({Key? key, required this.onSelectStory}) : super(key: key);

  Widget _buildCardImage(Story story) {
    if (story.imageBytes != null) {
      return Image.memory(story.imageBytes!, fit: BoxFit.cover, width: double.infinity);
    } else if (story.imageFile != null) {
      return Image.file(story.imageFile!, fit: BoxFit.cover, width: double.infinity);
    } else if (story.imageUrl != null && story.imageUrl!.isNotEmpty) {
      return Image.network(
        story.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Center(child: Text(story.iconEmoji, style: const TextStyle(fontSize: 60))),
      );
    }
    return Center(child: Text(story.iconEmoji, style: const TextStyle(fontSize: 60)));
  }

  @override
  Widget build(BuildContext context) {
    final favList = globalStories.where((s) => s.isFavorite).toList();

    return favList.isEmpty
        ? Center(child: Text('Belum ada cerita favorit.', style: GoogleFonts.poppins(color: Colors.grey)))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favList.length,
            itemBuilder: (context, index) {
              final story = favList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => onSelectStory(story),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 160,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(story.title, style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF2A1B12))),
                                Text('Asal: ${story.region}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
                              ],
                            ),
                            const Icon(Icons.favorite, color: Colors.red, size: 28),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

class AccountProfileScreen extends StatelessWidget {
  final String userEmail;
  final String userRole;
  final VoidCallback onLogout;

  const AccountProfileScreen({
    Key? key,
    required this.userEmail,
    required this.userRole,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Color(0xFF322219), shape: BoxShape.circle),
            child: Icon(
              userRole == 'admin' ? Icons.admin_panel_settings : Icons.person,
              size: 60,
              color: const Color(0xFFE5A93C),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            userEmail,
            style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF322219)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: userRole == 'admin' ? Colors.red.shade800 : const Color(0xFF322219),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'ROLE: ${userRole.toUpperCase()}',
              style: GoogleFonts.poppins(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),

          ListTile(
            leading: const Icon(Icons.email, color: Color(0xFF322219)),
            title: Text('Email Terdaftar', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            subtitle: Text(userEmail, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF322219))),
          ),
          const Divider(),

          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: onLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: Text('Keluar (Logout)', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}