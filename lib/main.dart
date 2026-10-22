import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/app_models.dart';
import 'views/admin_views.dart';
import 'views/guest_views.dart';
import 'views/story_detail_view.dart';

void main() {
  runApp(const KisahLokaApp());
}

class KisahLokaApp extends StatefulWidget {
  const KisahLokaApp({Key? key}) : super(key: key);

  @override
  State<KisahLokaApp> createState() => _KisahLokaAppState();
}

class _KisahLokaAppState extends State<KisahLokaApp> {
  String _userRole = 'guest';
  int _currentIndex = 0;
  Story? _selectedStory;

  void _switchRole(String role) {
    setState(() {
      _userRole = role;
      _currentIndex = 0;
      _selectedStory = null;
    });
  }

  Widget _buildBody() {
    if (_selectedStory != null) {
      return GuestDetailScreen(
        story: _selectedStory!,
        onBack: () => setState(() => _selectedStory = null),
      );
    }

    if (_userRole == 'admin') {
      switch (_currentIndex) {
        case 0:
          return const AdminDashboardScreen();
        case 1:
          return const AddStoryScreen();
        case 2:
          return GuestAccountScreen(
            onLoginMember: () => _switchRole('member'),
            onLoginAdmin: () => _switchRole('admin'),
          );
        default:
          return const AdminDashboardScreen();
      }
    } else {
      switch (_currentIndex) {
        case 0:
          return GuestHomeScreen(onSelectStory: (s) => setState(() => _selectedStory = s));
        case 1:
          return CategoryViewScreen(onSelectCategory: (catName) {
            setState(() {
              _currentIndex = 0;
            });
          });
        case 2:
          return FavoriteStoriesScreen(onSelectStory: (s) => setState(() => _selectedStory = s));
        case 3:
          return GuestAccountScreen(
            onLoginMember: () => _switchRole('member'),
            onLoginAdmin: () => _switchRole('admin'),
          );
        default:
          return GuestHomeScreen(onSelectStory: (s) => setState(() => _selectedStory = s));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KisahLoka',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F6EE),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF322219),
          elevation: 0,
          title: Row(
            children: [
              const Icon(Icons.menu_book_rounded, color: Color(0xFFE5A93C), size: 26),
              const SizedBox(width: 8),
              Text(
                'KisahLoka ${_userRole != 'guest' ? '(${_userRole.toUpperCase()})' : ''}',
                style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person, color: Color(0xFFE5A93C)),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Mode Guest / Pengguna', style: GoogleFonts.poppins()),
                          onTap: () {
                            _switchRole('guest');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Mode Member', style: GoogleFonts.poppins()),
                          onTap: () {
                            _switchRole('member');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Mode Admin (Bisa Tambah Cerita)', style: GoogleFonts.poppins()),
                          onTap: () {
                            _switchRole('admin');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFFE5A93C),
          unselectedItemColor: const Color(0xFFA08B7D),
          backgroundColor: const Color(0xFF322219),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _selectedStory = null;
            });
          },
          items: _userRole == 'admin'
              ? const [
                  BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dasbor'),
                  BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Tulis Cerita'),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
                ]
              : const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
                  BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
                  BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
                ],
        ),
      ),
    );
  }
}