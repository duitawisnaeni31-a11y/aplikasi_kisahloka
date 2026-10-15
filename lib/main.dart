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
  String _userRole = 'guest'; // 'guest', 'member', 'admin'
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
        default:
          return const SizedBox();
      }
    } else {
      // Peran Admin
      switch (_currentIndex) {
        case 0:
          return AdminDashboardScreen(onLogout: () => _switchRole('guest'));
        case 1:
          return const AdminModerationScreen();
        case 2:
          return const AdminStoryManageScreen();
        default:
          return const SizedBox();
      }
    }
  }

  Widget? _buildBottomNav() {
    if (_selectedStory != null) return null;

    if (_userRole == 'guest') {
      return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A0C05),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white60,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Peta'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      );
    } else if (_userRole == 'member') {
      return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A0C05),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white60,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dasbor'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Tulis Cerita'),
        ],
      );
    } else {
      return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A0C05),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white60,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Dasbor Admin'),
          BottomNavigationBarItem(icon: Icon(Icons.fact_check), label: 'Moderasi'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Kelola Cerita'),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KisahLoka',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3D2314)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }
}