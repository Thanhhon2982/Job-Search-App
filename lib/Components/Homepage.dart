// ignore_for_file: must_be_immutable, file_names, use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;

  // Define the pages for each tab
  final List<Widget> _pages = [
    Center(child: Text('Chào mừng trở lại trang chủ!')),
  ];

  void _onTabTapped(int index) {}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text('Trang chủ'),
              actions: [
                if (user != null)
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
              ],
            ),
            body: _pages[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Trang chủ',
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
