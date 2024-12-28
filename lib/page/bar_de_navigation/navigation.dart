import 'package:flutter/material.dart';
import 'package:ventou/page/menu.dart';
import 'package:ventou/page/publication/publication.dart';
import 'package:ventou/page/screens/home/home_screen.dart';

class VentouMainScreen extends StatefulWidget {
  @override
  _VentouMainScreenState createState() => _VentouMainScreenState();
}

class _VentouMainScreenState extends State<VentouMainScreen> {
  int _currentIndex = 2; // Index 2 correspond à l'accueil (icône maison)

  final List<Widget> _pages = [
    const ProfileScreen(),
    const PlaceholderPage(title: 'Recherche'),
    const HomeScreen(), // Correction ici : HomeScreen() au lieu de HomeScreen
    const PlaceholderPage(title: 'Cadeaux'),
    const PublicationHomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Logique pour revenir en arrière
          },
        ),
        title: Image.asset(
          'images/logo.png',
          height: 25,
        ),
        actions: [
          Image.asset(
            'images/menu.png',
            width: 24,
          ),
          const SizedBox(width: 16),
        ],
        backgroundColor: Colors.white,
        elevation: 10,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Color(0xFFFFA500), // Couleur orange
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.card_giftcard), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.production_quantity_limits_outlined),
                  label: ''),
            ],
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: const TextStyle(fontSize: 24)),
    );
  }
}
