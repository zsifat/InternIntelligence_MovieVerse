import 'package:flutter/material.dart';
import 'package:movie_app/views/login_screen.dart';
import 'package:movie_app/views/movie_home_screen.dart';
import 'package:movie_app/views/profile_screen.dart';
import 'package:movie_app/views/savedOrWatched_sceen.dart';
import 'package:movie_app/views/search_movie_screen.dart';
import 'package:movie_app/views/signup_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentIndex = 0;

  // Pages for each Bottom Navigation Bar item
  final List<Widget> _pages = [
    const HomeScreen(),
    SearchScreen(),
    const SavedOrWatchedScreen(),
    const SavedOrWatchedScreen(isHistory: true,),
    const ProfilePage(),
  ];

  // Handles the tap event on the Bottom Navigation Bar items
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Allows 5 items
        selectedItemColor: Colors.blue, // Active item color
        unselectedItemColor: Colors.grey, // Inactive item color
        showUnselectedLabels: true, // Display labels for unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}