import 'package:flutter/material.dart';
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
          // Banner Utama Responsif
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF3C2A21),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Jelajahi Cerita &\nWarisan Nusantara',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Platform digital edukasi budaya dan legenda rakyat Indonesia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildChip('MTS : Mitos', const Color(0xFFD35400)),
                      const SizedBox(width: 8),
                      _buildChip('LGN : Legenda', const Color(0xFFE67E22)),
                      const SizedBox(width: 8),
                      _buildChip('SJR : Sejarah', const Color(0xFF27AE60)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Filter Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.brown.shade200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedCategoryFilter,
                items: ['Semua', 'Legenda', 'Mitos', 'Sejarah'].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text('Filter Kategori: $category'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => selectedCategoryFilter = val);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Judul Katalog
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                Icon(Icons.explore, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'KATALOG CERITA POPULER',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3C2A21)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // List Cerita
          filteredStories.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: const Text('Belum ada cerita dalam kategori ini.'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredStories.length,
                  itemBuilder: (context, index) {
                    final story = filteredStories[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: InkWell(
                        onTap: () => widget.onSelectStory(story),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              ),
                              child: story.imageBytes != null
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: Image.memory(story.imageBytes!, fit: BoxFit.cover),
                                    )
                                  : story.imageFile != null
                                      ? ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                          child: Image.file(story.imageFile!, fit: BoxFit.cover),
                                        )
                                      : Center(
                                          child: Text(story.iconEmoji, style: const TextStyle(fontSize: 60)),
                                        ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3C2A21),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      story.category.toUpperCase(),
                                      style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    story.title,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3C2A21)),
                                  ),
                                  Text(
                                    'Asal: ${story.region}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}

class GuestExploreScreen extends StatelessWidget {
  final Function(Story) onSelectStory;
  const GuestExploreScreen({Key? key, required this.onSelectStory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: globalStories.length,
      itemBuilder: (context, index) {
        final story = globalStories[index];
        return Card(
          child: ListTile(
            leading: Text(story.iconEmoji, style: const TextStyle(fontSize: 30)),
            title: Text(story.title),
            subtitle: Text('${story.category} • ${story.region}'),
            onTap: () => onSelectStory(story),
          ),
        );
      },
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
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3C2A21)),
              child: const Text('Masuk sebagai Member', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onLoginAdmin,
              child: const Text('Masuk sebagai Admin'),
            ),
          ],
        ),
      ),
    );
  }
}