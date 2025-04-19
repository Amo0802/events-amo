// import 'package:flutter/material.dart';

import 'package:events_amo/pages/comunity_events_page.dart';
import 'package:events_amo/createEvent/create_event_menu.dart';
import 'package:events_amo/pages/home_page.dart';
import 'package:events_amo/pages/profile_page.dart';
import 'package:events_amo/pages/search_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  bool _isCreateMenuOpen = false;
  
  final List<Widget> _pages = [
    HomePage(),
    CommunityEventsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          if (_isCreateMenuOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCreateMenuOpen = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: CreateEventMenu(
                    onClose: () {
                      setState(() {
                        _isCreateMenuOpen = false;
                      });
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF171C30),
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Home button
              IconButton(
                icon: Icon(
                  Icons.home_outlined,
                  color: _currentIndex == 0 ? Theme.of(context).colorScheme.secondary : Colors.white60,
                  size: 28,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              // Community Events button
              IconButton(
                icon: Icon(
                  Icons.explore_outlined,
                  color: _currentIndex == 1 ? Theme.of(context).colorScheme.secondary : Colors.white60,
                  size: 28,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              // Spacer for FAB
              SizedBox(width: 60),
              // Search button
              IconButton(
                icon: Icon(
                  Icons.search_outlined,
                  color: Colors.white60,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
              ),
              // Profile button
              IconButton(
                icon: Icon(
                  Icons.person_outline,
                  color: _currentIndex == 2 ? Theme.of(context).colorScheme.secondary : Colors.white60,
                  size: 28,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          _isCreateMenuOpen ? Icons.close : Icons.add,
          size: 30,
        ),
        onPressed: () {
          setState(() {
            _isCreateMenuOpen = !_isCreateMenuOpen;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
