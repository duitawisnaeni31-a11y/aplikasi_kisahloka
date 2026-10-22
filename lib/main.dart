import 'package:flutter/material.dart';
import 'models/app_models.dart';
import 'views/guest_views.dart';
import 'views/member_views.dart';
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

    if (_userRole == 'guest') {
      switch (_currentIndex) {
        case 0:
        case 1:
          return GuestHomeScreen(
            onSelectStory: (s) => setState(() => _selectedStory = s),
            onSwitchTab: (idx) => setState(() => _currentIndex = idx),
          );
        case 2:
          return GuestExploreScreen(
            onSelectStory: (s) => setState(() => _selectedStory = s),
          );
        case 3:
          return GuestAccountScreen(
            onLoginMember: () => _switchRole('member'),
            onLoginAdmin: () => _switchRole('admin'),
          );
        default:
          return GuestHomeScreen(
            onSelectStory: (s) => setState(() => _selectedStory = s),
            onSwitchTab: (idx) => setState(() => _currentIndex = idx),
          );
      }
    } else {
      // Tampilan Member / Admin
      switch (_currentIndex) {
        case 0:
          return GuestHomeScreen(
            onSelectStory: (s) => setState(() => _selectedStory = s),
            onSwitchTab: (idx) => setState(() => _currentIndex = idx),
          );
        case 1:
          return const SendStoryScreen();
        default:
          return Center(
            child: ElevatedButton(
              onPressed: () => _switchRole('guest'),
              child: const Text('Keluar / Switch Ke Guest'),
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KisahLoka',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFFF5EFE6),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF3C2A21),
          title: const Text('KisahLoka', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.person, color: Colors.amber),
              onSelected: _switchRole,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'guest', child: Text('Mode Guest')),
                PopupMenuItem(value: 'member', child: Text('Mode Member')),
                PopupMenuItem(value: 'admin', child: Text('Mode Admin')),
              ],
            )
          ],
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.grey,
          backgroundColor: const Color(0xFF3C2A21),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _selectedStory = null;
            });
          },
          items: _userRole == 'guest'
              ? const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
                  BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
                  BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Peta'),
                  BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Akun'),
                ]
              : const [
                  BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dasbor'),
                  BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Tulis Cerita'),
                  BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Akun'),
                ],
        ),
      ),
    );
  }
}