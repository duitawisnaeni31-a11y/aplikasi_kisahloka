import 'package:flutter/material.dart';
import 'models/app_models.dart';
import 'views/guest_views.dart';
import 'views/member_views.dart';
import 'views/admin_views.dart';

void main() {
  runApp(const KisahLokaApp());
}

class KisahLokaApp extends StatefulWidget {
  const KisahLokaApp({super.key});

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KisahLoka',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF6EE),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C2C16),
          primary: const Color(0xFF5C2C16),
          secondary: const Color(0xFF8B4513),
          surface: const Color(0xFFFFF8F0),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3D1E0B),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: Scaffold(
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
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
          return GuestHomeScreen(
            onSelectStory: (s) => setState(() => _selectedStory = s),
            onSwitchTab: (idx) => setState(() => _currentIndex = idx),
          );
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
          return const SizedBox();
      }
    } else if (_userRole == 'member') {
      switch (_currentIndex) {
        case 0:
          return MemberDashboardScreen(
            onLogout: () => _switchRole('guest'),
            onNavigateTab: (idx) => setState(() => _currentIndex = idx),
          );
        case 1:
          return const FavoriteMemberScreen();
        case 2:
          return SendStoryScreen(
            onSuccess: () => setState(() => _currentIndex = 0),
          );
        case 3:
          return AdminProfileScreen(onLogout: () => _switchRole('guest'));
        default:
          return const SizedBox();
      }
    } else {
      switch (_currentIndex) {
        case 0:
          return AdminDashboardScreen(onSwitchTab: (idx) => setState(() => _currentIndex = idx));
        case 1:
          return const AdminModerationScreen();
        case 2:
          return const AdminManageStoriesScreen();
        case 3:
          return AdminProfileScreen(onLogout: () => _switchRole('guest'));
        default:
          return const SizedBox();
      }
    }
  }

  Widget _buildBottomNav() {
    List<BottomNavigationBarItem> items = [];

    if (_userRole == 'guest') {
      items = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Peta'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Masuk'),
      ];
    } else if (_userRole == 'member') {
      items = const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dasbor'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Kirim Cerita'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ];
    } else {
      items = const [
        BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Dasbor Admin'),
        BottomNavigationBarItem(icon: Icon(Icons.fact_check), label: 'Moderasi'),
        BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Kelola Cerita'),
        BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Keluar'),
      ];
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFD4C3B3), width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2D1B10),
        selectedItemColor: const Color(0xFFFFC107),
        unselectedItemColor: Colors.white70,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: items,
      ),
    );
  }
}