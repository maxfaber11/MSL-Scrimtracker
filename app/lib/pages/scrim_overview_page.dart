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

  void _showAgentSelector(BuildContext context, Function(Agent?) onSelect) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF0B1722),
        title: const Text('Select Agent', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: 300,
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('None', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    onSelect(null);
                    Navigator.of(c).pop();
                  },
                ),
                ...Agent.values.map((agent) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.transparent,
                      backgroundImage: agent.imageUrl == null ? null : NetworkImage(agent.imageUrl!),
                      child: agent.imageUrl == null
                          ? Text(agent.displayName.substring(0, 1), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))
                          : null,
                    ),
                    title: Text(agent.displayName, style: const TextStyle(color: Colors.white)),
                    onTap: () {
                      onSelect(agent);
                      Navigator.of(c).pop();
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddDialog() {
    DateTime selectedDate = DateTime.now();
    GameMap selectedMap = GameMap.Ascent;
    String teamName = '';
    String enemyTier = 'T1';
    List<Agent?> ourComp = List.filled(5, null);
    List<Agent?> theirComp = List.filled(5, null);
    int ourRoundsWon = 0;
    int theirRoundsWon = 0;
    int ourRoundsPlayedAttack = 12;
    int ourRoundsPlayedDefense = 12;
    bool ourAtkPistolWin = false;
    bool ourDefPistolWin = false;
    String result = 'draw';
    String startingSide = 'attack';

    final tierColors = <String, Color>{
      'T1': const Color(0xFFE74C3C),
      'T2': const Color(0xFFE67E22),
      'T3': const Color(0xFF3498DB),
      'GC T1': const Color(0xFF2ECC71),
      'GC T2': const Color(0xFF9B59B6),
    };

    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF0B1722),
          title: const Text('Add Scrim', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 600,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date picker
                  Text('Date', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => selectedDate = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        selectedDate.toLocal().toIso8601String().split('T').first,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Map selector
                  Text('Map', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<GameMap>(
                    value: selectedMap,
                    dropdownColor: const Color(0xFF0B1722),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal.shade300)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: GameMap.values
                        .map((map) => DropdownMenuItem(
                              value: map,
                              child: Text(
                                map.toString().split('.').last,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => selectedMap = value!),
                  ),
                  const SizedBox(height: 16),

                  // Enemy Team + Tier
                  Text('Enemy Team', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) => teamName = value,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal.shade300)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            hintText: 'Team name',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 150,
                        child: DropdownButtonFormField<String>(
                          value: enemyTier,
                          dropdownColor: const Color(0xFF0B1722),
                          borderRadius: BorderRadius.circular(28),
                          iconEnabledColor: Colors.white,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: tierColors[enemyTier]!.withOpacity(0.22),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(999),
                              borderSide: BorderSide(color: tierColors[enemyTier]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(999),
                              borderSide: BorderSide(color: tierColors[enemyTier]!, width: 1.4),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          items: tierColors.entries
                              .map(
                                (entry) => DropdownMenuItem(
                                  value: entry.key,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: entry.value,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        entry.key,
                                        style: TextStyle(color: entry.value, fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => enemyTier = value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Result selector
                  Text('Result', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: result,
                    dropdownColor: const Color(0xFF0B1722),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal.shade300)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: ['win', 'loss', 'draw']
                        .map((r) => DropdownMenuItem(
                              value: r,
                              child: Text(
                                r.toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => result = value!),
                  ),
                  const SizedBox(height: 16),

                  // Attack Rounds
                  Row(
                    children: [
                      Expanded(
                        child: Text('Attack', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Won', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontSize: 12)),
                            const SizedBox(height: 8),
                            TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) => ourRoundsWon = int.tryParse(value) ?? 0,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal.shade300)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Played', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontSize: 12)),
                            const SizedBox(height: 8),
                            TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) => ourRoundsPlayedAttack = int.tryParse(value) ?? 12,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal.shade300)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                hintText: '12',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Defense Rounds
                  Row(
                    children: [
                      Expanded(
                        child: Text('Defense', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Won', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontSize: 12)),
                            const SizedBox(height: 8),
                            TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) => theirRoundsWon = int.tryParse(value) ?? 0,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal.shade300)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Played', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontSize: 12)),
                            const SizedBox(height: 8),
                            TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) => ourRoundsPlayedDefense = int.tryParse(value) ?? 12,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal.shade300)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                hintText: '12',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Starting side
                  Text('Starting Side', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: startingSide,
                    dropdownColor: const Color(0xFF0B1722),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal.shade300)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: ['attack', 'defense']
                        .map((side) => DropdownMenuItem(
                              value: side,
                              child: Text(
                                side.toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => startingSide = value!),
                  ),
                  const SizedBox(height: 16),

                  // Pistol Wins
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('ATK Pistol Win', style: TextStyle(color: Colors.white, fontSize: 12)),
                          value: ourAtkPistolWin,
                          onChanged: (value) => setState(() => ourAtkPistolWin = value ?? false),
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('DEF Pistol Win', style: TextStyle(color: Colors.white, fontSize: 12)),
                          value: ourDefPistolWin,
                          onChanged: (value) => setState(() => ourDefPistolWin = value ?? false),
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Our Comp selector
                  Text('Our Comp', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () => _showAgentSelector(context, (agent) => setState(() => ourComp[index] = agent)),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.teal.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Center(
                                child: ourComp[index] == null
                                    ? Icon(Icons.add, color: Colors.grey.shade400, size: 24)
                                    : CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: ourComp[index]!.imageUrl == null ? null : NetworkImage(ourComp[index]!.imageUrl!),
                                        child: ourComp[index]!.imageUrl == null
                                            ? Text(ourComp[index]!.displayName.substring(0, 1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))
                                            : null,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  // Their Comp selector
                  Text('Their Comp', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () => _showAgentSelector(context, (agent) => setState(() => theirComp[index] = agent)),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.teal.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Center(
                                child: theirComp[index] == null
                                    ? Icon(Icons.add, color: Colors.grey.shade400, size: 24)
                                    : CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: theirComp[index]!.imageUrl == null ? null : NetworkImage(theirComp[index]!.imageUrl!),
                                        child: theirComp[index]!.imageUrl == null
                                            ? Text(theirComp[index]!.displayName.substring(0, 1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))
                                            : null,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(c).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Save scrim to database
                Navigator.of(c).pop();
                _refresh();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scrims')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 140.0, top: 16.0, bottom: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Scrim'),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 140.0, vertical: 6.0),
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
                margin: const EdgeInsets.symmetric(vertical: 4),
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
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: DefaultTextStyle.merge(
                            style: const TextStyle(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Text('${s.date.toLocal().toIso8601String().split('T').first} • $mapShort', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text(s.result.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      backgroundColor: resultColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
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
                                    const SizedBox(width: 6),
                                    Expanded(
                                      flex: 2,
                                      child: _RoundsPanel(
                                        label: 'Our rounds',
                                        value: totalRoundsWon,
                                        color: ourRoundsColor,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Column(
                                      children: [
                                        Text('Vs.', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
                                        const SizedBox(height: 2),
                                        Text(
                                          s.result.toUpperCase(),
                                          style: TextStyle(fontWeight: FontWeight.bold, color: resultColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      flex: 2,
                                      child: _RoundsPanel(
                                        label: 'Their rounds',
                                        value: opponentRoundsWon,
                                        color: theirRoundsColor,
                                        alignEnd: true,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
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
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(child: Text('Team: ${s.teamId}', style: const TextStyle(fontSize: 11))),
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
          ),
        ],
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
