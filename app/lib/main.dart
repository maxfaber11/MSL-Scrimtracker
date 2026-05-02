import 'package:flutter/material.dart';
import 'package:msl_scrimtracker/services/scrim_repository.dart';
import 'package:msl_scrimtracker/pages/scrim_overview_page.dart';
import 'package:msl_scrimtracker/pages/stats_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MSL ScrimTracker',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xFF071020),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF071020),
          foregroundColor: Colors.white,
        ),
        cardTheme: ThemeData.dark().cardTheme.copyWith(
          color: const Color(0xFF0B1722),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF12242F),
          selectedColor: Colors.teal.shade700,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: const Color(0xFF071020),
          selectedIconTheme: IconThemeData(color: Colors.teal.shade300),
          unselectedIconTheme: IconThemeData(color: Colors.grey.shade400),
          labelType: NavigationRailLabelType.all,
        ),
        textTheme: ThemeData.dark().textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _index = 0;
  final ScrimRepository _repo = ScrimRepository();

  Widget _pageForIndex(int index) {
    switch (index) {
      case 0:
        return const ScrimOverviewPage();
      case 1:
        return const StatsPage();
      default:
        return const ScrimOverviewPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.list), label: Text('Scrims')),
              NavigationRailDestination(icon: Icon(Icons.bar_chart), label: Text('Stats')),
            ],
          ),
          Expanded(child: _pageForIndex(_index)),
        ],
      ),
    );
  }
}
