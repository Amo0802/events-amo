import 'package:events_amo/pages/comunity_events_page.dart';
import 'package:events_amo/widgets/create_event_menu.dart';
import 'package:events_amo/pages/home_page.dart';
import 'package:events_amo/pages/login_page.dart';
import 'package:events_amo/pages/profile_page.dart';
import 'package:events_amo/pages/search_page.dart';
import 'package:events_amo/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  bool _isCreateMenuOpen = false;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [HomePage(), CommunityEventsPage(), ProfilePage()];
  }

  void _onTabSelected(int index) {
    final authProvider = context.read<AuthProvider>();

    if (index == 2) {
      if (authProvider.status == AuthStatus.authenticated) {
        setState(() {
          _currentIndex = 2;
        });
      } else {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => LoginPage()));
      }
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _toggleCreateMenu() {
    setState(() {
      _isCreateMenuOpen = !_isCreateMenuOpen;
    });
  }

  void _openSearchPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchPage()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color iconColor(int index) {
      return _currentIndex == index
          ? theme.colorScheme.secondary
          : Colors.white60;
    }


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _pages),
          if (_isCreateMenuOpen)
            GestureDetector(
              onTap: _toggleCreateMenu,
              child: Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: CreateEventMenu(onClose: _toggleCreateMenu),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF171C30),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home_outlined, size: 28, color: iconColor(0)),
                onPressed: () => _onTabSelected(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.explore_outlined,
                  size: 28,
                  color: iconColor(1),
                ),
                onPressed: () => _onTabSelected(1),
              ),
              const SizedBox(width: 60),
              IconButton(
                icon: const Icon(
                  Icons.search_outlined,
                  size: 28,
                  color: Colors.white60,
                ),
                onPressed: _openSearchPage,
              ),
              IconButton(
                icon: Icon(Icons.person_outline, size: 28, color: iconColor(2)),
                onPressed: () => _onTabSelected(2),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.tertiary,
        onPressed: _toggleCreateMenu,
        child: Icon(_isCreateMenuOpen ? Icons.close : Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
