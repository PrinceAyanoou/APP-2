import 'package:flutter/material.dart';
import '../main.dart';
import '../services/api.dart';
import 'profile_page.dart';
import 'requests_page.dart';
import 'new_request_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    ProfilePage(),
    RequestsPage(),
    NewRequestPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final completeness = app.profile.completenessPercentage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('APP-2'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text('$completeness%',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer)),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                        width: 100,
                        child:
                            LinearProgressIndicator(value: completeness / 100)),
                  ],
                ),
                const SizedBox(width: 12),
                IconButton(
                    tooltip: 'Se déconnecter',
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      AppStateScope.of(context).clearAuth();
                      Navigator.pushReplacementNamed(context, '/');
                    }),
              ],
            ),
          )
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Demandes'),
          NavigationDestination(
              icon: Icon(Icons.edit), label: 'Faire une demande'),
        ],
      ),
    );
  }
}
