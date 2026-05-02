import 'package:flutter/material.dart';
import 'package:msl_scrimtracker/models/map_enum.dart';
import 'package:msl_scrimtracker/models/scrim.dart';
import 'package:msl_scrimtracker/models/team.dart';
import 'package:msl_scrimtracker/models/player.dart';
import 'package:msl_scrimtracker/models/agent_enum.dart';
import 'package:msl_scrimtracker/pages/stats_page.dart';
import 'package:msl_scrimtracker/services/scrim_repository.dart';

class ScrimOverviewPage extends StatefulWidget {
  const ScrimOverviewPage({super.key});

  @override
  State<ScrimOverviewPage> createState() => _ScrimOverviewPageState();
}

class _ScrimOverviewPageState extends State<ScrimOverviewPage> {
  final ScrimRepository _repo = ScrimRepository();
  List<Scrim> scrims = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final list = await _repo.getAllScrims();
    setState(() => scrims = list);
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Add scrim'),
        content: const Text('Add dialog not implemented yet.'),
        actions: [TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scrims')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
          child: ListView.builder(
            itemCount: scrims.length,
            itemBuilder: (context, i) {
              final s = scrims[i];
              final totalRoundsWon = s.roundsWonAttack + s.roundsWonDefense;
              final totalRoundsPlayed = s.roundsPlayedAttack + s.roundsPlayedDefense;
              final opponentRoundsWon = (totalRoundsPlayed - totalRoundsWon).clamp(0, totalRoundsPlayed);
              final mapShort = s.map.toString().split('.').last;
              final mapImageUrl = s.map.imageUrl;
              final resultColor = s.result == 'win' ? Colors.green : (s.result == 'loss' ? Colors.red : Colors.grey);

              Color roundsColor(int ourRounds, int theirRounds) {
                if (ourRounds > theirRounds) return Colors.green;
                if (ourRounds < theirRounds) return Colors.red;
                return Colors.amber;
              }

              final ourRoundsColor = roundsColor(totalRoundsWon, opponentRoundsWon);
              final theirRoundsColor = roundsColor(opponentRoundsWon, totalRoundsWon);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: mapImageUrl == null
                              ? Container(color: Colors.blueGrey.shade100)
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: 0.48,
                                    alignment: Alignment.centerLeft,
                                    child: Transform.scale(
                                      scale: 1.12,
                                      alignment: Alignment.centerLeft,
                                      child: ShaderMask(
                                        shaderCallback: (rect) => const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [Colors.white, Colors.white, Colors.white70, Colors.transparent],
                                          stops: [0.0, 0.35, 0.6, 0.95],
                                        ).createShader(rect),
                                        blendMode: BlendMode.dstIn,
                                        child: Image.network(
                                          mapImageUrl,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.centerLeft,
                                          errorBuilder: (context, error, stackTrace) => Container(color: Colors.blueGrey.shade100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),

                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.06),
                                  Colors.black.withOpacity(0.24),
                                  Colors.black.withOpacity(0.84),
                                ],
                                stops: const [0.0, 0.5, 0.78, 1.0],
                              ),
                            ),
                          ),
                        ),

                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.black.withOpacity(0.28),
                                  Colors.black.withOpacity(0.08),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.25, 0.6],
                              ),
                            ),
                          ),
                        ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          child: DefaultTextStyle.merge(
                            style: const TextStyle(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Text('${s.date.toLocal().toIso8601String().split('T').first} • $mapShort', style: const TextStyle(fontWeight: FontWeight.w600))),
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text(s.result.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      backgroundColor: resultColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: _CompPanel(
                                        title: 'Our comp',
                                        agents: s.ourComp,
                                        accentColor: Colors.green.shade300,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 2,
                                      child: _RoundsPanel(
                                        label: 'Our rounds',
                                        value: totalRoundsWon,
                                        color: ourRoundsColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      children: [
                                        Text('Vs.', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
                                        const SizedBox(height: 4),
                                        Text(
                                          s.result.toUpperCase(),
                                          style: TextStyle(fontWeight: FontWeight.bold, color: resultColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 2,
                                      child: _RoundsPanel(
                                        label: 'Their rounds',
                                        value: opponentRoundsWon,
                                        color: theirRoundsColor,
                                        alignEnd: true,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 4,
                                      child: _CompPanel(
                                        title: 'Their comp',
                                        agents: s.theirComp,
                                        accentColor: Colors.red.shade300,
                                        alignEnd: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(child: Text('Team: ${s.teamId}', style: const TextStyle(fontSize: 12))),
                                    Text('Played: $totalRoundsPlayed', style: const TextStyle(fontSize: 12)),
                                    const SizedBox(width: 12),
                                    Text('P DEF:${s.defPistolWin ? 'Y' : 'N'}', style: const TextStyle(fontSize: 12)),
                                    const SizedBox(width: 6),
                                    Text('P ATK:${s.atkPistolWin ? 'Y' : 'N'}', style: const TextStyle(fontSize: 12)),
                                            ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RoundsPanel extends StatelessWidget {
  const _RoundsPanel({
    required this.label,
    required this.value,
    required this.color,
    this.alignEnd = false,
  });

  final String label;
  final int value;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final alignment = alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}

class _CompPanel extends StatelessWidget {
  const _CompPanel({
    required this.title,
    required this.agents,
    required this.accentColor,
    this.alignEnd = false,
  });

  final String title;
  final List<Agent> agents;
  final Color accentColor;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          alignment: alignEnd ? WrapAlignment.end : WrapAlignment.start,
          children: agents.map((agent) {
            final imageUrl = agent.imageUrl;
            return Chip(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              avatar: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: imageUrl == null ? null : NetworkImage(imageUrl),
                child: imageUrl == null ? Text(agent.displayName.substring(0, 1), style: const TextStyle(fontSize: 10)) : null,
              ),
              label: Text(agent.displayName, style: const TextStyle(fontSize: 11)),
              side: BorderSide(color: accentColor.withOpacity(0.25)),
              backgroundColor: accentColor.withOpacity(0.08),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CompSelector extends StatelessWidget {
  const _CompSelector({
    required this.title,
    required this.selectedAgents,
    required this.onChanged,
  });

  final String title;
  final List<Agent?> selectedAgents;
  final void Function(int index, Agent? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        ...List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: DropdownButtonFormField<Agent>(
              value: selectedAgents[index],
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Agent ${index + 1}',
                border: const OutlineInputBorder(),
              ),
              items: Agent.values
                  .map((agent) => DropdownMenuItem(
                        value: agent,
                        child: Row(
                          children: [
                            _AgentPreview(agent: agent),
                            const SizedBox(width: 10),
                            Text(agent.displayName),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (value) => onChanged(index, value),
            ),
          );
        }),
      ],
    );
  }
}

class _AgentPreview extends StatelessWidget {
  const _AgentPreview({required this.agent});

  final Agent agent;

  @override
  Widget build(BuildContext context) {
    final imageUrl = agent.imageUrl;
    return CircleAvatar(
      radius: 11,
      backgroundColor: Colors.blueGrey.shade50,
      backgroundImage: imageUrl == null ? null : NetworkImage(imageUrl),
      child: imageUrl == null
          ? Text(
              agent.displayName.substring(0, 1),
              style: const TextStyle(fontSize: 10),
            )
          : null,
    );
  }
}
