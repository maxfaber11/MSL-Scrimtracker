import 'package:flutter/material.dart';
import 'package:msl_scrimtracker/models/scrim.dart';
import 'package:msl_scrimtracker/services/scrim_repository.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final ScrimRepository _repo = ScrimRepository();
  late Future<List<Scrim>> _scrimsFuture;

  @override
  void initState() {
    super.initState();
    _scrimsFuture = _repo.getAllScrims();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Scrim>>(
      future: _scrimsFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
        final scrims = snap.data ?? [];
          final total = scrims.length;
          final roundsWon = scrims.fold<int>(0, (acc, s) => acc + s.roundsWonAttack + s.roundsWonDefense);
          final roundsPlayed = scrims.fold<int>(0, (acc, s) => acc + s.roundsPlayedAttack + s.roundsPlayedDefense);
          final defPistolWins = scrims.where((s) => s.defPistolWin).length;
          final atkPistolWins = scrims.where((s) => s.atkPistolWin).length;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total scrims: $total', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Rounds won: $roundsWon', style: Theme.of(context).textTheme.bodyLarge),
                Text('Rounds played: $roundsPlayed', style: Theme.of(context).textTheme.bodyLarge),
                Text('Defense pistol wins: $defPistolWins', style: Theme.of(context).textTheme.bodyLarge),
                Text('Attack pistol wins: $atkPistolWins', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),
                const Text('Map breakdown', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: _mapBreakdown(scrims).entries.map((e) => ListTile(title: Text('${e.key}: ${e.value}'))).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      );
  }

  Map<String, int> _mapBreakdown(List<Scrim> scrims) {
    final counts = <String, int>{};
    for (final s in scrims) {
      final key = s.map.toString().split('.').last;
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }
}
