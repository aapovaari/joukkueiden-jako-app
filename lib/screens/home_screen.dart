import 'package:flutter/material.dart';
import 'package:joukkueiden_jako/screens/player_list_screen.dart';
import 'package:joukkueiden_jako/screens/team_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [PlayerlistScreen(), TeamScreen()];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (int newIndex) {
          selectedIndex = newIndex;
          setState(() {});
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Pelaajat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Joukkueet',
          ),
        ],
      ),
    );
  }
}
