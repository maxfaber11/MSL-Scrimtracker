import 'package:flutter/material.dart';
import 'package:msl_scrimtracker/models/scrim.dart';
import 'package:msl_scrimtracker/models/map_enum.dart';
import 'package:msl_scrimtracker/models/agent_enum.dart';

class ScrimDetailPage extends StatelessWidget {
  const ScrimDetailPage({super.key, required this.scrim});

  final Scrim scrim;

  @override
  Widget build(BuildContext context) {
    final mapShort = scrim.map.toString().split('.').last;
    final mapImage = scrim.map.imageUrl;
    final totalRoundsWon = scrim.roundsWonAttack + scrim.roundsWonDefense;
    final totalRoundsPlayed = scrim.roundsPlayedAttack + scrim.roundsPlayedDefense;

    Widget buildComp(String title, List<Agent> agents, Color accent) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: agents.map((a) {
              final imageUrl = a.imageUrl;
              return Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: imageUrl == null ? null : NetworkImage(imageUrl),
                  child: imageUrl == null ? Text(a.displayName.substring(0, 1)) : null,
                ),
                label: Text(a.displayName),
                backgroundColor: accent.withOpacity(0.08),
                side: BorderSide(color: accent.withOpacity(0.25)),
              );
            }).toList(),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scrim Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (mapImage != null)
              SizedBox(
                height: 180,
                child: Image.network(mapImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200)),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('${scrim.date.toLocal().toIso8601String().split('T').first} • $mapShort', style: const TextStyle(fontWeight: FontWeight.w700))),
                      Chip(label: Text(scrim.result.toUpperCase(), style: const TextStyle(color: Colors.white)), backgroundColor: scrim.result == 'win' ? Colors.green : (scrim.result == 'loss' ? Colors.red : Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text('Team: ${scrim.teamId}', style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 6),
                  Text('Enemy Tier: ${scrim.enemyTier} • Starting: ${scrim.startingSide}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Attack', style: TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 8),
                                Text('Won: ${scrim.roundsWonAttack}'),
                                Text('Played: ${scrim.roundsPlayedAttack}'),
                                const SizedBox(height: 6),
                                Text('Pistol Win: ${scrim.atkPistolWin ? 'Y' : 'N'}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Defense', style: TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 8),
                                Text('Won: ${scrim.roundsWonDefense}'),
                                Text('Played: ${scrim.roundsPlayedDefense}'),
                                const SizedBox(height: 6),
                                Text('Pistol Win: ${scrim.defPistolWin ? 'Y' : 'N'}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Text('Total Rounds Won: $totalRoundsWon / $totalRoundsPlayed', style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),

                  buildComp('Our Comp', scrim.ourComp, Colors.green.shade300),
                  const SizedBox(height: 12),
                  buildComp('Their Comp', scrim.theirComp, Colors.red.shade300),

                  const SizedBox(height: 16),
                  const Text('Player Stats', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('No player-specific stats yet.'),
                          SizedBox(height: 6),
                          Text('You can add individual player stats here in the future.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
