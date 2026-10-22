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
  bool _isLoggedIn = false;
  String _userEmail = '';
  String _userRole = 'member';
  int _currentIndex = 0;
  Story? _selectedStory;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email dan Password wajib diisi!')));
      return;
    }

    setState(() {
      _userEmail = _emailController.text;
      if (_userEmail.toLowerCase().contains('admin')) {
        _userRole = 'admin';
      } else {
        _userRole = 'member';
      }
      _isLoggedIn = true;
      _currentIndex = 0;
      _selectedStory = null;
    });
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false;
      _userEmail = '';
      _emailController.clear();
      _passwordController.clear();
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
          return AccountProfileScreen(userEmail: _userEmail, userRole: _userRole, onLogout: _logout);
        default:
          return const AdminDashboardScreen();
      }
    } else {
      switch (_currentIndex) {
        case 0:
          return GuestHomeScreen(onSelectStory: (s) => setState(() => _selectedStory = s));
        case 1:
          return CategoryViewScreen(onSelectCategory: (catName) {
            setState(() => _currentIndex = 0);
          });
        case 2:
          return FavoriteStoriesScreen(onSelectStory: (s) => setState(() => _selectedStory = s));
        case 3:
          return AccountProfileScreen(userEmail: _userEmail, userRole: _userRole, onLogout: _logout);
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
      home: !_isLoggedIn
          ? Scaffold(
              backgroundColor: const Color(0xFF322219),
              body: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.menu_book_rounded, color: Color(0xFFE5A93C), size: 70),
                      const SizedBox(height: 10),
                      Text('KisahLoka', style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('Platform Edukasi Budaya Nusantara', style: GoogleFonts.poppins(color: const Color(0xFFD3C5BB), fontSize: 13)),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: [
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(labelText: 'Email / Username', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '*Gunakan email yang mengandung kata "admin" untuk masuk sebagai Admin.',
                                style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF322219)),
                                child: Text('MASUK KE APLIKASI', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF322219),
                elevation: 0,
                title: Row(
                  children: [
                    const Icon(Icons.menu_book_rounded, color: Color(0xFFE5A93C), size: 26),
                    const SizedBox(width: 8),
                    Text(
                      'KisahLoka (${_userRole.toUpperCase()})',
                      style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
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